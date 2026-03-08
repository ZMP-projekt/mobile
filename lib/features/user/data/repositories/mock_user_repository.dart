import '../models/user.dart';

class MockUserRepository {
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<User> getMe() async {
    await _simulateNetworkDelay();

    return User(
      id: 1,
      email: 'alex.kowalski@gmail.com',
      role: 'ROLE_USER',
      name: 'Alex',
    );
  }

  Future<User> getUserById(int id) async {
    await _simulateNetworkDelay();
    return getMe();
  }
}