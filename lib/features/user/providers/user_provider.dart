import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user.dart';
import '../data/repositories/user_repository.dart';
import '../../../core/network/dio_client.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserRepository(dio);

});

final currentUserProvider = FutureProvider<User>((ref) async {
  final repo = ref.watch(userRepositoryProvider);
  return await repo.getMe();
});
