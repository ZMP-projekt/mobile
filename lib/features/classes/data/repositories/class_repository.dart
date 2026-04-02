import 'package:dio/dio.dart';
import '../models/gym_class.dart';
import '../../../user/data/models/user.dart';

abstract class IClassesRepository {
  Future<List<GymClass>> getClassesByDate(DateTime date);
  Future<List<GymClass>> getTrainerClasses(DateTime date);
  Future<List<User>> getClassParticipants(int classId);

  Future<void> bookClass(int classId);
  Future<void> cancelBooking(int classId);
  Future<void> createClass(Map<String, dynamic> classData);
  Future<void> rescheduleClass(int classId, DateTime newStart, DateTime newEnd);
  Future<void> deleteClass(int classId);
}

class ApiClassesRepository implements IClassesRepository {
  final Dio _dio;

  ApiClassesRepository(this._dio);

  String _extractErrorMessage(Response? response, String defaultMessage) {
    if (response != null && response.data != null) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data['message'] ?? data['error'] ?? defaultMessage;
      }
      else if (data is String && data.isNotEmpty) {
        return data;
      }
    }
    return defaultMessage;
  }

  @override
  Future<List<GymClass>> getClassesByDate(DateTime date) async {
    try {
      final dateString = "${date.toIso8601String().substring(0, 10)}T00:00:00";
      final response = await _dio.get('/api/classes', queryParameters: {'date': dateString});
      final List<dynamic> data = response.data;
      return data.map((json) => GymClass.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e.response, 'Nie udało się pobrać grafiku zajęć.'));
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
      throw Exception(_extractErrorMessage(e.response, 'Nie udało się pobrać Twojego grafiku.'));
    }
  }

  @override
  Future<List<User>> getClassParticipants(int classId) async {
    try {
      final response = await _dio.get('/api/classes/$classId/participants');

      final List<dynamic> data = response.data;
      return data.map((json) => User.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e.response, 'Nie udało się pobrać listy uczestników.'));
    }
  }

  @override
  Future<void> bookClass(int classId) async {
    try {
      await _dio.post('/api/classes/$classId/book');
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e.response, 'Nie udało się zarezerwować zajęć.'));
    }
  }

  @override
  Future<void> cancelBooking(int classId) async {
    try {
      await _dio.delete('/api/classes/$classId/cancel');
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e.response, 'Nie udało się anulować rezerwacji.'));
    }
  }

  @override
  Future<void> createClass(Map<String, dynamic> classData) async {
    try {
      await _dio.post('/api/classes', data: classData);
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e.response, 'Błąd tworzenia zajęć.'));
    }
  }

  @override
  Future<void> rescheduleClass(int classId, DateTime newStart, DateTime newEnd) async {
    try {
      await _dio.patch('/api/classes/$classId/reschedule', data: {
        'startTime': newStart.toIso8601String(),
        'endTime': newEnd.toIso8601String(),
      });
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e.response, 'Błąd przekładania zajęć.'));
    }
  }

  @override
  Future<void> deleteClass(int classId) async {
    try {
      await _dio.delete('/api/classes/$classId');
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e.response, 'Błąd usuwania zajęć.'));
    }
  }
}