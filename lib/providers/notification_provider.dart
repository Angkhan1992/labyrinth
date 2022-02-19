import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider {
  static const keyFriendRequest = 'key_friend_request';
  static const keyFriendAccept = 'key_friend_accept';
  static const keyMessageChannel = 'key_message';

  final BuildContext? context;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationProvider(this.context);

  factory NotificationProvider.of(BuildContext? context) {
    return NotificationProvider(context);
  }

  void init() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('show_icon');
    var initializationSettingsIOs = const IOSInitializationSettings();
    var initSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOs,
    );
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: (value) {},
    );
  }

  // Future onSelectNotification(String payload) async {
  //   print('notification service ===> $payload');
  //   switch (payload) {
  //     case keyFriendRequest:
  //       NavigatorService(context).pushToWidget(screen: RequestScreen());
  //       break;
  //     case keyFriendAccept:
  //       NavigatorService(context).pushToWidget(screen: FriendListScreen());
  //       break;
  //   }
  // }

  static void showNotification({
    required String title,
    required String description,
    required String type,
  }) async {
    var android = const AndroidNotificationDetails(
      'id',
      'channel ',
      channelDescription: 'description',
      priority: Priority.high,
      importance: Importance.max,
    );
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(
      android: android,
      iOS: iOS,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      description,
      platform,
      payload: type,
    );
  }
}
