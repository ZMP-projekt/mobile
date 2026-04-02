import 'package:dio/dio.dart';

class DioErrorParser {
  static String extract(Response? response, DioExceptionType type, {String defaultMessage = 'Wystąpił nieoczekiwany błąd'}) {
    if (response != null && response.data != null) {
      final data = response.data;

      if (data is Map<String, dynamic>) {
        return data['message'] ?? data['error'] ?? _defaultForType(type, defaultMessage);
      } else if (data is String && data.isNotEmpty) {
        return data;
      }
    }
    return _defaultForType(type, defaultMessage);
  }

  static String _defaultForType(DioExceptionType type, String fallback) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Przekroczono czas połączenia. Sprawdź połączenie z internetem.';
      case DioExceptionType.badResponse:
        return 'Błąd serwera. Spróbuj ponownie później.';
      case DioExceptionType.cancel:
        return 'Żądanie zostało anulowane.';
      case DioExceptionType.connectionError:
        return 'Brak połączenia z internetem.';
      default:
        return fallback;
    }
  }
}