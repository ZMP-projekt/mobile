import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/membership.dart';
import '../data/repositories/mock_membership_repository.dart';

final membershipRepositoryProvider = Provider<MockMembershipRepository>((ref) {
  return MockMembershipRepository();
});

final currentMembershipProvider = FutureProvider<Membership>((ref) async {
  final repo = ref.watch(membershipRepositoryProvider);
  return await repo.getMyMembership();
});