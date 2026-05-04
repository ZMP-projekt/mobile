import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/dio_client.dart';
import 'offline_image_cache.dart';

final offlineImageCacheProvider = Provider<OfflineImageCache>((ref) {
  return OfflineImageCache(ref.watch(dioProvider));
});

final cachedImageFileProvider = FutureProvider.autoDispose
    .family<File?, String>((ref, imageUrl) async {
      return ref.watch(offlineImageCacheProvider).getOrDownload(imageUrl);
    });
