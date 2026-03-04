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

  AuthState({this.isLoading = false, this.isAuthenticated = false});

  AuthState copyWith({bool? isLoading, bool? isAuthenticated}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  final _storage = const FlutterSecureStorage();

  AuthNotifier(this._repo) : super(AuthState()){
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    final token = await _storage.read(key: 'jwt_token');

    if (token != null ){
      state = state.copyWith(isAuthenticated: true);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    final token = await _repo.login(email, password);

    if (token != null) {
      await _storage.write(key: 'jwt_token', value: token);
      state = state.copyWith(isLoading: false, isAuthenticated: true);
      return true;
    }

    state = state.copyWith(isLoading: false, isAuthenticated: false);
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true);

    final token = await _repo.register(name, email, password);
    final success = token != null;

    if (success) {
      AppLogger.i("Zarejestrowano pomyślnie.");
    }

    state = state.copyWith(isLoading: false, isAuthenticated: success);
    return success;
  }

  Future <void> logout() async {
    await _storage.delete(key: 'jwt_token');
    state = state.copyWith(isAuthenticated: false);
  }
}