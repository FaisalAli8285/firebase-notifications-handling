import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notificationinfirebase/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_flutterBackgroundNotifications);

  runApp(const MyApp());
}
//@pragma("vm:entry-point"): This annotation ensures that the Dart Virtual Machine knows that this 
//function is an entry point when handling background messages. It prevents the function from being 
//tree-shaken (removed during compilation), which is necessary for the background messaging system to 
//work properly.
@pragma("vm:entry-point")
Future<void> _flutterBackgroundNotifications(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
   print(message.notification!.body.toString());
    print(message.data.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
