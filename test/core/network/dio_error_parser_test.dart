import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mobile_gym_app/core/network/dio_error_parser.dart';
import 'package:mobile_gym_app/l10n/app_localizations_en.dart';
import 'package:mobile_gym_app/l10n/app_localizations_pl.dart';

void main() {
  group('DioErrorParser', () {
    late RequestOptions requestOptions;
    late AppLocalizationsEn en;
    late AppLocalizationsPl pl;

    Response<dynamic> responseWith(dynamic data) {
      return Response<dynamic>(data: data, requestOptions: requestOptions);
    }

    setUp(() {
      Intl.defaultLocale = 'en';
      requestOptions = RequestOptions(path: '/test');
      en = AppLocalizationsEn();
      pl = AppLocalizationsPl();
    });

    test('extract returns message field from JSON response', () {
      final result = DioErrorParser.extract(
        responseWith({'message': 'Invalid credentials'}),
        DioExceptionType.badResponse,
      );

      expect(result, 'Invalid credentials');
    });

    test('extract returns error field when message is missing', () {
      final result = DioErrorParser.extract(
        responseWith({'error': 'Email already exists'}),
        DioExceptionType.badResponse,
      );

      expect(result, 'Email already exists');
    });

    test('extract prefers message over error when both fields are present', () {
      final result = DioErrorParser.extract(
        responseWith({'message': 'Message wins', 'error': 'Error loses'}),
        DioExceptionType.badResponse,
      );

      expect(result, 'Message wins');
    });

    test('extract returns plain string response when backend sends text', () {
      final result = DioErrorParser.extract(
        responseWith('Plain backend error'),
        DioExceptionType.badResponse,
      );

      expect(result, 'Plain backend error');
    });

    test('extract ignores empty string response and falls back by type', () {
      final result = DioErrorParser.extract(
        responseWith(''),
        DioExceptionType.badResponse,
      );

      expect(result, en.errorServer);
    });

    test('extract returns timeout message for all timeout types', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        final result = DioErrorParser.extract(null, type);

        expect(result, en.errorConnectionTimeout);
      }
    });

    test('extract returns server message for badResponse without body', () {
      final result = DioErrorParser.extract(null, DioExceptionType.badResponse);

      expect(result, en.errorServer);
    });

    test('extract returns cancel message for canceled requests', () {
      final result = DioErrorParser.extract(null, DioExceptionType.cancel);

      expect(result, en.errorRequestCanceled);
    });

    test('extract returns no internet message for connection errors', () {
      final result = DioErrorParser.extract(
        null,
        DioExceptionType.connectionError,
      );

      expect(result, en.errorNoInternet);
    });

    test('extract returns custom fallback for unknown errors', () {
      final result = DioErrorParser.extract(
        null,
        DioExceptionType.unknown,
        defaultMessage: 'Custom fallback',
      );

      expect(result, 'Custom fallback');
    });

    test('extract lets fallback builder override custom fallback', () {
      final result = DioErrorParser.extract(
        null,
        DioExceptionType.unknown,
        defaultMessage: 'Custom fallback',
        defaultMessageBuilder: (l10n) => l10n.errorDataLoad,
      );

      expect(result, en.errorDataLoad);
    });

    test('localized returns text for current locale', () {
      Intl.defaultLocale = 'pl';

      final result = DioErrorParser.localized(
        (l10n) => l10n.errorConnectionTimeout,
      );

      expect(result, pl.errorConnectionTimeout);
    });
  });
}
