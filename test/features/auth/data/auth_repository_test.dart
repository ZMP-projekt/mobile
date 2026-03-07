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

    test('login returns Result.success with token when API call succeeds', () async {
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
        data: {'token': 'super_tajny_token'},
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ));

      final result = await authRepository.login('test@test.pl', 'password123');

      expect(result.isSuccess, isTrue);
      expect(result.data, equals('super_tajny_token'));
      expect(result.error, isNull);
    });

    test('login returns Result.failure with message when API returns 403', () async {
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 403,
          data: {'message': 'Invalid credentials'},
          requestOptions: RequestOptions(path: ''),
        ),
      ));

      final result = await authRepository.login('zly@email.pl', 'zle');

      expect(result.isFailure, isTrue);
      expect(result.error, equals('Invalid credentials'));
      expect(result.data, isNull);
    });

    test('login returns Result.failure when backend returns error field instead of message', () async {
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 400,
          data: {'error': 'Email already exists'},
          requestOptions: RequestOptions(path: ''),
        ),
      ));

      final result = await authRepository.login('test@test.pl', 'pass');

      expect(result.isFailure, isTrue);
      expect(result.error, equals('Email already exists'));
    });

    test('login returns default error message on connection timeout', () async {
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      ));

      final result = await authRepository.login('test@test.pl', 'pass');

      expect(result.isFailure, isTrue);
      expect(result.error, contains('czas połączenia'));
    });

    test('register returns Result.success with token when successful', () async {
      when(() => mockDio.post(
        any(),
        data: any(named: 'data'),
        options: any(named: 'options'),
      )).thenAnswer((_) async => Response(
        data: {'token': 'new_user_token'},
        statusCode: 201,
        requestOptions: RequestOptions(path: ''),
      ));

      final result = await authRepository.register('John', 'john@test.pl', 'pass123');

      expect(result.isSuccess, isTrue);
      expect(result.data, equals('new_user_token'));
    });

    test('register returns Result.failure when email already exists', () async {
      when(() => mockDio.post(
        any(),
        data: any(named: 'data'),
        options: any(named: 'options'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 409,
          data: {'message': 'Email already registered'},
          requestOptions: RequestOptions(path: ''),
        ),
      ));

      final result = await authRepository.register('John', 'existing@test.pl', 'pass');

      expect(result.isFailure, isTrue);
      expect(result.error, equals('Email already registered'));
    });
  });
}