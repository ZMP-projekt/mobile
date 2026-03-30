import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/auth_repository.dart';
import '../../../core/util/app_logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../user/providers/user_provider.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_provider.freezed.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo, ref);
});

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    String? errorMessage,
  }) = _AuthState;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  final _storage = const FlutterSecureStorage();
  final Ref ref;

  AuthNotifier(this._repo, this.ref) : super(const AuthState()) {
    _checkInitialAuth();

    ref.listen<String?>(authTokenProvider, (previous, next) {
      if (previous != null && next == null) {
        logout();
      }
    });
  }

  Future<void> _checkInitialAuth() async {
    final token = await _storage.read(key: 'jwt_token');

    if (token != null) {
      ref.read(authTokenProvider.notifier).state = token;
      state = state.copyWith(isAuthenticated: true);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repo.login(email, password);

    return result.when(
      success: (token) async {
        await _storage.write(key: 'jwt_token', value: token);
        ref.read(authTokenProvider.notifier).state = token;

        try {
          await ref.read(currentUserProvider.future);
        } catch (e) {
          AppLogger.e("Błąd pobierania usera", e);
        }

        state = state.copyWith(isLoading: false, isAuthenticated: true);
        AppLogger.i("✅ Zalogowano: $email");
        return true;
      },
      failure: (error) {
        state = state.copyWith(isLoading: false, errorMessage: error);
        AppLogger.e("❌ Błąd: $error");
        return false;
      },
    );
  }

  Future<bool> register(String firstName, String lastName, String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repo.register(firstName, lastName, email, password);

    return result.when(
      success: (token) async {
        await _storage.write(key: 'jwt_token', value: token);
        ref.read(authTokenProvider.notifier).state = token;

        state = state.copyWith(isLoading: false, isAuthenticated: true);
        return true;
      },
      failure: (error) {
        state = state.copyWith(isLoading: false, errorMessage: error);
        return false;
      },
    );
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    ref.read(authTokenProvider.notifier).state = null;

    state = state.copyWith(isAuthenticated: false);
    AppLogger.i("👋 Wylogowano");
  }
}