import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';
import '../util/qr_generator.dart';

final qrEntryCodeProvider = StreamProvider.autoDispose<String>((ref) async* {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) return;

  const interval = 15000;
  int lastWindow = -1;
  String currentPayload = '';

  while (true) {
    int currentWindow = DateTime.now().millisecondsSinceEpoch ~/ interval;

    if (currentWindow != lastWindow) {
      currentPayload = QrGenerator.generateEntryPayload(user.id);
      lastWindow = currentWindow;
    }

    yield currentPayload;

    await Future.delayed(const Duration(milliseconds: 100));
  }
});
