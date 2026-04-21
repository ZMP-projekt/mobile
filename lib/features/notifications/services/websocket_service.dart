
import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../../core/util/app_logger.dart';
import '../data/models/notification.dart';

class WebSocketService {
  StompClient? _client;
  final String token;
  final void Function(AppNotification) onNotification;

  WebSocketService({required this.token, required this.onNotification});

  void connect(String baseUrl) {
    final wsUrl = baseUrl
        .replaceFirst('http://', 'ws://')
        .replaceFirst('https://', 'wss://');

    _client = StompClient(
      config: StompConfig(
        url: '$wsUrl/ws-gym/websocket',
        onConnect: _onConnected,
        onDisconnect: (_) => AppLogger.w('WebSocket rozłączony'),
        onStompError: (frame) => AppLogger.e('STOMP błąd', frame),
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
        reconnectDelay: const Duration(seconds: 5),
      ),
    );
    _client!.activate();
  }

  void _onConnected(StompFrame frame) {
    AppLogger.i('WebSocket połączony ✅');
    _client!.subscribe(
      destination: '/user/queue/notifications',
      callback: (frame) {
        AppLogger.i('📨 WebSocket frame odebrany: ${frame.body}');
        if (frame.body == null) return;

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

  void disconnect() => _client?.deactivate();
}