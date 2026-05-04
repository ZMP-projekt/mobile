import 'package:dio/dio.dart';
import '../../../../core/network/dio_error_parser.dart';
import '../../../../core/offline/offline_cache_store.dart';
import '../models/gym_class.dart';
import '../../../user/data/models/user.dart';

abstract class IClassesRepository {
  Future<List<GymClass>> getClassesByDate(DateTime date);
  Future<List<GymClass>> getTrainerClasses(DateTime date);
  Future<List<User>> getClassParticipants(int classId);
  Future<List<GymClass>> getClassesByLocation(int locationId);

  Future<void> bookClass(int classId);
  Future<void> cancelBooking(int classId);
  Future<void> createClass(Map<String, dynamic> classData);
  Future<void> rescheduleClass(int classId, DateTime newTime);
  Future<void> deleteClass(int classId);
}

class ApiClassesRepository implements IClassesRepository {
  final Dio _dio;
  final OfflineCacheStore _cache;

  ApiClassesRepository(this._dio, this._cache);

  @override
  Future<List<GymClass>> getClassesByLocation(int locationId) async {
    try {
      return await _cache.getOrFetch(
        key: 'classes_by_location_$locationId',
        fetch: () async {
          final response = await _dio.get('/api/classes/location/$locationId');
          final List<dynamic> data = response.data;
          return data.map((json) => GymClass.fromJson(json)).toList();
        },
        toJson: _classesToJson,
        fromJson: _classesFromJson,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        return [];
      }

      throw Exception(
        DioErrorParser.extract(
          e.response,
          e.type,
          defaultMessageBuilder: (l10n) => l10n.errorClassesFetch,
        ),
      );
    } on OfflineCacheMissException {
      throw Exception(
        DioErrorParser.localized((l10n) => l10n.errorClassesFetch),
      );
    }
  }

  @override
  Future<List<GymClass>> getClassesByDate(DateTime date) async {
    try {
      final dateString = "${date.toIso8601String().substring(0, 10)}T00:00:00";
      return await _cache.getOrFetch(
        key: 'classes_by_date_${_dateKey(date)}',
        fetch: () async {
          final response = await _dio.get(
            '/api/classes/by-date',
            queryParameters: {'date': dateString},
          );
          final List<dynamic> data = response.data;
          return data.map((json) => GymClass.fromJson(json)).toList();
        },
        toJson: _classesToJson,
        fromJson: _classesFromJson,
      );
    } on DioException catch (e) {
      throw Exception(
        DioErrorParser.extract(
          e.response,
          e.type,
          defaultMessageBuilder: (l10n) => l10n.errorClassesFetch,
        ),
      );
    } on OfflineCacheMissException {
      throw Exception(
        DioErrorParser.localized((l10n) => l10n.errorClassesFetch),
      );
    }
  }

  @override
  Future<List<GymClass>> getTrainerClasses(DateTime date) async {
    try {
      final dateString = "${date.toIso8601String().substring(0, 10)}T00:00:00";
      return await _cache.getOrFetch(
        key: 'trainer_classes_${_dateKey(date)}',
        fetch: () async {
          final response = await _dio.get(
            '/api/classes/trainer',
            queryParameters: {'date': dateString},
          );
          final List<dynamic> data = response.data;
          return data.map((json) => GymClass.fromJson(json)).toList();
        },
        toJson: _classesToJson,
        fromJson: _classesFromJson,
      );
    } on DioException catch (e) {
      throw Exception(
        DioErrorParser.extract(
          e.response,
          e.type,
          defaultMessageBuilder: (l10n) => l10n.errorTrainerScheduleFetch,
        ),
      );
    } on OfflineCacheMissException {
      throw Exception(
        DioErrorParser.localized((l10n) => l10n.errorTrainerScheduleFetch),
      );
    }
  }

  @override
  Future<List<User>> getClassParticipants(int classId) async {
    try {
      return await _cache.getOrFetch(
        key: 'class_participants_$classId',
        fetch: () async {
          final response = await _dio.get('/api/classes/$classId/participants');
          final List<dynamic> data = response.data;
          return data.map((json) => User.fromJson(json)).toList();
        },
        toJson: _usersToJson,
        fromJson: _usersFromJson,
      );
    } on DioException catch (e) {
      throw Exception(
        DioErrorParser.extract(
          e.response,
          e.type,
          defaultMessageBuilder: (l10n) => l10n.errorClassParticipantsFetch,
        ),
      );
    } on OfflineCacheMissException {
      throw Exception(
        DioErrorParser.localized((l10n) => l10n.errorClassParticipantsFetch),
      );
    }
  }

  @override
  Future<void> bookClass(int classId) async {
    try {
      await _dio.post('/api/classes/$classId/book');
    } on DioException catch (e) {
      throw Exception(
        DioErrorParser.extract(
          e.response,
          e.type,
          defaultMessageBuilder: (l10n) => l10n.errorBookClass,
        ),
      );
    }
  }

  @override
  Future<void> cancelBooking(int classId) async {
    try {
      await _dio.delete('/api/classes/$classId/cancel');
    } on DioException catch (e) {
      throw Exception(
        DioErrorParser.extract(
          e.response,
          e.type,
          defaultMessageBuilder: (l10n) => l10n.errorCancelBooking,
        ),
      );
    }
  }

  @override
  Future<void> createClass(Map<String, dynamic> classData) async {
    try {
      await _dio.post('/api/classes', data: classData);
    } on DioException catch (e) {
      throw Exception(
        DioErrorParser.extract(
          e.response,
          e.type,
          defaultMessageBuilder: (l10n) => l10n.errorCreateClass,
        ),
      );
    }
  }

  @override
  Future<void> rescheduleClass(int classId, DateTime newTime) async {
    try {
      await _dio.patch(
        '/api/classes/$classId/reschedule',
        queryParameters: {'newTime': newTime.toIso8601String()},
      );
    } on DioException catch (e) {
      throw Exception(
        DioErrorParser.extract(
          e.response,
          e.type,
          defaultMessageBuilder: (l10n) => l10n.errorRescheduleClass,
        ),
      );
    }
  }

  @override
  Future<void> deleteClass(int classId) async {
    try {
      await _dio.delete('/api/classes/$classId');
    } on DioException catch (e) {
      throw Exception(
        DioErrorParser.extract(
          e.response,
          e.type,
          defaultMessageBuilder: (l10n) => l10n.errorDeleteClass,
        ),
      );
    }
  }
}

String _dateKey(DateTime date) {
  return date.toIso8601String().substring(0, 10);
}

List<Map<String, dynamic>> _classesToJson(List<GymClass> classes) {
  return classes.map((gymClass) => gymClass.toJson()).toList();
}

List<GymClass> _classesFromJson(Object? json) {
  final data = json as List<dynamic>;
  return data
      .map((item) => GymClass.fromJson(Map<String, dynamic>.from(item as Map)))
      .toList();
}

List<Map<String, dynamic>> _usersToJson(List<User> users) {
  return users.map((user) => user.toJson()).toList();
}

List<User> _usersFromJson(Object? json) {
  final data = json as List<dynamic>;
  return data
      .map((item) => User.fromJson(Map<String, dynamic>.from(item as Map)))
      .toList();
}
