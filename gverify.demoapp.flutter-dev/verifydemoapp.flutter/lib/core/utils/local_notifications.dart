
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();



// initialize the local notifications
  static Future init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    // final DarwinInitializationSettings initializationSettingsDarwin =
    // DarwinInitializationSettings(
    //   onDidReceiveLocalNotification: (id, title, body, payload) =>null,
    // );
    const LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        //iOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux);

    // request notification permissions
    if (Platform.isAndroid) {
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
    } if (Platform.isIOS) {
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()!.requestPermissions(sound: true, alert: true, provisional: true, critical: true, badge: true);
    }


    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    if (Platform.isAndroid) {
      const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
      const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
      await _flutterLocalNotificationsPlugin
          .show(0, title, body, notificationDetails, payload: payload);
    } else {
      const DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails();
      const NotificationDetails notificationDetails =
      NotificationDetails(iOS: iosNotificationDetails);
      await _flutterLocalNotificationsPlugin
          .show(0, title, body, notificationDetails, payload: payload);
    }
  }


  // close a specific channel notification
  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // close all the notifications available
  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}