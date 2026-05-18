import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _cacheKeyPrefix = 'offline_cache:';
const _publicCacheNamespace = 'public';

class OfflineCacheMissException implements Exception {
  final String key;

  const OfflineCacheMissException(this.key);

  @override
  String toString() => 'No offline cache available for $key';
}

class OfflineCacheStore {
  final FlutterSecureStorage _storage;
  final String? _namespace;

  const OfflineCacheStore(this._storage, {String? namespace})
    : _namespace = namespace;

  Future<T> getOrFetch<T>({
    required String key,
    required Future<T> Function() fetch,
    required Object? Function(T value) toJson,
    required T Function(Object? json) fromJson,
  }) async {
    try {
      final value = await fetch();
      await saveJson(key, toJson(value));
      return value;
    } on DioException catch (error) {
      if (!error.isOfflineFailure) rethrow;

      final cachedJson = await readJson(key);
      if (cachedJson == null) throw OfflineCacheMissException(key);
      return fromJson(cachedJson);
    }
  }

  Future<Object?> readJson(String key) async {
    final raw = await _storage.read(key: _scopedKey(key));
    if (raw == null || raw.isEmpty) return null;
    return jsonDecode(raw);
  }

  Future<void> saveJson(String key, Object? json) async {
    await _storage.write(key: _scopedKey(key), value: jsonEncode(json));
  }

  Future<void> clearAll() async {
    final values = await _storage.readAll();
    final cacheKeys = values.keys
        .where((key) => key.startsWith(_cacheKeyPrefix))
        .toList();

    for (final key in cacheKeys) {
      await _storage.delete(key: key);
    }
  }

  String _scopedKey(String key) {
    final namespace = _namespace ?? _publicCacheNamespace;
    return '$_cacheKeyPrefix$namespace:$key';
  }
}

extension OfflineDioExceptionX on DioException {
  bool get isOfflineFailure {
    if (response != null) return false;

    return type == DioExceptionType.connectionError ||
        type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout ||
        error is SocketException;
  }
}
