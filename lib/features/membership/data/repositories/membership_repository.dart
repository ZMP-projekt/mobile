import 'package:dio/dio.dart';
import '../../../../core/models/result.dart';
import '../../../../core/network/dio_error_parser.dart';
import '../models/membership.dart';

class MembershipRepository {
  final Dio _dio;

  MembershipRepository(this._dio);

  Future<Membership> getMyMembership() async {
    try {
      final response = await _dio.get('/api/memberships/me');
      return Membership.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403 || e.response?.statusCode == 404) {
        return Membership(
          active: false,
          endDate: DateTime.now().subtract(const Duration(days: 1)),
          price: 0.0,
          type: 'BRAK',
        );
      }
      throw Exception(DioErrorParser.extract(e.response, e.type, defaultMessageBuilder: (l10n) => l10n.errorMembershipFetch));
    } catch (e) {
      throw Exception(DioErrorParser.localized((l10n) => l10n.errorMembershipUnexpected));
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
      return Result.failure(backendError ?? DioErrorParser.extract(e.response, e.type, defaultMessageBuilder: (l10n) => l10n.errorMembershipPurchase));
    } catch (e) {
      return Result.failure(DioErrorParser.localized((l10n) => l10n.commonUnknownError));
    }
  }
}
