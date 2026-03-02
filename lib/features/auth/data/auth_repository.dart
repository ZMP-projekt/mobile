import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class AuthRepository {
  final Dio _dio = DioClient().dio;

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post('/posts', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await _dio.post('/posts', data: {
        'name': name,
        'email' : email,
        'password' : password,
      });

      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}