import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService extends GetxService {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  Future<NotificationService> init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); 
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin!.initialize(initializationSettings);

    return this;
  }

  void showLocalNotification({
    required String title,
    required String body,
    required String payload,
  }) {
    const androidNotificationDetail = AndroidNotificationDetails(
      '0',
      '停車提示',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const iOSNotificationDetail = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      android: androidNotificationDetail,
      iOS: iOSNotificationDetail,
    );
    flutterLocalNotificationsPlugin!.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }


  Future<void> showScheduledNotification({required String title, required String body, required int duration}) async {
    await flutterLocalNotificationsPlugin!.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: duration)),
      const NotificationDetails(
        // Android details
        android: AndroidNotificationDetails(
          '0',
          '停車提示',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,//To show notification even when the app is closed
    );
  }
  
}
