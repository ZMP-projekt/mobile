import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

class DioErrorParser {
  static String localized(String Function(AppLocalizations l10n) builder) {
    return builder(_currentL10n());
  }

  static String extract(
    Response? response,
    DioExceptionType type, {
    String? defaultMessage,
    String Function(AppLocalizations l10n)? defaultMessageBuilder,
  }) {
    if (response != null && response.data != null) {
      final data = response.data;

      if (data is Map<String, dynamic>) {
        return data['message'] ??
            data['error'] ??
            _defaultForType(type, defaultMessage, defaultMessageBuilder);
      } else if (data is String && data.isNotEmpty) {
        return data;
      }
    }
    return _defaultForType(type, defaultMessage, defaultMessageBuilder);
  }

  static String _defaultForType(
    DioExceptionType type,
    String? fallback,
    String Function(AppLocalizations l10n)? fallbackBuilder,
  ) {
    final l10n = _currentL10n();

    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return l10n.errorConnectionTimeout;
      case DioExceptionType.badResponse:
        return l10n.errorServer;
      case DioExceptionType.cancel:
        return l10n.errorRequestCanceled;
      case DioExceptionType.connectionError:
        return l10n.errorNoInternet;
      default:
        return fallbackBuilder?.call(l10n) ??
            fallback ??
            l10n.commonUnknownError;
    }
  }

  static AppLocalizations _currentL10n() {
    final localeCode = Intl.getCurrentLocale().split('_').first;
    return lookupAppLocalizations(Locale(localeCode));
  }
}
