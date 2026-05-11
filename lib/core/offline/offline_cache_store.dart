import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OfflineCacheMissException implements Exception {
  final String key;

  const OfflineCacheMissException(this.key);

  @override
  String toString() => 'No offline cache available for $key';
}

class OfflineCacheStore {
  final FlutterSecureStorage _storage;

  const OfflineCacheStore(this._storage);

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
    final raw = await _storage.read(key: key);
    if (raw == null || raw.isEmpty) return null;
    return jsonDecode(raw);
  }

  Future<void> saveJson(String key, Object? json) async {
    await _storage.write(key: key, value: jsonEncode(json));
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
