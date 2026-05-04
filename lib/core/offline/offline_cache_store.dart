import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineCacheMissException implements Exception {
  final String key;

  const OfflineCacheMissException(this.key);

  @override
  String toString() => 'No offline cache available for $key';
}

class OfflineCacheStore {
  final SharedPreferences _prefs;

  const OfflineCacheStore(this._prefs);

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

      final cachedJson = readJson(key);
      if (cachedJson == null) throw OfflineCacheMissException(key);
      return fromJson(cachedJson);
    }
  }

  Object? readJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    return jsonDecode(raw);
  }

  Future<void> saveJson(String key, Object? json) async {
    await _prefs.setString(key, jsonEncode(json));
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
