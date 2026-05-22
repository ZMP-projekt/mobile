import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';

import '../../../core/auth/auth_token_store.dart';
import '../../../core/config/env.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/services/local_notification_service.dart';
import '../../../core/util/app_logger.dart';
import '../data/models/notification.dart';
import '../data/repositories/notification_repository.dart';
import '../services/websocket_service.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(dioProvider));
});

final appLifecycleStateProvider = StateProvider<AppLifecycleState>((ref) {
  return AppLifecycleState.resumed;
});

typedef LocalNotificationPresenter =
    Future<void> Function(int id, String content);

final localNotificationPresenterProvider = Provider<LocalNotificationPresenter>(
  (ref) => LocalNotificationService.show,
);

typedef WebSocketServiceFactory =
    WebSocketService Function({
      required String token,
      required void Function(AppNotification) onNotification,
      void Function()? onUnauthorized,
      Future<String?> Function()? readToken,
    });

final webSocketServiceFactoryProvider = Provider<WebSocketServiceFactory>((
  ref,
) {
  return ({
    required token,
    required onNotification,
    onUnauthorized,
    readToken,
  }) => WebSocketService(
    token: token,
    onNotification: onNotification,
    onUnauthorized: onUnauthorized,
    readToken: readToken,
  );
});

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<AppNotification>>(
      NotificationsNotifier.new,
    );

class NotificationsNotifier extends AsyncNotifier<List<AppNotification>> {
  WebSocketService? _wsService;

  @override
  Future<List<AppNotification>> build() async {
    final authToken =
        ref.watch(authTokenValueProvider) ??
        await ref.read(authTokenStoreProvider).read();

    if (authToken == null || authToken.isEmpty) {
      _disconnectWebSocket();
      return [];
    }

    final repo = ref.read(notificationRepositoryProvider);
    var history = <AppNotification>[];

    try {
      history = await repo.getNotifications();
      AppLogger.i('Pobrano historie powiadomien: ${history.length}');
    } catch (e) {
      AppLogger.w('Could not load notification history: $e');
    }

    _connectWebSocket(authToken);

    ref.onDispose(_disconnectWebSocket);

    return history;
  }

  void _connectWebSocket(String token) {
    _disconnectWebSocket();

    try {
      AppLogger.i('Laczenie z WebSocket powiadomien');
      _wsService = ref.read(webSocketServiceFactoryProvider)(
        token: token,
        onNotification: _onNewNotification,
        onUnauthorized: _onWebSocketUnauthorized,
        readToken: () => ref.read(authTokenStoreProvider).read(),
      );
      _wsService!.connect(Env.apiUrl);
    } catch (e) {
      AppLogger.w('Could not connect notification WebSocket: $e');
      _wsService = null;
    }
  }

  void _disconnectWebSocket() {
    _wsService?.disconnect();
    _wsService = null;
  }

  void _onWebSocketUnauthorized() {
    AppLogger.w('Notification WebSocket unauthorized. Clearing session token.');
    ref.read(authTokenStoreProvider).clear().catchError((Object error) {
      AppLogger.w('Could not clear token after WebSocket unauthorized: $error');
    });
  }

  void _onNewNotification(AppNotification notification) {
    final current = state.valueOrNull ?? [];
    state = AsyncData([notification, ...current]);

    final appLifecycleState = ref.read(appLifecycleStateProvider);
    final isForeground = appLifecycleState == AppLifecycleState.resumed;

    if (isForeground) {
      ref.read(toastNotificationProvider.notifier).state = notification;
    } else {
      ref
          .read(localNotificationPresenterProvider)(
            notification.id,
            notification.content,
          )
          .catchError((Object error) {
            AppLogger.w('Could not show local notification: $error');
          });
    }
  }

  Future<void> markAsRead(int id) async {
    final currentList = state.valueOrNull;
    if (currentList == null) return;

    final backupList = List<AppNotification>.from(currentList);

    state = AsyncData(
      currentList.map((n) => n.id == id ? n.copyWith(read: true) : n).toList(),
    );

    try {
      await ref.read(notificationRepositoryProvider).markAsRead(id);
    } catch (e) {
      AppLogger.e(
        'Blad oznaczania powiadomienia jako przeczytane. Przywracam stan...',
        e,
      );
      state = AsyncData(backupList);
    }
  }

  Future<void> deleteNotification(int id) async {
    final currentList = state.valueOrNull;
    if (currentList == null) return;

    final backupList = List<AppNotification>.from(currentList);

    state = AsyncData(currentList.where((n) => n.id != id).toList());

    try {
      await ref.read(notificationRepositoryProvider).deleteNotification(id);
    } catch (e) {
      AppLogger.e('Blad usuwania powiadomienia', e);
      state = AsyncData(backupList);
    }
  }

  int get unreadCount => state.valueOrNull?.where((n) => !n.read).length ?? 0;
}

final unreadCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider).valueOrNull ?? [];
  return notifications.where((n) => !n.read).length;
});

final toastNotificationProvider = StateProvider<AppNotification?>(
  (ref) => null,
);
