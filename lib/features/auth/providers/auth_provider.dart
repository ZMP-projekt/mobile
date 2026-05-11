import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/auth/auth_token_store.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/util/app_logger.dart';
import '../../user/providers/user_provider.dart';
import '../data/auth_repository.dart';
import 'auth_session_cleaner.dart';

part 'auth_provider.freezed.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  final tokenStore = ref.watch(authTokenStoreProvider);
  final sessionCleaner = ref.watch(authSessionCleanerProvider);
  return AuthNotifier(repo, tokenStore, sessionCleaner, ref);
});

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(true) bool isInitializing,
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    String? errorMessage,
  }) = _AuthState;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  final AuthTokenStore _tokenStore;
  final AuthSessionCleaner _sessionCleaner;
  final Ref ref;

  AuthNotifier(this._repo, this._tokenStore, this._sessionCleaner, this.ref)
      : super(const AuthState()) {
    _checkInitialAuth();

    ref.listen<String?>(authTokenProvider, (previous, next) {
      if (previous != null && next == null) {
        logout();
      }
    });
  }

  Future<void> _checkInitialAuth() async {
    final token = await _tokenStore.read();

    if (token != null) {
      state = state.copyWith(isAuthenticated: true, isInitializing: false);
      return;
    }

    state = state.copyWith(isInitializing: false);
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repo.login(email, password);

    return result.when(
      success: (token) async {
        await _tokenStore.save(token);
        _sessionCleaner.resetNavigation(ref);

        try {
          await ref.read(currentUserProvider.future);
        } catch (e) {
          AppLogger.e("Błąd pobierania użytkownika po logowaniu", e);
        }

        state = state.copyWith(isLoading: false, isAuthenticated: true);
        AppLogger.i("Zalogowano użytkownika");
        return true;
      },
      failure: (error) {
        state = state.copyWith(isLoading: false, errorMessage: error);
        AppLogger.w("Logowanie nie powiodło się");
        return false;
      },
    );
  }

  Future<bool> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repo.register(firstName, lastName, email, password);

    return result.when(
      success: (token) async {
        await _tokenStore.save(token);
        _sessionCleaner.resetNavigation(ref);

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
    if (!state.isAuthenticated) return;

    _sessionCleaner.resetNavigation(ref);
    state = state.copyWith(isAuthenticated: false);

    await _tokenStore.clear();

    Future.microtask(() {
      _sessionCleaner.invalidateUserData(ref);
    });

    AppLogger.i("Wylogowano użytkownika");
  }
}
