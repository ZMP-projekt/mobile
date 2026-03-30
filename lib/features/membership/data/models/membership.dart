import 'package:freezed_annotation/freezed_annotation.dart';

part 'membership.freezed.dart';
part 'membership.g.dart';

@freezed
class Membership with _$Membership {
  const Membership._();

  const factory Membership({
    @Default(false) bool active,
    required DateTime endDate,
    required double price,
    @Default('UNKNOWN') String type,
  }) = _Membership;

  factory Membership.fromJson(Map<String, dynamic> json) => _$MembershipFromJson(json);

  int get daysRemaining {
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final endMidnight = DateTime(endDate.year, endDate.month, endDate.day);

    final remaining = endMidnight.difference(todayMidnight).inDays;
    return remaining > 0 ? remaining : 0;
  }

  bool get isValid => active && daysRemaining > 0;

  double get progressValue {
    if (daysRemaining >= 30) return 1.0;
    if (daysRemaining <= 0) return 0.0;
    return daysRemaining / 30.0;
  }
}