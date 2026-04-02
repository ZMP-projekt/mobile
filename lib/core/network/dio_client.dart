import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/env.dart';
import '../util/app_logger.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final authTokenProvider = StateProvider<String?>((ref) => null);

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: Env.apiUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
    ));
  }

  dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        var token = ref.read(authTokenProvider);

        if (token == null) {
          final storage = ref.read(secureStorageProvider);
          token = await storage.read(key: 'jwt_token');

          if (token != null) {
            ref.read(authTokenProvider.notifier).state = token;
          }
        }

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          AppLogger.d("Dodano token do nagłówka: ${options.path}");
        } else {
          AppLogger.w("Brak tokena dla żądania: ${options.path}");
        }

        return handler.next(options);
      },
      onError: (DioException e, handler) {
        final isAuthEndpoint = e.requestOptions.path.contains('/auth/login') ||
            e.requestOptions.path.contains('/auth/register');

        if (e.response?.statusCode == 401 && !isAuthEndpoint) {
          AppLogger.w("Token wygasł lub jest nieprawidłowy.");
          ref.read(authTokenProvider.notifier).state = null;
          ref.read(secureStorageProvider).delete(key: 'jwt_token');
        }

        return handler.next(e);
      }
  ));

  return dio;
});