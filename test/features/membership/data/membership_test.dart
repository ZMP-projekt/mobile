import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_gym_app/features/membership/data/models/membership.dart';

void main() {
  Membership membership({required bool active, required DateTime endDate}) {
    return Membership(
      active: active,
      endDate: endDate,
      price: 99.0,
      type: 'OPEN',
    );
  }

  group('Membership', () {
    test('is valid through the whole end date day', () {
      final today = _today();
      final endOfToday = DateTime(
        today.year,
        today.month,
        today.day,
        23,
        59,
        59,
      );

      final value = membership(active: true, endDate: endOfToday);

      expect(value.daysRemaining, 1);
      expect(value.isValid, isTrue);
      expect(value.progressValue, closeTo(1 / 30, 0.0001));
    });

    test('is expired when end date was yesterday', () {
      final yesterday = _today().subtract(const Duration(days: 1));

      final value = membership(active: true, endDate: yesterday);

      expect(value.daysRemaining, 0);
      expect(value.isValid, isFalse);
      expect(value.progressValue, 0.0);
    });

    test(
      'is invalid when backend marks it inactive despite future end date',
      () {
        final futureDate = _today().add(const Duration(days: 10));

        final value = membership(active: false, endDate: futureDate);

        expect(value.daysRemaining, 10);
        expect(value.isValid, isFalse);
      },
    );

    test(
      'caps progress at full for memberships with at least 30 days left',
      () {
        final futureDate = _today().add(const Duration(days: 45));

        final value = membership(active: true, endDate: futureDate);

        expect(value.daysRemaining, 45);
        expect(value.progressValue, 1.0);
      },
    );
  });
}

DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}
