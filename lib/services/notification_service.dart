import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await notifications.initialize(settings);
  }

  /// NOTIF LANGSUNG
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'agenda_channel',
      'Agenda Reminder',
      channelDescription: 'Notifikasi agenda',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await notifications.show(
      0,
      title,
      body,
      details,
    );
  }

  /// NOTIF TERJADWAL 
  static Future<void> scheduleTaskNotification({
    required int id,
    required String taskTitle,
    required DateTime dateTime,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'agenda_channel',
      'Agenda Reminder',
      channelDescription: 'Notifikasi agenda',
      importance: Importance.max,
      priority: Priority.high,
    );

    await notifications.zonedSchedule(
      id,
      'Reminder Agenda',
      '$taskTitle sebentar lagi / sudah waktunya',
      tz.TZDateTime.from(dateTime, tz.local),
      const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
    );
  }

  static Future<void> cancel(int id) async {
    await notifications.cancel(id);
  }

  static Future<void> cancelAll() async {
    await notifications.cancelAll();
  }
}