import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../data/models/gym_class.dart';

extension GymClassImageExt on GymClass {
  String get displayImageUrl {
    return imageUrl?.trim() ?? '';
  }

  String get startTimeFormatted => DateFormat.Hm().format(startTime);

  String dateFormatted(String localeName) {
    return DateFormat.MMMd(localeName).format(startTime);
  }

  String dayOfWeek(String localeName) {
    return DateFormat.EEEE(localeName).format(startTime);
  }

  String trainerDisplayName(AppLocalizations l10n) {
    final name = trainer.fullName.trim();
    return name.isEmpty ? l10n.classesUnknownTrainer : name;
  }
}
