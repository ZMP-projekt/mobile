import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile_gym_app/core/auth/auth_token_store.dart';
import 'package:mobile_gym_app/core/models/result.dart';
import 'package:mobile_gym_app/features/auth/data/auth_repository.dart';
import 'package:mobile_gym_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_gym_app/features/auth/providers/auth_session_cleaner.dart';
import 'package:mobile_gym_app/features/user/data/models/user.dart';
import 'package:mobile_gym_app/features/user/providers/user_provider.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthTokenStore extends Mock implements AuthTokenStore {}

class MockAuthSessionCleaner extends Mock implements AuthSessionCleaner {}

class FakeRef extends Fake implements Ref {}

void main() {
  late MockAuthRepository repository;
  late MockAuthTokenStore tokenStore;
  late MockAuthSessionCleaner sessionCleaner;

  const testUser = User(
    id: 1,
    email: 'john@example.com',
    firstName: 'John',
    lastName: 'Smith',
    role: 'ROLE_USER',
  );

  setUpAll(() {
    registerFallbackValue(FakeRef());
  });

  setUp(() {
    repository = MockAuthRepository();
    tokenStore = MockAuthTokenStore();
    sessionCleaner = MockAuthSessionCleaner();

    when(() => tokenStore.read()).thenAnswer((_) async => null);
    when(() => tokenStore.save(any())).thenAnswer((_) async {});
    when(() => tokenStore.clear()).thenAnswer((_) async {});
    when(
      () => sessionCleaner.clearOfflineCache(any()),
    ).thenAnswer((_) async {});
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
        authTokenStoreProvider.overrideWithValue(tokenStore),
        authSessionCleanerProvider.overrideWithValue(sessionCleaner),
        currentUserProvider.overrideWith((ref) async => testUser),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<void> settleInitialAuth(ProviderContainer container) async {
    container.read(authStateProvider);
    await Future<void>.delayed(Duration.zero);
  }

  test(
    'initial auth marks user authenticated when a stored token exists',
    () async {
      when(() => tokenStore.read()).thenAnswer((_) async => 'stored-token');
      final container = createContainer();

      await settleInitialAuth(container);

      final state = container.read(authStateProvider);
      expect(state.isInitializing, isFalse);
      expect(state.isAuthenticated, isTrue);
    },
  );

  test('initial auth finishes unauthenticated when no token exists', () async {
    final container = createContainer();

    await settleInitialAuth(container);

    final state = container.read(authStateProvider);
    expect(state.isInitializing, isFalse);
    expect(state.isAuthenticated, isFalse);
  });

  test(
    'login success saves token, resets navigation, and authenticates',
    () async {
      when(
        () => repository.login('john@example.com', 'password123'),
      ).thenAnswer((_) async => const Result.success('api-token'));
      final container = createContainer();
      await settleInitialAuth(container);

      final result = await container
          .read(authStateProvider.notifier)
          .login('john@example.com', 'password123');

      expect(result, isTrue);
      expect(container.read(authStateProvider).isAuthenticated, isTrue);
      expect(container.read(authStateProvider).isLoading, isFalse);
      verify(() => tokenStore.save('api-token')).called(1);
      verify(() => sessionCleaner.resetNavigation(any())).called(1);
    },
  );

  test('login failure exposes error and does not save token', () async {
    when(
      () => repository.login('john@example.com', 'bad-password'),
    ).thenAnswer((_) async => const Result.failure('Invalid credentials'));
    final container = createContainer();
    await settleInitialAuth(container);

    final result = await container
        .read(authStateProvider.notifier)
        .login('john@example.com', 'bad-password');

    final state = container.read(authStateProvider);
    expect(result, isFalse);
    expect(state.isAuthenticated, isFalse);
    expect(state.isLoading, isFalse);
    expect(state.errorMessage, 'Invalid credentials');
    verifyNever(() => tokenStore.save(any()));
    verifyNever(() => sessionCleaner.resetNavigation(any()));
  });

  test('register success saves token and authenticates', () async {
    when(
      () => repository.register('John', 'Smith', 'john@example.com', 'pass123'),
    ).thenAnswer((_) async => const Result.success('register-token'));
    final container = createContainer();
    await settleInitialAuth(container);

    final result = await container
        .read(authStateProvider.notifier)
        .register('John', 'Smith', 'john@example.com', 'pass123');

    expect(result, isTrue);
    expect(container.read(authStateProvider).isAuthenticated, isTrue);
    verify(() => tokenStore.save('register-token')).called(1);
    verify(() => sessionCleaner.resetNavigation(any())).called(1);
  });

  test('logout clears token and invalidates session data', () async {
    when(() => tokenStore.read()).thenAnswer((_) async => 'stored-token');
    final container = createContainer();
    await settleInitialAuth(container);

    await container.read(authStateProvider.notifier).logout();
    await Future<void>.delayed(Duration.zero);

    expect(container.read(authStateProvider).isAuthenticated, isFalse);
    verify(() => sessionCleaner.resetNavigation(any())).called(1);
    verify(() => tokenStore.clear()).called(1);
    verify(() => sessionCleaner.clearOfflineCache(any())).called(1);
    verify(() => sessionCleaner.invalidateUserData(any())).called(1);
  });
}
