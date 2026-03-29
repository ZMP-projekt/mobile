import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/membership.dart';
import '../data/repositories/membership_repository.dart';

final membershipRepositoryProvider = Provider<MembershipRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MembershipRepository(dio);
});

final currentMembershipProvider = FutureProvider<Membership>((ref) async {
  final repo = ref.watch(membershipRepositoryProvider);
  return await repo.getMyMembership();
});

class PurchaseMembershipNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> purchase(String type) async {
    state = const AsyncLoading();

    final repo = ref.read(membershipRepositoryProvider);
    final result = await repo.purchaseMembership(type);

    return result.when(
      success: (_) {
        state = const AsyncData(null);
        ref.invalidate(currentMembershipProvider);
        return true;
      },
      failure: (error) {
        state = AsyncError(error, StackTrace.current);
        return false;
      },
    );
  }
}

final purchaseMembershipProvider = AsyncNotifierProvider.autoDispose<PurchaseMembershipNotifier, void>(
  PurchaseMembershipNotifier.new,
);