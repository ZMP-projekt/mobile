import 'package:dio/dio.dart';
import '../../../../../core/network/dio_error_parser.dart';
import '../models/trainer.dart';

class TrainerRepository {
  final Dio _dio;

  TrainerRepository(this._dio);

  Future<List<Trainer>> getTrainers() async {
    try {
      final response = await _dio.get('/api/trainers');
      final List<dynamic> data = response.data;
      return data.map((json) => Trainer.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(DioErrorParser.extract(e.response, e.type, defaultMessage: 'Nie udało się pobrać listy trenerów.'));
    } catch (e) {
      throw Exception('Wystąpił nieoczekiwany błąd podczas pobierania trenerów.');
    }
  }
}