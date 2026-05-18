import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_gym_app/core/auth/auth_token_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('save stores token and updates in-memory provider', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(authTokenStoreProvider).save('token-123');

    expect(container.read(authTokenValueProvider), 'token-123');
    expect(
      await container
          .read(secureStorageProvider)
          .read(key: authTokenStorageKey),
      'token-123',
    );
  });

  test('read hydrates in-memory provider from secure storage', () async {
    FlutterSecureStorage.setMockInitialValues({
      authTokenStorageKey: 'stored-token',
    });
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final token = await container.read(authTokenStoreProvider).read();

    expect(token, 'stored-token');
    expect(container.read(authTokenValueProvider), 'stored-token');
  });

  test('clear removes stored token and resets in-memory provider', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(authTokenStoreProvider).save('token-123');
    await container.read(authTokenStoreProvider).clear();

    expect(container.read(authTokenValueProvider), isNull);
    expect(
      await container
          .read(secureStorageProvider)
          .read(key: authTokenStorageKey),
      isNull,
    );
  });
}
