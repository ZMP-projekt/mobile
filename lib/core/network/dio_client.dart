import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../util/app_logger.dart';

final dioProvider = Provider<Dio>((ref) => DioClient().dio);

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api-j6d6.onrender.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    ),
  );

  DioClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!options.path.contains('/auth/')) {
            const storage = FlutterSecureStorage();
            final token = await storage.read(key: 'jwt_token');

            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
              AppLogger.i("📡 Dodano token do zapytania: ${options.path}");
            }
          } else {
            AppLogger.i("🔓 Publiczne zapytanie (bez tokena): ${options.path}");
          }

          return handler.next(options);
        },
      )
    );
  }

  Dio get dio => _dio;
}