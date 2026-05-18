import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_token_store.dart';
import 'offline_cache_store.dart';

final offlineCacheStoreProvider = Provider<OfflineCacheStore>((ref) {
  final token = ref.watch(authTokenValueProvider);
  return OfflineCacheStore(
    ref.watch(secureStorageProvider),
    namespace: token == null || token.isEmpty ? null : _stableHash(token),
  );
});

String _stableHash(String value) {
  var hash = 0x811c9dc5;

  for (final codeUnit in value.codeUnits) {
    hash ^= codeUnit;
    hash = (hash * 0x01000193) & 0xffffffff;
  }

  return hash.toRadixString(16).padLeft(8, '0');
}
