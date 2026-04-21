import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final notificationsProvider =
AsyncNotifierProvider<NotificationsNotifier, List<AppNotification>>(
  NotificationsNotifier.new,
);

class NotificationsNotifier extends AsyncNotifier<List<AppNotification>> {
  WebSocketService? _wsService;

  @override
  Future<List<AppNotification>> build() async {
    final repo = ref.read(notificationRepositoryProvider);
    final history = await repo.getNotifications();

    AppLogger.i('📬 Historia: ${history.length} powiadomień');
    for (final n in history) {
      AppLogger.i('  → [${n.id}] ${n.content} (read: ${n.read})');
    }

    final token = ref.read(authTokenProvider);
    AppLogger.i('🔌 Łączę WebSocket z tokenem: ${token?.substring(0, 20)}...');

    if (token != null) {
      _wsService = WebSocketService(
        token: token,
        onNotification: _onNewNotification,
      );
      _wsService!.connect(Env.apiUrl);
    }

    ref.onDispose(() {
      _wsService?.disconnect();
    });

    return history;
  }

  void _onNewNotification(AppNotification notification) {
    final current = state.valueOrNull ?? [];
    state = AsyncData([notification, ...current]);

    ref.read(toastNotificationProvider.notifier).state = notification;

    LocalNotificationService.show(notification.id, notification.content);
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
      AppLogger.e('Błąd oznaczania powiadomienia jako przeczytane. Przywracam stan...', e);
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
      AppLogger.e('Błąd usuwania powiadomienia', e);
      state = AsyncData(backupList);
    }
  }

  int get unreadCount =>
      state.valueOrNull?.where((n) => !n.read).length ?? 0;
}

final unreadCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider).valueOrNull ?? [];
  return notifications.where((n) => !n.read).length;
});

final toastNotificationProvider = StateProvider<AppNotification?>((ref) => null);
