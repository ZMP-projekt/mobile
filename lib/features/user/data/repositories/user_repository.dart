import 'package:dio/dio.dart';
import '../models/user.dart';

class UserRepository {
  final Dio _dio;

  UserRepository(this._dio);

  Future<User> getMe() async {
    final response = await _dio.get('/api/users/me');

    return User.fromJson(response.data);
  }
}