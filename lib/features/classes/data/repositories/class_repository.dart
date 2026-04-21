import 'package:dio/dio.dart';
import '../../../../core/network/dio_error_parser.dart';
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

  ApiClassesRepository(this._dio);

  @override
  Future<List<GymClass>> getClassesByLocation(int locationId) async {
    final response = await _dio.get('/api/classes/location/$locationId');
    final List<dynamic> data = response.data;
    return data.map((json) => GymClass.fromJson(json)).toList();
  }

  @override
  Future<List<GymClass>> getClassesByDate(DateTime date) async {
    try {
      final dateString = "${date.toIso8601String().substring(0, 10)}T00:00:00";
      final response = await _dio.get('/api/classes/by-date', queryParameters: {'date': dateString});
      final List<dynamic> data = response.data;
      return data.map((json) => GymClass.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(DioErrorParser.extract(e.response, e.type, defaultMessage: 'Nie udało się pobrać grafiku zajęć.'));
    }
  }

  @override
  Future<List<GymClass>> getTrainerClasses(DateTime date) async {
    try {
      final dateString = "${date.toIso8601String().substring(0, 10)}T00:00:00";
      final response = await _dio.get('/api/classes/trainer', queryParameters: {'date': dateString});
      final List<dynamic> data = response.data;
      return data.map((json) => GymClass.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(DioErrorParser.extract(e.response, e.type, defaultMessage: 'Nie udało się pobrać Twojego grafiku.'));
    }
  }

  @override
  Future<List<User>> getClassParticipants(int classId) async {
    try {
      final response = await _dio.get('/api/classes/$classId/participants');
      final List<dynamic> data = response.data;
      return data.map((json) => User.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(DioErrorParser.extract(e.response, e.type, defaultMessage: 'Nie udało się pobrać listy uczestników.'));
    }
  }

  @override
  Future<void> bookClass(int classId) async {
    try {
      await _dio.post('/api/classes/$classId/book');
    } on DioException catch (e) {
      throw Exception(DioErrorParser.extract(e.response, e.type, defaultMessage: 'Nie udało się zarezerwować zajęć.'));
    }
  }

  @override
  Future<void> cancelBooking(int classId) async {
    try {
      await _dio.delete('/api/classes/$classId/cancel');
    } on DioException catch (e) {
      throw Exception(DioErrorParser.extract(e.response, e.type, defaultMessage: 'Nie udało się anulować rezerwacji.'));
    }
  }

  @override
  Future<void> createClass(Map<String, dynamic> classData) async {
    try {
      await _dio.post('/api/classes', data: classData);
    } on DioException catch (e) {
      throw Exception(DioErrorParser.extract(e.response, e.type, defaultMessage: 'Błąd tworzenia zajęć.'));
    }
  }

  @override
  Future<void> rescheduleClass(int classId, DateTime newTime) async {
    try {
      await _dio.patch(
        '/api/classes/$classId/reschedule',
        queryParameters: {
          'newTime': newTime.toIso8601String(),
        },
      );
    } on DioException catch (e) {
      throw Exception(DioErrorParser.extract(e.response, e.type, defaultMessage: 'Błąd przekładania zajęć.'));
    }
  }

  @override
  Future<void> deleteClass(int classId) async {
    try {
      await _dio.delete('/api/classes/$classId');
    } on DioException catch (e) {
      throw Exception(DioErrorParser.extract(e.response, e.type, defaultMessage: 'Błąd usuwania zajęć.'));
    }
  }
}