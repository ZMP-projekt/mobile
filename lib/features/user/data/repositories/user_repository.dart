import 'package:dio/dio.dart';
import '../models/user.dart';

class UserRepository {
  final Dio _dio;

  UserRepository(this._dio);

  Future<User> getMe() async {
    try {

    final response = await _dio.get('/api/users/me');

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Nie udało się pobrać danych użytkownika');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getUserById(int id) async {
    final response = await _dio.get('/users/$id');
    return User.fromJson(response.data);
  }
}