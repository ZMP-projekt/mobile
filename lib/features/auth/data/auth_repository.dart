import 'package:dio/dio.dart';
import '../../../core/util/app_logger.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['token'];
      }
    } catch (e) {
      AppLogger.e("Błąd logowania: $e");
    }
    return null;
  }

  Future<String?> register(String name, String email, String password) async {
    try {
      final response = await _dio.post('/auth/register',
          data: {
        'name': name,
        'email': email.trim(),
        'password': password.trim(),
        'role': 'ROLE_USER',
      },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      return response.data['token'];
    } on DioException catch (e) {
      AppLogger.e("STATUS: ${e.response?.statusCode}");
      AppLogger.e("DATA Z SERWERA: ${e.response?.data}");
      AppLogger.e("TYP BŁĘDU: ${e.type}");
      return null;
    }
  }
}