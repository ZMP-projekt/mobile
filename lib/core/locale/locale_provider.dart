import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/shared_preferences_provider.dart';

final localeNotifierProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref.watch(sharedPreferencesProvider));
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._prefs) : super(_readInitialLocale(_prefs));

  static const _key = 'app_locale';
  static const supportedLocales = [
    Locale('pl'),
    Locale('en'),
  ];

  final SharedPreferences _prefs;

  static Locale _readInitialLocale(SharedPreferences prefs) {
    final savedCode = prefs.getString(_key);
    return supportedLocales.firstWhere(
      (locale) => locale.languageCode == savedCode,
      orElse: () => const Locale('pl'),
    );
  }

  Future<void> setLocale(Locale locale) async {
    final normalizedLocale = supportedLocales.firstWhere(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
      orElse: () => const Locale('pl'),
    );

    state = normalizedLocale;
    await _prefs.setString(_key, normalizedLocale.languageCode);
  }

  Future<void> toggleLocale() {
    return setLocale(
      state.languageCode == 'pl' ? const Locale('en') : const Locale('pl'),
    );
  }
}
