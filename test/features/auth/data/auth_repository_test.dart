import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_gym_app/features/auth/data/auth_repository.dart';
import 'package:mobile_gym_app/core/models/result.dart';
import 'package:mobile_gym_app/l10n/app_localizations_en.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('AuthRepository Tests', () {
    late AuthRepository authRepository;
    late MockDio mockDio;

    setUpAll(() {
      Intl.defaultLocale = 'en';
    });

    setUp(() {
      mockDio = MockDio();
      authRepository = AuthRepository(mockDio);
    });

    test('login returns Success with token when API call succeeds', () async {
      const token = 'super_tajny_token';
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: {'token': token},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await authRepository.login('test@test.pl', 'password123');

      expect(result, isA<Success<String>>());
      final success = result as Success<String>;
      expect(success.data, equals(token));
    });

    test('login sends email and password payload to API', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: {'token': 'token'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      await authRepository.login('john@test.pl', 'password123');

      final capturedData = verify(
        () => mockDio.post('/auth/login', data: captureAny(named: 'data')),
      ).captured.single;
      expect(capturedData, {
        'email': 'john@test.pl',
        'password': 'password123',
      });
    });

    test(
      'login returns server error when response status is not successful',
      () async {
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: {'token': 'ignored'},
            statusCode: 500,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        final result = await authRepository.login(
          'test@test.pl',
          'password123',
        );

        expect(result, isA<Failure<String>>());
        expect(
          (result as Failure<String>).error,
          equals(AppLocalizationsEn().errorServer),
        );
      },
    );

    test('login returns Failure with message when API returns 403', () async {
      const errorMessage = 'Invalid credentials';
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 403,
            data: {'message': errorMessage},
            requestOptions: RequestOptions(path: ''),
          ),
        ),
      );

      final result = await authRepository.login('zly@email.pl', 'zle');

      expect(result, isA<Failure<String>>());
      final failure = result as Failure<String>;
      expect(failure.error, equals(errorMessage));
    });

    test(
      'login returns Failure when backend returns error field instead of message',
      () async {
        const errorMessage = 'Email already exists';
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              statusCode: 400,
              data: {'error': errorMessage},
              requestOptions: RequestOptions(path: ''),
            ),
          ),
        );

        final result = await authRepository.login('test@test.pl', 'pass');

        expect(result, isA<Failure<String>>());
        final failure = result as Failure<String>;
        expect(failure.error, equals(errorMessage));
      },
    );

    test('login returns default error message on connection timeout', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final result = await authRepository.login('test@test.pl', 'pass');

      expect(result, isA<Failure<String>>());
      final failure = result as Failure<String>;
      expect(
        failure.error,
        equals(AppLocalizationsEn().errorConnectionTimeout),
      );
    });

    test('login returns plain text backend error from DioException', () async {
      const errorMessage = 'Plain text error';
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 400,
            data: errorMessage,
            requestOptions: RequestOptions(path: ''),
          ),
        ),
      );

      final result = await authRepository.login('test@test.pl', 'pass');

      expect(result, isA<Failure<String>>());
      expect((result as Failure<String>).error, equals(errorMessage));
    });

    test('login returns unknown error for non-Dio exceptions', () async {
      when(
        () => mockDio.post(any(), data: any(named: 'data')),
      ).thenThrow(Exception('boom'));

      final result = await authRepository.login('test@test.pl', 'pass');

      expect(result, isA<Failure<String>>());
      expect(
        (result as Failure<String>).error,
        equals(AppLocalizationsEn().commonUnknownError),
      );
    });

    test('register returns Success with token when successful', () async {
      const token = 'new_user_token';
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {'token': token},
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await authRepository.register(
        'John',
        'Smith',
        'john@test.pl',
        'pass123',
      );

      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, equals(token));
    });

    test('register sends expected payload to API', () async {
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {'token': 'token'},
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      await authRepository.register('John', 'Smith', 'john@test.pl', 'pass123');

      final capturedData = verify(
        () => mockDio.post('/auth/register', data: captureAny(named: 'data')),
      ).captured.single;
      expect(capturedData, {
        'firstName': 'John',
        'lastName': 'Smith',
        'email': 'john@test.pl',
        'password': 'pass123',
        'role': 'ROLE_USER',
      });
    });

    test(
      'register returns server error when response status is not successful',
      () async {
        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: {'token': 'ignored'},
            statusCode: 500,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        final result = await authRepository.register(
          'John',
          'Smith',
          'john@test.pl',
          'pass123',
        );

        expect(result, isA<Failure<String>>());
        expect(
          (result as Failure<String>).error,
          equals(AppLocalizationsEn().errorServer),
        );
      },
    );

    test('register returns Failure when email already exists', () async {
      const errorMessage = 'Email already registered';
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 409,
            data: {'message': errorMessage},
            requestOptions: RequestOptions(path: ''),
          ),
        ),
      );

      final result = await authRepository.register(
        'John',
        'Smith',
        'existing@test.pl',
        'pass',
      );

      expect(result, isA<Failure<String>>());
      expect((result as Failure<String>).error, equals(errorMessage));
    });

    test('register returns unknown error for non-Dio exceptions', () async {
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('boom'));

      final result = await authRepository.register(
        'John',
        'Smith',
        'john@test.pl',
        'pass123',
      );

      expect(result, isA<Failure<String>>());
      expect(
        (result as Failure<String>).error,
        equals(AppLocalizationsEn().commonUnknownError),
      );
    });
  });
}
