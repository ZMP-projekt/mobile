import 'package:dio/dio.dart';
import '../../../core/util/app_logger.dart';
import '../../../core/models/result.dart';
import '../../../core/network/dio_error_parser.dart'; 

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

      return Result.failure(DioErrorParser.localized((l10n) => l10n.errorServer));
    } on DioException catch (e) {
      AppLogger.e("Błąd logowania", e);
      return Result.failure(DioErrorParser.extract(e.response, e.type));
    } catch (e) {
      AppLogger.e("Nieoczekiwany błąd", e);
      return Result.failure(DioErrorParser.localized((l10n) => l10n.commonUnknownError));
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
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data['token'];
        return Result.success(token);
      }

      return Result.failure(DioErrorParser.localized((l10n) => l10n.errorServer));
    } on DioException catch (e) {
      AppLogger.e("Błąd rejestracji", e);
      return Result.failure(DioErrorParser.extract(e.response, e.type));
    } catch (e) {
      AppLogger.e("Nieoczekiwany błąd rejestracji", e);
      return Result.failure(DioErrorParser.localized((l10n) => l10n.commonUnknownError));
    }
  }
}
