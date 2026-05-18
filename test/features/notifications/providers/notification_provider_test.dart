import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile_gym_app/core/auth/auth_token_store.dart';
import 'package:mobile_gym_app/core/config/env.dart';
import 'package:mobile_gym_app/features/notifications/data/models/notification.dart';
import 'package:mobile_gym_app/features/notifications/data/repositories/notification_repository.dart';
import 'package:mobile_gym_app/features/notifications/providers/notification_provider.dart';
import 'package:mobile_gym_app/features/notifications/services/websocket_service.dart';

class MockAuthTokenStore extends Mock implements AuthTokenStore {}

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

class FakeWebSocketService implements WebSocketService {
  @override
  final String token;

  @override
  final void Function(AppNotification) onNotification;

  final void Function()? onUnauthorized;

  String? connectedBaseUrl;
  bool disconnectCalled = false;

  FakeWebSocketService({
    required this.token,
    required this.onNotification,
    this.onUnauthorized,
  });

  @override
  void connect(String baseUrl) {
    connectedBaseUrl = baseUrl;
  }

  @override
  void disconnect() {
    disconnectCalled = true;
  }

  void triggerUnauthorized() => onUnauthorized?.call();
}

void main() {
  late MockAuthTokenStore tokenStore;
  late MockNotificationRepository repository;
  late FakeWebSocketService? webSocketService;

  AppNotification notification({
    required int id,
    required String content,
    required bool read,
  }) {
    return AppNotification(
      id: id,
      content: content,
      createdAt: DateTime(2026, 5, 9, 10),
      read: read,
    );
  }

  setUp(() {
    tokenStore = MockAuthTokenStore();
    repository = MockNotificationRepository();
    webSocketService = null;
    when(() => tokenStore.read()).thenAnswer((_) async => null);
    when(() => tokenStore.clear()).thenAnswer((_) async {});
    FlutterSecureStorage.setMockInitialValues({});
  });

  ProviderContainer createContainer({
    bool disposeOnTearDown = true,
    bool overrideTokenStore = true,
  }) {
    WebSocketService createWebSocketService({
      required String token,
      required void Function(AppNotification) onNotification,
      void Function()? onUnauthorized,
      Future<String?> Function()? readToken,
    }) {
      webSocketService = FakeWebSocketService(
        token: token,
        onNotification: onNotification,
        onUnauthorized: onUnauthorized,
      );
      return webSocketService!;
    }

    final container = ProviderContainer(
      overrides: [
        notificationRepositoryProvider.overrideWithValue(repository),
        webSocketServiceFactoryProvider.overrideWithValue(
          createWebSocketService,
        ),
        if (overrideTokenStore)
          authTokenStoreProvider.overrideWithValue(tokenStore),
      ],
    );
    if (disposeOnTearDown) {
      addTearDown(container.dispose);
    }
    return container;
  }

  test(
    'build returns empty list and skips repository when token is missing',
    () async {
      final container = createContainer();

      final result = await container.read(notificationsProvider.future);

      expect(result, isEmpty);
      expect(webSocketService, isNull);
      verify(() => tokenStore.read()).called(1);
      verifyNever(() => repository.getNotifications());
    },
  );

  test(
    'build loads history and connects websocket when token exists',
    () async {
      final history = [
        notification(id: 1, content: 'First', read: false),
        notification(id: 2, content: 'Second', read: true),
      ];
      when(() => tokenStore.read()).thenAnswer((_) async => 'jwt-token');
      when(
        () => repository.getNotifications(),
      ).thenAnswer((_) async => history);
      final container = createContainer(disposeOnTearDown: false);

      final result = await container.read(notificationsProvider.future);

      expect(result, history);
      expect(webSocketService, isNotNull);
      expect(webSocketService!.token, 'jwt-token');
      expect(webSocketService!.connectedBaseUrl, Env.apiUrl);

      container.dispose();
      expect(webSocketService!.disconnectCalled, isTrue);
    },
  );

  test(
    'rebuilds and connects websocket when token appears after empty build',
    () async {
      final history = [
        notification(id: 1, content: 'First after login', read: false),
      ];
      when(
        () => repository.getNotifications(),
      ).thenAnswer((_) async => history);
      final container = createContainer(overrideTokenStore: false);

      final emptyResult = await container.read(notificationsProvider.future);
      expect(emptyResult, isEmpty);
      expect(webSocketService, isNull);

      await container.read(authTokenStoreProvider).save('jwt-token');
      await Future<void>.delayed(Duration.zero);

      final result = await container.read(notificationsProvider.future);

      expect(result, history);
      expect(webSocketService, isNotNull);
      expect(webSocketService!.token, 'jwt-token');
      expect(webSocketService!.connectedBaseUrl, Env.apiUrl);
    },
  );

  test(
    'connects websocket even when notification history fails to load',
    () async {
      when(() => tokenStore.read()).thenAnswer((_) async => 'jwt-token');
      when(
        () => repository.getNotifications(),
      ).thenAnswer((_) async => throw Exception('temporary backend error'));
      final container = createContainer();

      final result = await container.read(notificationsProvider.future);

      expect(result, isEmpty);
      expect(webSocketService, isNotNull);
      expect(webSocketService!.connectedBaseUrl, Env.apiUrl);
    },
  );

  test('clears token when websocket reports unauthorized', () async {
    when(() => tokenStore.read()).thenAnswer((_) async => 'jwt-token');
    when(() => repository.getNotifications()).thenAnswer((_) async => []);
    final container = createContainer();

    await container.read(notificationsProvider.future);
    webSocketService!.triggerUnauthorized();
    await Future<void>.delayed(Duration.zero);

    verify(() => tokenStore.clear()).called(1);
  });

  test('markAsRead updates item optimistically and calls repository', () async {
    final history = [notification(id: 1, content: 'Unread', read: false)];
    when(() => tokenStore.read()).thenAnswer((_) async => 'jwt-token');
    when(() => repository.getNotifications()).thenAnswer((_) async => history);
    when(() => repository.markAsRead(1)).thenAnswer((_) async {});
    final container = createContainer();
    await container.read(notificationsProvider.future);

    await container.read(notificationsProvider.notifier).markAsRead(1);

    final state = container.read(notificationsProvider).value!;
    expect(state.single.read, isTrue);
    verify(() => repository.markAsRead(1)).called(1);
  });

  test('markAsRead rolls back when repository call fails', () async {
    final history = [notification(id: 1, content: 'Unread', read: false)];
    when(() => tokenStore.read()).thenAnswer((_) async => 'jwt-token');
    when(() => repository.getNotifications()).thenAnswer((_) async => history);
    when(
      () => repository.markAsRead(1),
    ).thenAnswer((_) async => throw Exception('offline'));
    final container = createContainer();
    await container.read(notificationsProvider.future);

    await container.read(notificationsProvider.notifier).markAsRead(1);

    final state = container.read(notificationsProvider).value!;
    expect(state.single.read, isFalse);
  });

  test('deleteNotification removes item optimistically', () async {
    final history = [
      notification(id: 1, content: 'Delete me', read: false),
      notification(id: 2, content: 'Keep me', read: false),
    ];
    when(() => tokenStore.read()).thenAnswer((_) async => 'jwt-token');
    when(() => repository.getNotifications()).thenAnswer((_) async => history);
    when(() => repository.deleteNotification(1)).thenAnswer((_) async {});
    final container = createContainer();
    await container.read(notificationsProvider.future);

    await container.read(notificationsProvider.notifier).deleteNotification(1);

    final state = container.read(notificationsProvider).value!;
    expect(state.map((n) => n.id), [2]);
    verify(() => repository.deleteNotification(1)).called(1);
  });

  test('deleteNotification rolls back when repository call fails', () async {
    final history = [notification(id: 1, content: 'Keep me', read: false)];
    when(() => tokenStore.read()).thenAnswer((_) async => 'jwt-token');
    when(() => repository.getNotifications()).thenAnswer((_) async => history);
    when(
      () => repository.deleteNotification(1),
    ).thenAnswer((_) async => throw Exception('offline'));
    final container = createContainer();
    await container.read(notificationsProvider.future);

    await container.read(notificationsProvider.notifier).deleteNotification(1);

    final state = container.read(notificationsProvider).value!;
    expect(state.single.id, 1);
  });

  test('unreadCountProvider counts unread notifications', () async {
    final history = [
      notification(id: 1, content: 'Unread', read: false),
      notification(id: 2, content: 'Read', read: true),
      notification(id: 3, content: 'Unread too', read: false),
    ];
    when(() => tokenStore.read()).thenAnswer((_) async => 'jwt-token');
    when(() => repository.getNotifications()).thenAnswer((_) async => history);
    final container = createContainer();
    await container.read(notificationsProvider.future);

    expect(container.read(unreadCountProvider), 2);
    expect(container.read(notificationsProvider.notifier).unreadCount, 2);
  });
}
