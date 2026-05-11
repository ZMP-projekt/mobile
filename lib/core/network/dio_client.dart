import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_token_store.dart';
import '../config/env.dart';
import '../util/app_logger.dart';
import 'network_status_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
      ),
    );
  }

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final isAuthEndpoint = options.path.contains('/auth/');

        if (!isAuthEndpoint) {
          final token = await ref.read(authTokenStoreProvider).read();
          if (token == null) {
            AppLogger.w('Brak tokena dla żądania: ${options.path}');
            return handler.next(options);
          }

          options.headers['Authorization'] = 'Bearer $token';
          AppLogger.d('Dodano nagłówek Authorization dla: ${options.path}');
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        ref.read(isOfflineProvider.notifier).state = false;
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        final isAuthEndpoint = e.requestOptions.path.contains('/auth/');
        final isConnectionProblem =
            e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout;

        if (isConnectionProblem) {
          ref.read(isOfflineProvider.notifier).state = true;
        }

        if (e.response?.statusCode == 401 && !isAuthEndpoint) {
          AppLogger.w("Token wygasł lub jest nieprawidłowy.");
          await ref.read(authTokenStoreProvider).clear();
        }

        return handler.next(e);
      },
    ),
  );

  return dio;
});
