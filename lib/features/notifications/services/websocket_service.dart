import 'dart:async';
import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../../core/util/app_logger.dart';
import '../data/models/notification.dart';

const _initialReconnectDelay = Duration(seconds: 5);
const _maxReconnectDelay = Duration(minutes: 1);
const _connectionTimeout = Duration(seconds: 10);

class WebSocketService {
  StompClient? _client;
  Timer? _reconnectTimer;
  String? _baseUrl;
  Duration _nextReconnectDelay = _initialReconnectDelay;
  bool _shouldReconnect = false;

  final String token;
  final void Function(AppNotification) onNotification;
  final void Function()? _onUnauthorized;
  final Future<String?> Function()? _readToken;

  WebSocketService({
    required this.token,
    required this.onNotification,
    void Function()? onUnauthorized,
    Future<String?> Function()? readToken,
  }) : _onUnauthorized = onUnauthorized,
       _readToken = readToken;

  void connect(String baseUrl) {
    _baseUrl = baseUrl;
    _shouldReconnect = true;
    _nextReconnectDelay = _initialReconnectDelay;
    unawaited(_activateClient(baseUrl));
  }

  Future<void> _activateClient(String baseUrl) async {
    _reconnectTimer?.cancel();

    final currentToken = await (_readToken?.call() ?? Future.value(token));
    if (!_shouldReconnect) return;

    if (currentToken == null || currentToken.isEmpty) {
      _handleUnauthorized();
      return;
    }

    final wsUrl = baseUrl
        .replaceFirst('http://', 'ws://')
        .replaceFirst('https://', 'wss://');

    _client = StompClient(
      config: StompConfig(
        url: '$wsUrl/ws-gym/websocket',
        onConnect: _onConnected,
        onDisconnect: (_) => AppLogger.w('WebSocket rozłączony'),
        onStompError: _handleStompError,
        onWebSocketError: (error) {
          AppLogger.w('WebSocket error: $error');
          if (_isUnauthorizedText(error.toString())) {
            _handleUnauthorized();
          }
        },
        onWebSocketDone: _scheduleReconnect,
        stompConnectHeaders: {'Authorization': 'Bearer $currentToken'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $currentToken'},
        reconnectDelay: Duration.zero,
        connectionTimeout: _connectionTimeout,
      ),
    );
    _client!.activate();
  }

  void _onConnected(StompFrame frame) {
    _nextReconnectDelay = _initialReconnectDelay;
    AppLogger.i('WebSocket połączony');
    _client!.subscribe(
      destination: '/user/queue/notifications',
      callback: (frame) {
        if (frame.body == null) return;
        AppLogger.i('Odebrano powiadomienie WebSocket');

        try {
          final json = jsonDecode(frame.body!);
          final notification = AppNotification.fromJson(json);
          onNotification(notification);
        } catch (_) {
          final notification = AppNotification(
            id: DateTime.now().millisecondsSinceEpoch,
            content: frame.body!,
            createdAt: DateTime.now(),
            read: false,
          );
          onNotification(notification);
        }
      },
    );
  }

  void _handleStompError(StompFrame frame) {
    AppLogger.e('STOMP błąd', frame);
    if (_isUnauthorizedFrame(frame)) {
      _handleUnauthorized();
    }
  }

  void _handleUnauthorized() {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _client?.deactivate();
    _client = null;
    _onUnauthorized?.call();
  }

  void _scheduleReconnect() {
    if (!_shouldReconnect || _baseUrl == null) return;

    final delay = _nextReconnectDelay;
    AppLogger.w('WebSocket reconnect za ${delay.inSeconds}s');

    _nextReconnectDelay = _nextDelay(delay);
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      if (_shouldReconnect && _baseUrl != null) {
        unawaited(_activateClient(_baseUrl!));
      }
    });
  }

  Duration _nextDelay(Duration current) {
    final nextMilliseconds = current.inMilliseconds * 2;
    if (nextMilliseconds >= _maxReconnectDelay.inMilliseconds) {
      return _maxReconnectDelay;
    }
    return Duration(milliseconds: nextMilliseconds);
  }

  bool _isUnauthorizedFrame(StompFrame frame) {
    final text = [
      frame.command,
      frame.body,
      ...frame.headers.entries.map((entry) => '${entry.key}:${entry.value}'),
    ].whereType<String>().join(' ');
    return _isUnauthorizedText(text);
  }

  bool _isUnauthorizedText(String text) {
    final lowerText = text.toLowerCase();
    return lowerText.contains('401') ||
        lowerText.contains('403') ||
        lowerText.contains('unauthorized') ||
        lowerText.contains('forbidden');
  }

  void disconnect() {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _client?.deactivate();
    _client = null;
  }
}
