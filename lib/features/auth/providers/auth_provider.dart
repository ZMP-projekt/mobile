import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState> ((ref) {
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

  AuthNotifier(this._repo) : super(AuthState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true);

    final success = await _repo.login(email, password);

    state = state.copyWith(isLoading: false, isAuthenticated: success);
    return success;
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.register(name, email, password);

    state = state.copyWith(isLoading: false, isAuthenticated: success);
    return success;
  }
}