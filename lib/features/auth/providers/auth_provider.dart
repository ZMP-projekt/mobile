import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/auth_repository.dart';
import '../../../core/util/app_logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../user/providers/user_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo, ref);
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
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: clearError
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  AuthState clearError() {
    return copyWith(clearError: true);
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  final _storage = const FlutterSecureStorage();
  final Ref ref;

  AuthNotifier(this._repo, this.ref) : super(AuthState()) {
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    final token = await _storage.read(key: 'jwt_token');

    if (token != null) {
      state = state.copyWith(isAuthenticated: true);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.clearError().copyWith(isLoading: true);

    final result = await _repo.login(email, password);

    if (result.isSuccess) {
      await _storage.write(key: 'jwt_token', value: result.data!);
      try {
        await ref.read(currentUserProvider.future);
      } catch (e) {
        AppLogger.e("Błąd ", e);
      }
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
      );
      AppLogger.i("✅ Zalogowano pomyślnie: $email");
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: result.error,
      );
      AppLogger.e("❌ Błąd logowania: ${result.error}");
      return false;
    }
  }

  Future<bool> register(String firstName, String lastName, String email, String password) async {
    state = state.clearError().copyWith(isLoading: true);

    final result = await _repo.register(firstName, lastName, email, password);

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
        errorMessage: result.error,
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