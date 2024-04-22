import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:timezone/timezone.dart';

class NotificationsService {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() {
    _notification.initialize(const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings()));
    initializeTimeZones();
  }

  static cancelNotification(int id) async {
    await _notification.cancel(id);
  }

  static scheduledNotification({
    required int id,
    required String title,
    required String body,
    required TZDateTime notificationTime,
  }) async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      'important_notifications',
      'channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iosDetails = const DarwinNotificationDetails();
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _notification.zonedSchedule(
      id,
      title,
      body,
      notificationTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
