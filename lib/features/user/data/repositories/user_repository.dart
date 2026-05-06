import 'package:dio/dio.dart';
import '../models/user.dart';
import '../../../../core/network/dio_error_parser.dart';
import '../../../../core/offline/offline_cache_store.dart';

class UserRepository {
  final Dio _dio;
  final OfflineCacheStore _cache;

  UserRepository(this._dio, this._cache);

  Future<User> getMe() async {
    try {
      return await _cache.getOrFetch(
        key: 'current_user',
        fetch: () async {
          final response = await _dio.get('/api/users/me');
          return User.fromJson(response.data);
        },
        toJson: (user) => user.toJson(),
        fromJson: (json) =>
            User.fromJson(Map<String, dynamic>.from(json as Map)),
      );
    } on DioException catch (e) {
      throw Exception(
        DioErrorParser.extract(
          e.response,
          e.type,
          defaultMessageBuilder: (l10n) => l10n.errorUserProfileFetch,
        ),
      );
    } on OfflineCacheMissException {
      throw Exception(
        DioErrorParser.localized((l10n) => l10n.errorUserProfileFetch),
      );
    } catch (e) {
      throw Exception(
        DioErrorParser.localized((l10n) => l10n.errorUserProfileUnexpected),
      );
    }
  }
}
