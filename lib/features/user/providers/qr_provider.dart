import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';
import '../util/qr_generator.dart';

final qrEntryCodeProvider = StreamProvider.autoDispose<String>((ref) async* {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) return;

  while (true) {
    yield QrGenerator.generateEntryPayload(user.id);

    final now = DateTime.now().millisecondsSinceEpoch;
    final timeToNext = 15000 - (now % 15000);

    await Future.delayed(Duration(milliseconds: timeToNext));
  }
});