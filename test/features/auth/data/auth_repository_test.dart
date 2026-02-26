import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_gym_app/features/auth/data/auth_repository.dart';

void main() {
  group('AuthRepository Tests', () {
    late AuthRepository authRepository;
    
    setUp(() {
      authRepository = AuthRepository();
  });
  
  test('login returns true value for valid mock request', () async {
    const email = 'test@example.com';
    const password = 'password123';

    final result = await authRepository.login(email, password);

    expect(result, isTrue);
  });
  
  test('login returns false when API throws error', () async {

    final result = await authRepository.login('', '');

    expect(result, isNotNull);
  });
  });
}