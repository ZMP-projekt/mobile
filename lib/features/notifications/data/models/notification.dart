import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required int id,
    required String content,
    required DateTime createdAt,
    required bool read,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(_sanitize(json));

  static Map<String, dynamic> _sanitize(Map<String, dynamic> json) {
    final createdAt = _parseCreatedAt(json['createdAt']);

    return {
      'id': json['id'],
      'content': json['content'],
      'createdAt': createdAt.toIso8601String(),
      'read': json['read'] ?? false,
    };
  }

  static DateTime _parseCreatedAt(Object? value) {
    if (value is DateTime) return value.toLocal();

    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        final hasTimeZone = RegExp(
          r'(z|[+-]\d{2}:?\d{2})$',
          caseSensitive: false,
        ).hasMatch(trimmed);
        final normalized = hasTimeZone ? trimmed : '${trimmed}Z';
        return DateTime.parse(normalized).toLocal();
      }
    }

    return DateTime.now();
  }
}
