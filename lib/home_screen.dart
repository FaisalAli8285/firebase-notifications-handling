import 'package:flutter/material.dart';
import 'package:notificationinfirebase/notifications_servuces.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationsServices notificationServices = NotificationsServices();
  @override
  void initState() {
    // TODO: implement initState
    notificationServices.reequestingNotificationPermissions();
    notificationServices.getDeviceToken().then((value) {
      print("Device Token");
      print(value);
    });
    notificationServices.isTokenRefresh();
    notificationServices.firebaseInit(context);
    notificationServices.setUpIneractMessage(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firbse Notifications"),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
