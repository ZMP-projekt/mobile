import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../trainer/models/trainer.dart';

part 'gym_class.freezed.dart';
part 'gym_class.g.dart';

@freezed
class GymClass with _$GymClass {
  const GymClass._();

  const factory GymClass({
    required int id,
    required String name,
    required DateTime startTime,
    required DateTime endTime,
    required Trainer trainer,
    required int maxParticipants,
    required int currentParticipants,
    @Default(false) bool userEnrolled,
    String? description,
    String? imageUrl,
  }) = _GymClass;

  int get durationMinutes => endTime.difference(startTime).inMinutes;
  bool get isFull => currentParticipants >= maxParticipants;
  int get spotsLeft => maxParticipants - currentParticipants;
  bool get isPast => DateTime.now().isAfter(endTime);
  bool get isOngoing => DateTime.now().isAfter(startTime) && DateTime.now().isBefore(endTime);
  bool get isFuture => DateTime.now().isBefore(startTime);

  String get startTimeFormatted =>
      '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';

  String get dateFormatted {
    final months = ['Sty', 'Lut', 'Mar', 'Kwi', 'Maj', 'Cze', 'Lip', 'Sie', 'Wrz', 'Paź', 'Lis', 'Gru'];
    return '${startTime.day} ${months[startTime.month - 1]}';
  }

  String get dayOfWeek {
    final days = ['Poniedziałek', 'Wtorek', 'Środa', 'Czwartek', 'Piątek', 'Sobota', 'Niedziela'];
    return days[startTime.weekday - 1];
  }

  bool get isToday {
    final now = DateTime.now();
    return startTime.year == now.year && startTime.month == now.month && startTime.day == now.day;
  }

  @override
  String toString() {
    return 'GymClass(id: $id, name: $name, startTime: $startTimeFormatted, spots: $spotsLeft/$maxParticipants, booked: $userEnrolled)';
  }

  factory GymClass.fromJson(Map<String, dynamic> json) =>
      _$GymClassFromJson(_preProcessJson(json));

  static Map<String, dynamic> _preProcessJson(Map<String, dynamic> json) {
    if (json['trainer'] == null) {
      final fullName = (json['trainerName'] as String?) ?? 'Nieznany Trener';
      final nameParts = fullName.split(' ');

      final map = Map<String, dynamic>.from(json);
      map['trainer'] = {
        'firstName': nameParts.first,
        'lastName': nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
      };
      return map;
    }
    return json;
  }
}