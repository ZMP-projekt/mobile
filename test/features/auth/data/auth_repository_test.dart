import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_gym_app/features/auth/data/auth_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('AuthRepository Tests', () {
    late AuthRepository authRepository;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      authRepository = AuthRepository(mockDio);
    });

    test('login returns token when API call is successful', () async {
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
        data: {'token': 'super_tajny_token'},
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ));

      final result = await authRepository.login('test@test.pl', 'password123');

      expect(result, equals('super_tajny_token'));
    });

    test('login returns null when API throws 403 or other error', () async {
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(statusCode: 403, requestOptions: RequestOptions(path: '')),
      ));

      final result = await authRepository.login('zly@email.pl', 'zle');

      expect(result, isNull);
    });
  });
}