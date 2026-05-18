import 'package:dio/dio.dart';
import '../../../../core/network/dio_error_parser.dart';
import '../models/notification.dart';

class NotificationRepository {
  final Dio _dio;
  NotificationRepository(this._dio);

  Future<List<AppNotification>> getNotifications() async {
    try {
      final response = await _dio.get('/api/notifications');
      final data = response.data;
      if (data is! List) return [];

      return data
          .map(
            (json) => AppNotification.fromJson(
              Map<String, dynamic>.from(json as Map),
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception(DioErrorParser.extract(e.response, e.type));
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _dio.patch('/api/notifications/$id/read');
    } on DioException catch (e) {
      throw Exception(DioErrorParser.extract(e.response, e.type));
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      await _dio.delete('/api/notifications/$id');
    } on DioException catch (e) {
      throw Exception(DioErrorParser.extract(e.response, e.type));
    }
  }
}
