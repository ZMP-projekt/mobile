import '../models/membership.dart';

class MockMembershipRepository {
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<Membership> getMyMembership() async {
    await _simulateNetworkDelay();

    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 18));
    final endDate = now.add(const Duration(days: 12));

    return Membership(
      id: 1,
      status: 'ACTIVE',
      startDate: startDate,
      endDate: endDate,
      type: 'PREMIUM',
      daysRemainingFromApi: null,
    );
  }

  Future<Membership> purchaseMembership(String type, int durationDays) async {
    await _simulateNetworkDelay();

    final now = DateTime.now();
    return Membership(
      id: 2,
      status: 'ACTIVE',
      startDate: now,
      endDate: now.add(Duration(days: durationDays)),
      type: type,
    );
  }
}