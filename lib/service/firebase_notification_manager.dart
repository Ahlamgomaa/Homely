import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/chat_screen/chat_screen_controller.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';

class FirebaseNotificationManager {
  static var shared = FirebaseNotificationManager();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'homely', // id
      'Homely Notification', // title
      playSound: true,
      enableLights: true,
      enableVibration: true,
      importance: Importance.max);

  FirebaseNotificationManager() {
    init();
  }

  void init() async {
    subscribeToTopic(null);

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, sound: true);

    await firebaseMessaging.requestPermission(
        alert: true, badge: false, sound: true);

    var initializationSettingsAndroid = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    var initializationSettingsIOS = const DarwinInitializationSettings(
        defaultPresentAlert: true,
        defaultPresentSound: true,
        defaultPresentBadge: false);

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data[uConversationId] ==
          ChatScreenController.notificationUserId) {
        log('In Same Chat');
        return;
      }
      showNotification(message);
    });

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    getNotificationToken(
      (token) {},
    );
  }

  void showNotification(RemoteMessage message) {
    flutterLocalNotificationsPlugin.show(
      1,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
          iOS: const DarwinNotificationDetails(
              presentSound: true, presentAlert: true, presentBadge: false),
          android: AndroidNotificationDetails(channel.id, channel.name)),
    );
  }

  void getNotificationToken(Function(String token) completion) {
    FirebaseMessaging.instance.getToken().then((value) {
      log('Token: $value');
      completion(value ?? 'No Token');
    }).catchError((e) {
      log('Token: $e');
    });
  }

  void unsubscribeToTopic() async {
    log('Topic UnSubscribe');
    await firebaseMessaging.unsubscribeFromTopic(
        '${ConstRes.subscribeTopic}_${Platform.isIOS ? 'ios' : 'android'}');
  }

  void subscribeToTopic(UserData? user) async {
    if (user == null || user.isNotification == 1) {
      log('Topic Subscribe');
      await firebaseMessaging
          .subscribeToTopic(
              '${ConstRes.subscribeTopic}_${Platform.isIOS ? 'ios' : 'android'}')
          .onError((error, stackTrace) {
        log(error.toString());
      });
    }
  }

  void setupListener() async {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        log("Notification Receive Success :: ${message.notification?.body}");
        Map<String, dynamic> body = message.data;
        String? conversationId = body[uConversationId];
        if (conversationId == ChatScreenController.notificationUserId) {
          log("In same chat");
          return;
        }
        showNotification(message);
      },
    );
  }
}
