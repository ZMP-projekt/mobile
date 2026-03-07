import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/auth_repository.dart';
import '../../../core/util/app_logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? errorMessage;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    _Value<String?>? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage != null ? errorMessage.value : this.errorMessage,
    );
  }

  AuthState clearError() {
    return copyWith(errorMessage: _Value(null));
  }
}

class _Value<T> {
  final T value;
  _Value(this.value);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  final _storage = const FlutterSecureStorage();

  AuthNotifier(this._repo) : super(AuthState()) {
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    final token = await _storage.read(key: 'jwt_token');
    AppLogger.i("TOKEN : $token");

    if (token != null) {
      state = state.copyWith(isAuthenticated: true);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.clearError().copyWith(isLoading: true);

    final result = await _repo.login(email, password);

    if (result.isSuccess) {
      await _storage.write(key: 'jwt_token', value: result.data!);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
      );
      AppLogger.i("✅ Zalogowano pomyślnie");
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: _Value(result.error),
      );
      AppLogger.e("❌ Błąd logowania: ${result.error}");
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.clearError().copyWith(isLoading: true);

    final result = await _repo.register(name, email, password);

    if (result.isSuccess) {
      await _storage.write(key: 'jwt_token', value: result.data!);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
      );
      AppLogger.i("✅ Zarejestrowano pomyślnie");
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: _Value(result.error),
      );
      AppLogger.e("❌ Błąd rejestracji: ${result.error}");
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    state = state.copyWith(isAuthenticated: false);
    AppLogger.i("👋 Wylogowano");
  }
}