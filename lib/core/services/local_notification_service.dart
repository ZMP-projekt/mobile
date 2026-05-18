import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static const _androidChannel = AndroidNotificationChannel(
    'gym_notifications',
    'Powiadomienia',
    description: 'Powiadomienia z GymSystem',
    importance: Importance.high,
  );

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.createNotificationChannel(_androidChannel);
    await android?.requestNotificationsPermission();

    _initialized = true;
  }

  static Future<void> show(int id, String content) async {
    if (!_initialized) {
      await init();
    }

    await _plugin.show(
      id,
      'Siłownia',
      content,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }
}
