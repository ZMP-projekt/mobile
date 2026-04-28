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
      throw Exception(DioErrorParser.extract(e.response, e.type, defaultMessageBuilder: (l10n) => l10n.errorTrainersFetch));
    } catch (e) {
      throw Exception(DioErrorParser.localized((l10n) => l10n.errorTrainersUnexpected));
    }
  }
}
