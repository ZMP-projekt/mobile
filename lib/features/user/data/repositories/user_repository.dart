import 'package:dio/dio.dart';
import '../models/user.dart';
import '../../../../core/network/dio_error_parser.dart';

class UserRepository {
  final Dio _dio;

  UserRepository(this._dio);

  Future<User> getMe() async {
    try {
      final response = await _dio.get('/api/users/me');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(DioErrorParser.extract(e.response, e.type, defaultMessageBuilder: (l10n) => l10n.errorUserProfileFetch));
    } catch (e) {
      throw Exception(DioErrorParser.localized((l10n) => l10n.errorUserProfileUnexpected));
    }
  }
}
