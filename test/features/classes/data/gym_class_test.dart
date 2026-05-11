import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_gym_app/features/classes/data/models/gym_class.dart';
import 'package:mobile_gym_app/features/classes/utils/gym_class_extension.dart';
import 'package:mobile_gym_app/l10n/app_localizations_en.dart';
import 'package:mobile_gym_app/l10n/app_localizations_pl.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pl_PL', null);
  });

  Map<String, dynamic> classJson({String? trainerName, String? imageUrl}) {
    final json = {
      'id': 1,
      'name': 'Yoga',
      'startTime': '2026-05-06T10:00:00Z',
      'endTime': '2026-05-06T11:00:00Z',
    };
    if (trainerName != null) {
      json['trainerName'] = trainerName;
    }
    if (imageUrl != null) {
      json['imageUrl'] = imageUrl;
    }
    return json;
  }

  test('fromJson keeps missing trainer fallback neutral in data model', () {
    final gymClass = GymClass.fromJson(classJson());

    expect(gymClass.trainer.firstName, isEmpty);
    expect(gymClass.trainer.lastName, isEmpty);
  });

  test('trainerDisplayName returns localized fallback for missing trainer', () {
    final gymClass = GymClass.fromJson(classJson());

    expect(
      gymClass.trainerDisplayName(AppLocalizationsEn()),
      AppLocalizationsEn().classesUnknownTrainer,
    );
  });

  test('fromJson splits trainerName into first and last name', () {
    final gymClass = GymClass.fromJson(classJson(trainerName: 'Anna Kowalska'));

    expect(gymClass.trainer.firstName, 'Anna');
    expect(gymClass.trainer.lastName, 'Kowalska');
  });

  test('fromJson keeps multi-part trainer last name', () {
    final gymClass = GymClass.fromJson(
      classJson(trainerName: 'Anna Maria Kowalska'),
    );

    expect(gymClass.trainer.firstName, 'Anna');
    expect(gymClass.trainer.lastName, 'Maria Kowalska');
  });

  test('fromJson treats blank trainerName as missing trainer', () {
    final gymClass = GymClass.fromJson(classJson(trainerName: '   '));

    expect(gymClass.trainer.firstName, isEmpty);
    expect(gymClass.trainer.lastName, isEmpty);
    expect(
      gymClass.trainerDisplayName(AppLocalizationsPl()),
      AppLocalizationsPl().classesUnknownTrainer,
    );
  });

  test('displayImageUrl trims image url and falls back to empty string', () {
    final gymClassWithImage = GymClass.fromJson(
      classJson(imageUrl: '  https://example.com/yoga.jpg  '),
    );
    final gymClassWithoutImage = GymClass.fromJson(classJson());
    final gymClassWithBlankImage = GymClass.fromJson(
      classJson(imageUrl: '   '),
    );

    expect(gymClassWithImage.displayImageUrl, 'https://example.com/yoga.jpg');
    expect(gymClassWithoutImage.displayImageUrl, isEmpty);
    expect(gymClassWithBlankImage.displayImageUrl, isEmpty);
  });

  test('date helpers format time and localized Polish date labels', () {
    final gymClass = GymClass.fromJson(classJson());

    expect(gymClass.startTimeFormatted, '10:00');
    expect(gymClass.dayOfWeek('pl_PL'), 'środa');
    expect(gymClass.dateFormatted('pl_PL'), contains('6'));
    expect(gymClass.dateFormatted('pl_PL'), contains('maj'));
  });
}
