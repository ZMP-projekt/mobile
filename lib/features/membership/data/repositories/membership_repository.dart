import 'package:dio/dio.dart';
import '../../../../core/models/result.dart';
import '../models/membership.dart';

class MembershipRepository {
  final Dio _dio;

  MembershipRepository(this._dio);

  Future<Membership> getMyMembership() async {
    try {
      final response = await _dio.get('/api/memberships/me');
      return Membership.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 || e.response?.statusCode == 403) {
        return Membership(
          active: false,
          endDate: DateTime.now().subtract(const Duration(days: 1)),
          price: 0.0,
          type: 'BRAK',
        );
      }
      throw Exception(e.response?.data['message'] ?? 'Nie udało się pobrać karnetu.');
    } catch (e) {
      throw Exception('Wystąpił nieoczekiwany błąd podczas pobierania karnetu.');
    }
  }

  Future<Result<void>> purchaseMembership(String type) async {
    try {
      await _dio.post(
        '/api/memberships/purchase',
        queryParameters: {'type': type},
      );
      return Result.success(null);
    } on DioException catch (e) {
      final backendError = e.response?.data?['message'];
      return Result.failure(backendError ?? e.message ?? 'Nie udało się zakupić karnetu.');
    } catch (e) {
      return Result.failure('Wystąpił nieoczekiwany błąd.');
    }
  }
}