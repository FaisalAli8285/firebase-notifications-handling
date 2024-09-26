import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notificationinfirebase/message_screen.dart';

class NotificationsServices {
//creating instance
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  //Provides cross-platform functionality for handle local notifications on the screen.
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void reequestingNotificationPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      //sets notifications can be displayed to user on device
      alert: true,
      announcement: true,
      //to show indicators on apps icons like in whatsapp 1,2,3 messages in pending to view
      badge: true,
      carPlay: true,
      criticalAlert: true,
      //select after first notification what to do may be enable notification or disable it
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permissions");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("provisional permissions granted");
    } else {
      print("permissions denied");
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen(
      (event) {
        event.toString();
        print("refresh");
      },
    );
  }

  //initialize the firebase
  void firebaseInit(BuildContext context) {
    // Listens for messages when the app is in the foreground.
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        //print title send by firbase notifications
        print(message.notification!.title.toString());
        //print body content send by firbase notifications
        print(message.notification!.body.toString());
        //data = payload use to send extra required data
        print(message.data.toString());
        print(message.data["type"].toString());
        print(message.data["id"].toString());
      }
      // If the platform is Android, initializes local notifications and displays the notification.
      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    //This sets up the settings for Android notifications."@mipmap/ic_launcher" refers to the app icon
    //used in notifications. This icon is usually placed in the mipmap folder of your Android project
    var androidInitializationSetting =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    //  Combines the Android notification settings into a variable initializationSetting for later use.
    var initializationSetting = InitializationSettings(
      android: androidInitializationSetting,
    );
//_flutterLocalNotificationsPlugin is the instnce of FlutterLocalNotificationsPlugin which manages local notifications
//.initialize(initializationSetting): This initializes the local notifications with the settings specified
    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (NotificationResponse payLoad) {
      //   This is a callback function that is triggered when the user interacts with the notification.
      //For now, it's empty ({}), but you can add behavior here if needed.
      handleMessage(context, message);
    });
  }

  //This function showNotification is responsible for actually displaying the notification on the screen.
  //It is marked as async because it performs asynchronous tasks.It takes a message parameter, which
  //contains the notification details (title, body, etc.).
  Future<void> showNotification(RemoteMessage message) async {
    //A channel is required on Android 8.0 (API level 26) or higher. It allows the system to categorize
    //notifications. Each notification sent must be assigned to a channel.
    AndroidNotificationChannel channel = AndroidNotificationChannel(
//This generates a random number between 0 and 100,000, which is used as the channel ID
//A channel ID is a unique identifier for a notification channel, required to ensure
        //notifications are handled properly on Android devices
        Random.secure().nextInt(100000).toString(),
        //This is the channel name. A channel name is a human-readable string that describes the purpose
        //of the channel, such as "high importance" in this case
        "high importance channel",
        //Sets the importance level of the notification channel to maximum. This ensures that
        //notifications in this channel will be shown with high priority and will make a sound
        importance: Importance.max);
    //This defines the details for the notification itself.
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), //The ID of the notification channel.
            channel.name.toString(), //The name of the notification channel.
            channelDescription: 'Your channel description',
            importance: Importance
                .high, //Ensures the notification is shown with high importance
            priority: Priority
                .high, //Ensures the notification appears at the top of the notification drawer
            ticker:
                "ticker" //A text to display briefly in the status bar when the notification arrives
            );
    // Combines all the Android notification details into a single NotificationDetails object,
    //which will be used to display the notification.
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    //Delays the execution of the code inside the block for 0 milliseconds (essentially executing it
    //immediately without blocking the app).
    Future.delayed(Duration.zero, () {
      //Displays the notification on the device with
      _flutterLocalNotificationsPlugin.show(
          0, //Notification ID is used to uniquely identify each notification shown on the device.
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails //The details for how the notification should be displayed.
          );
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msg') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MessageScreen(id: message.data['id'].toString())));
    }
  }

//setup for navigationg screen by tapping on notification when application is terminated or in background
  Future<void> setUpIneractMessage(BuildContext context) async {
    //when ap terminated
    RemoteMessage? innitialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (innitialMessage != null) {
      handleMessage(context, innitialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }
}
