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
            _defaultForType(
              type,
              defaultMessage,
              defaultMessageBuilder,
              response.statusCode,
            );
      } else if (data is String && data.isNotEmpty) {
        return data;
      }
    }
    return _defaultForType(
      type,
      defaultMessage,
      defaultMessageBuilder,
      response?.statusCode,
    );
  }

  static String _defaultForType(
    DioExceptionType type,
    String? fallback,
    String Function(AppLocalizations l10n)? fallbackBuilder,
    int? statusCode,
  ) {
    final l10n = _currentL10n();

    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return l10n.errorConnectionTimeout;
      case DioExceptionType.badResponse:
        if (_isWakingServerStatus(statusCode)) {
          return l10n.errorServerWaking;
        }
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

  static bool _isWakingServerStatus(int? statusCode) {
    return statusCode == 502 || statusCode == 503 || statusCode == 504;
  }

  static AppLocalizations _currentL10n() {
    final localeCode = Intl.getCurrentLocale().split('_').first;
    return lookupAppLocalizations(Locale(localeCode));
  }
}
