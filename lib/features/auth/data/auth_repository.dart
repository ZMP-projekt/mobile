import 'package:dio/dio.dart';
import '../../../core/util/app_logger.dart';
import '../../../core/models/result.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<Result<String>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data['token'];
        return Result.success(token);
      }

      return Result.failure('Nieoczekiwany błąd serwera');
    } on DioException catch (e) {
      AppLogger.e("Błąd logowania", e);

      final errorMessage = _extractErrorMessage(e.response, e.type);
      return Result.failure(errorMessage);

    } catch (e) {
      AppLogger.e("Nieoczekiwany błąd", e);
      return Result.failure('Wystąpił nieoczekiwany błąd');
    }
  }

  Future<Result<String>> register(
      String firstName,
      String lastName,
      String email,
      String password,
      ) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'role': 'ROLE_USER',
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data['token'];
        return Result.success(token);
      }

      return Result.failure('Nieoczekiwany błąd serwera');
    } on DioException catch (e) {
      AppLogger.e("STATUS: ${e.response?.statusCode}");
      AppLogger.e("DATA Z SERWERA: ${e.response?.data}");

      final errorMessage = _extractErrorMessage(e.response, e.type);
      return Result.failure(errorMessage);

    } catch (e) {
      AppLogger.e("Nieoczekiwany błąd rejestracji", e);
      return Result.failure('Wystąpił nieoczekiwany błąd');
    }
  }

  String _extractErrorMessage(Response? response, DioExceptionType type) {
    if (response != null && response.data != null) {
      final data = response.data;

      if (data is Map<String, dynamic>) {
        return data['message'] ?? data['error'] ?? _getDefaultErrorMessage(type);
      }
      else if (data is String && data.isNotEmpty) {
        return data;
      }
    }

    return _getDefaultErrorMessage(type);
  }

  String _getDefaultErrorMessage(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Przekroczono czas połączenia. Sprawdź połączenie z internetem.';
      case DioExceptionType.badResponse:
        return 'Błąd serwera. Spróbuj ponownie później.';
      case DioExceptionType.cancel:
        return 'Żądanie zostało anulowane';
      case DioExceptionType.connectionError:
        return 'Brak połączenia z internetem';
      default:
        return 'Wystąpił nieoczekiwany błąd';
    }
  }
}