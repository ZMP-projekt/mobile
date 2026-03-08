import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user.dart';
import '../data/repositories/mock_user_repository.dart';

final userRepositoryProvider = Provider<MockUserRepository>((ref) {
  return MockUserRepository();
});

final currentUserProvider = FutureProvider<User>((ref) async {
  final repo = ref.watch(userRepositoryProvider);
  return await repo.getMe();
});