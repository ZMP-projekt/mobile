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
    String serverTime = json['createdAt'] ?? DateTime.now().toIso8601String();


    if (!serverTime.endsWith('Z')) {
      serverTime = '${serverTime}Z';
    }

    final localTimeStr = DateTime.parse(serverTime).toLocal().toIso8601String();

    return {
      'id': json['id'],
      'content': json['content'],
      'createdAt': localTimeStr,
      'read': json['read'] ?? false,
    };
  }
}