import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/models/user.dart';
import '../data/repositories/user_repository.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/util/app_logger.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserRepository(dio);

});

final currentUserProvider = FutureProvider<User?>((ref) async {
  final authState = ref.watch(authStateProvider);

  if (!authState.isAuthenticated) return null;

  try {
    final repo = ref.watch(userRepositoryProvider);
    return await repo.getMe();
  } on DioException catch (e) {
    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      AppLogger.e("Token wygasł lub jest nieważny. Automatyczne wylogowanie.");

      Future.microtask(() {
        ref.read(authStateProvider.notifier).logout();
      });
    }
    rethrow;
  }
});
