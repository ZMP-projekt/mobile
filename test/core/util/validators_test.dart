import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_gym_app/core/util/validators.dart';
import 'package:mobile_gym_app/l10n/app_localizations_en.dart';

void main() {
  group('AppValidators', () {
    late AppLocalizationsEn l10n;

    setUp(() {
      l10n = AppLocalizationsEn();
    });

    group('validateEmail', () {
      test('returns required message for null email', () {
        expect(
          AppValidators.validateEmail(null, l10n),
          l10n.validationEmailRequired,
        );
      });

      test('returns required message for blank email', () {
        expect(
          AppValidators.validateEmail('   ', l10n),
          l10n.validationEmailRequired,
        );
      });

      test('returns invalid message for malformed email', () {
        expect(
          AppValidators.validateEmail('not-an-email', l10n),
          l10n.validationEmailInvalid,
        );
      });

      test('accepts valid email', () {
        expect(AppValidators.validateEmail('john@example.com', l10n), isNull);
      });

      test('trims whitespace before validating email', () {
        expect(
          AppValidators.validateEmail('  john@example.com  ', l10n),
          isNull,
        );
      });
    });

    group('validatePassword', () {
      test('returns required message for null password', () {
        expect(
          AppValidators.validatePassword(null, l10n),
          l10n.validationPasswordRequired,
        );
      });

      test('returns required message for empty password', () {
        expect(
          AppValidators.validatePassword('', l10n),
          l10n.validationPasswordRequired,
        );
      });

      test('returns min length message for short password', () {
        expect(
          AppValidators.validatePassword('abc', l10n),
          l10n.validationPasswordMinLength(4),
        );
      });

      test('accepts password with minimum length', () {
        expect(AppValidators.validatePassword('abcd', l10n), isNull);
      });

      test('accepts longer password', () {
        expect(AppValidators.validatePassword('password123', l10n), isNull);
      });
    });

    group('validateRequired', () {
      test('returns field-specific required message for null value', () {
        expect(
          AppValidators.validateRequired(null, l10n.fieldFirstName, l10n),
          l10n.validationRequiredField(l10n.fieldFirstName),
        );
      });

      test('returns field-specific required message for whitespace value', () {
        expect(
          AppValidators.validateRequired('   ', l10n.fieldLastName, l10n),
          l10n.validationRequiredField(l10n.fieldLastName),
        );
      });

      test('accepts non-empty value', () {
        expect(
          AppValidators.validateRequired('John', l10n.fieldFirstName, l10n),
          isNull,
        );
      });

      test('trims whitespace before validating required value', () {
        expect(
          AppValidators.validateRequired('  John  ', l10n.fieldFirstName, l10n),
          isNull,
        );
      });
    });
  });
}
