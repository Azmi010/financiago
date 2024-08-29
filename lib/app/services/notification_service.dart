import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationsResponse) async {});
  }

  NotificationDetails notificationDetails(String channelId) {
    return NotificationDetails(
        android: AndroidNotificationDetails(
            channelId, 'channel_name',
            playSound: true,
            sound: const RawResourceAndroidNotificationSound('notif'),
            importance: Importance.max,
            priority: Priority.high,
            enableLights: true,
            enableVibration: true,
            visibility: NotificationVisibility.public),
        iOS: const DarwinNotificationDetails());
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String sound,
    required String channelId,
    tz.TZDateTime? scheduledTime,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(channelId),
    );
  }

  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }
}
