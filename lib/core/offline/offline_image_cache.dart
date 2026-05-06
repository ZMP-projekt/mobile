import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class OfflineImageCache {
  final Dio _dio;

  const OfflineImageCache(this._dio);

  Future<File?> getOrDownload(String imageUrl) async {
    final uri = Uri.tryParse(imageUrl.trim());
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) return null;

    final file = await _fileFor(uri);
    if (await file.exists()) return file;

    try {
      final response = await _dio.get<List<int>>(
        uri.toString(),
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) return null;

      await file.writeAsBytes(Uint8List.fromList(bytes), flush: true);
      return file;
    } on DioException {
      if (await file.exists()) return file;
      return null;
    } on FileSystemException {
      return null;
    }
  }

  Future<File> _fileFor(Uri uri) async {
    final directory = await getApplicationDocumentsDirectory();
    final imageDirectory = Directory('${directory.path}/class_images');

    if (!await imageDirectory.exists()) {
      await imageDirectory.create(recursive: true);
    }

    final extension = _extensionFor(uri.path);
    return File(
      '${imageDirectory.path}/${_stableHash(uri.toString())}$extension',
    );
  }
}

String _extensionFor(String path) {
  final lowerPath = path.toLowerCase();
  final lastDot = lowerPath.lastIndexOf('.');

  if (lastDot == -1 || lastDot == lowerPath.length - 1) return '.img';

  final extension = lowerPath.substring(lastDot);
  return switch (extension) {
    '.jpg' || '.jpeg' || '.png' || '.webp' => extension,
    _ => '.img',
  };
}

String _stableHash(String value) {
  var hash = 0x811c9dc5;

  for (final codeUnit in value.codeUnits) {
    hash ^= codeUnit;
    hash = (hash * 0x01000193) & 0xffffffff;
  }

  return hash.toRadixString(16).padLeft(8, '0');
}
