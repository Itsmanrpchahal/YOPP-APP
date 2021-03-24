import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:yopp/modules/bottom_navigation/activity/activity_screen.dart';
import 'package:yopp/modules/bottom_navigation/settings/notifications/bloc/notification_service.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final InitializationSettings initializationSettings = InitializationSettings(
  android: AndroidInitializationSettings("@mipmap/launcher_icon"),
  iOS: IOSInitializationSettings(),
  macOS: MacOSInitializationSettings(),
);

class PushNotificationService {
  BuildContext context;

  Future<void> initialise(BuildContext ctx) async {
    context = ctx;

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("Got initial message");
      _serialiseAndNavigate(initialMessage.data);
    }

    if (Platform.isIOS) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: true,
        sound: true,
      );

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
      // print('User granted permission: ${settings.authorizationStatus}');
    }

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');

        Navigator.pushNamedAndRemoveUntil(
            context, ActivityScreen.routeName, (route) => route.isFirst);
      }
    });

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    final token = await FirebaseMessaging.instance.getToken();
    print("Token: " + token ?? "NA TOKEN");
    FirebaseNotificationService().setNotificationToken(token);

    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      print("fcm_token: " + token);
      FirebaseNotificationService().setNotificationToken(token);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (notification != null) {
        print(
            'Message also contained a notification: ${notification.toString()}');
      }

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        try {
          print("Showing android notification");
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  icon: '@mipmap/launcher_icon',
                  // other properties...
                ),
              ),
              payload: "local");
        } catch (e) {
          print(e.toString());
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("Got a message whilst in the onMessageOpenedApp:");
      print('Message data: ${event.data}');
      if (event.notification != null) {
        print('Message also contained a notification: ${event.notification}');
      }
      _serialiseAndNavigate(event.data);
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  void _serialiseAndNavigate(Map<String, dynamic> messageData) {
    print("_serialiseAndNavigate");

    var screen = messageData['screen'];

    if (screen != null) {
      if (screen == 'activity') {
        print("GO to activity");
        Navigator.pushNamedAndRemoveUntil(
            context, ActivityScreen.routeName, (route) => route.isFirst);
      }
    } else {
      print("No view");
    }
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  return;
}

extension NavigatorStateExtension on NavigatorState {
  void pushNamedIfNotCurrent(String routeName, {Object arguments}) {
    if (!isCurrent(routeName)) {
      pushNamed(routeName, arguments: arguments);
    }
  }

  bool isCurrent(String routeName) {
    bool isCurrent = false;
    popUntil((route) {
      if (route.settings.name == routeName) {
        isCurrent = true;
      }
      return true;
    });
    return isCurrent;
  }
}
