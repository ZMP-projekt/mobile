import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const authTokenStorageKey = 'jwt_token';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final _authTokenProvider = StateProvider<String?>((ref) => null);

final authTokenValueProvider = Provider<String?>((ref) {
  return ref.watch(_authTokenProvider);
});

final authTokenStoreProvider = Provider<AuthTokenStore>((ref) {
  return AuthTokenStore(ref, ref.watch(secureStorageProvider));
});

class AuthTokenStore {
  final Ref _ref;
  final FlutterSecureStorage _storage;

  const AuthTokenStore(this._ref, this._storage);

  Future<String?> read() async {
    final inMemoryToken = _ref.read(_authTokenProvider);
    if (inMemoryToken != null && inMemoryToken.isNotEmpty) {
      return inMemoryToken;
    }

    final storedToken = await _storage.read(key: authTokenStorageKey);
    if (storedToken != null && storedToken.isNotEmpty) {
      _ref.read(_authTokenProvider.notifier).state = storedToken;
      return storedToken;
    }

    return null;
  }

  Future<void> save(String token) async {
    await _storage.write(key: authTokenStorageKey, value: token);
    _ref.read(_authTokenProvider.notifier).state = token;
  }

  Future<void> clear() async {
    await _storage.delete(key: authTokenStorageKey);
    _ref.read(_authTokenProvider.notifier).state = null;
  }
}
