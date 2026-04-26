import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeNotifierProvider = AsyncNotifierProvider.autoDispose<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});

class LocaleNotifier extends AutoDisposeAsyncNotifier<Locale> {
  static const _key = 'app_locale';

  @override
  FutureOr<Locale> build() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_key);
    return savedCode != null ? Locale(savedCode) : const Locale('pl');
  }

  Future<void> setLocale(Locale locale) async {
    state = const AsyncLoading();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, locale.languageCode);
      state = AsyncData(locale);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}