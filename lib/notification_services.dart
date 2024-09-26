// import 'dart:io';
// import 'dart:math';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationServices {
//   //creating instance
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   void reequestingNotificationPermissions() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       //sets notifications can be displayed to user on device
//       alert: true,
//       announcement: true,
//       //to show indicators on apps icons like in whatsapp 1,2,3 messages in pending to view
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       //select after first notification what to may be enable notification or disable it
//       provisional: true,
//       sound: true,
//     );
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print("user granted permissions");
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print("provisional permissions granted");
//     } else {
//       print("permissions denied");
//     }
//   }

//   static AndroidNotificationChannel highImportanceChannel =
//       AndroidNotificationChannel(
//           "high_importance_channel", "High Importance Notification",
//           description: "This channel is for important notifications",
//           importance: Importance.high,
//           );
//   void initLocalNotification(
//       BuildContext context, RemoteMessage message) async {
//     var andriodInnitialization =
//         AndroidInitializationSettings("@mipmap/ic_launcher");
//     //for ios
//     // var iosInnitialization = DarwinInitializationSettings();
//     var innitializationSettings = InitializationSettings(
//       android: andriodInnitialization,
//       //iOS: iosInnitialization,
//     );
//     await flutterLocalNotificationsPlugin.initialize(
//       innitializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {},
//     );
//     // Create the high-importance notification channel
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(highImportanceChannel);
//   }

//   void fireBaseInit(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((message) {
//       if (kDebugMode) {
//         print(message.notification!.title.toString());
//         print(message.notification!.body.toString());
//       }
//       if (Platform.isAndroid) {
//         initLocalNotification(context, message);
//         showNotifications(message);
//       }
//     });
    
//   }

//   Future<void> showNotifications(RemoteMessage message) async {
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//       Random.secure().nextInt(10000).toString(),
//       "High importance Notification",
//       importance: Importance.high,
//     );

//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//             channel.id.toString(), channel.name.toString(),
//             channelDescription: "Your Channel Description",
//             importance: Importance.high,
//             priority: Priority.high,
//             ticker: "ticker",
//             icon: "@mipmap/ic_launcher");
//     // DarwinNotificationDetails darwinNotificationDetails =
//     //     DarwinNotificationDetails(
//     //   presentAlert: true,
//     //   presentBadge: true,
//     //   presentBanner: true,
//     // );
//     NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//       // iOS: darwinNotificationDetails
//     );
//     Future.delayed(Duration.zero, () {
//       flutterLocalNotificationsPlugin.show(
//           1,
//           message.notification!.title.toString(),
//           message.notification!.body.toString(),
//           notificationDetails);
//     });
//   }

// //A device token is a unique identifier assigned to a specific device by Firebase Cloud Messaging (FCM).
// //It allows Firebase to target notifications to specific devices. When you send a push notification through
// //Firebase, this token ensures that the notification reaches the correct mobile device.
//   Future<String> getDeviceToken() async {
//     String? token = await messaging.getToken();
//     return token!;
//   }

//   void isTokenRefresh() {
//     messaging.onTokenRefresh.listen(
//       (event) {
//         event.toString();
//         print("refresh");
//       },
//     );
//   }
// }
