import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_gym_app/core/offline/offline_cache_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late OfflineCacheStore cache;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    cache = OfflineCacheStore(prefs);
  });

  test('getOrFetch stores fresh value after successful fetch', () async {
    final value = await cache.getOrFetch<Map<String, dynamic>>(
      key: 'profile',
      fetch: () async => {'name': 'Alex'},
      toJson: (value) => value,
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );

    expect(value, {'name': 'Alex'});
    expect(cache.readJson('profile'), {'name': 'Alex'});
  });

  test('getOrFetch returns cached value for offline Dio errors', () async {
    await cache.saveJson('profile', {'name': 'Cached Alex'});

    final value = await cache.getOrFetch<Map<String, dynamic>>(
      key: 'profile',
      fetch: () async => throw DioException(
        requestOptions: RequestOptions(path: '/profile'),
        type: DioExceptionType.connectionError,
      ),
      toJson: (value) => value,
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );

    expect(value, {'name': 'Cached Alex'});
  });

  test('getOrFetch throws cache miss when offline cache is empty', () async {
    final call = cache.getOrFetch<Map<String, dynamic>>(
      key: 'profile',
      fetch: () async => throw DioException(
        requestOptions: RequestOptions(path: '/profile'),
        type: DioExceptionType.connectionTimeout,
      ),
      toJson: (value) => value,
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );

    await expectLater(call, throwsA(isA<OfflineCacheMissException>()));
  });

  test('getOrFetch does not fall back to cache for server responses', () async {
    await cache.saveJson('profile', {'name': 'Cached Alex'});

    final error = DioException(
      requestOptions: RequestOptions(path: '/profile'),
      response: Response(
        requestOptions: RequestOptions(path: '/profile'),
        statusCode: 500,
      ),
      type: DioExceptionType.badResponse,
    );

    final call = cache.getOrFetch<Map<String, dynamic>>(
      key: 'profile',
      fetch: () async => throw error,
      toJson: (value) => value,
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );

    await expectLater(call, throwsA(same(error)));
  });
}
