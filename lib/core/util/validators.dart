import '../../l10n/app_localizations.dart';

class AppValidators {
  static String? validateEmail(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validationEmailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return l10n.validationEmailInvalid;
    }
    return null;
  }

  static String? validatePassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.validationPasswordRequired;
    }
    if (value.length < 4) {
      return l10n.validationPasswordMinLength(4);
    }
    return null;
  }

  static String? validateRequired(
    String? value,
    String fieldName,
    AppLocalizations l10n,
  ) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validationRequiredField(fieldName);
    }
    return null;
  }
}
