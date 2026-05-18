import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_gym_app/core/offline/offline_cache_store.dart';

void main() {
  late OfflineCacheStore cache;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    cache = const OfflineCacheStore(FlutterSecureStorage());
  });

  test('getOrFetch stores fresh value after successful fetch', () async {
    final value = await cache.getOrFetch<Map<String, dynamic>>(
      key: 'profile',
      fetch: () async => {'name': 'Alex'},
      toJson: (value) => value,
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );

    expect(value, {'name': 'Alex'});
    await expectLater(cache.readJson('profile'), completion({'name': 'Alex'}));
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

  test('namespaces cached values between sessions', () async {
    final firstUserCache = const OfflineCacheStore(
      FlutterSecureStorage(),
      namespace: 'user-a',
    );
    final secondUserCache = const OfflineCacheStore(
      FlutterSecureStorage(),
      namespace: 'user-b',
    );

    await firstUserCache.saveJson('profile', {'name': 'First'});
    await secondUserCache.saveJson('profile', {'name': 'Second'});

    await expectLater(
      firstUserCache.readJson('profile'),
      completion({'name': 'First'}),
    );
    await expectLater(
      secondUserCache.readJson('profile'),
      completion({'name': 'Second'}),
    );
  });

  test('clearAll removes cached values', () async {
    await cache.saveJson('profile', {'name': 'Cached Alex'});

    await cache.clearAll();

    await expectLater(cache.readJson('profile'), completion(isNull));
  });

  test('clearAll keeps unrelated secure storage values', () async {
    const storage = FlutterSecureStorage();

    await cache.saveJson('profile', {'name': 'Cached Alex'});
    await storage.write(key: 'jwt_token', value: 'api-token');

    await cache.clearAll();

    await expectLater(storage.read(key: 'jwt_token'), completion('api-token'));
  });
}
