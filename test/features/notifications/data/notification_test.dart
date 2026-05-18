import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_gym_app/features/notifications/data/models/notification.dart';

void main() {
  test('fromJson parses createdAt with timezone offset', () {
    final notification = AppNotification.fromJson({
      'id': 1,
      'content': 'Class added',
      'createdAt': '2026-05-09T10:00:00+02:00',
      'read': false,
    });

    expect(notification.createdAt.toUtc(), DateTime.utc(2026, 5, 9, 8));
  });

  test('fromJson treats createdAt without timezone as UTC', () {
    final notification = AppNotification.fromJson({
      'id': 1,
      'content': 'Class added',
      'createdAt': '2026-05-09T10:00:00',
      'read': false,
    });

    expect(notification.createdAt.toUtc(), DateTime.utc(2026, 5, 9, 10));
  });
}
