
import 'package:finalproject/screens/notificationscreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
class back_massage {
  //instance firebase message
  final _firebaseMessaging = FirebaseMessaging.instance;

  //inotialize notification

  Future<void> initNotifications() async {
    //take permission
    await _firebaseMessaging.requestPermission();
    //fetch the firebase massage token
    final fcmtoken = await _firebaseMessaging.getToken();
    //print token
    print('fcmToken:$fcmtoken');
    initPushNotifications();
  }

  void handelmessage(RemoteMessage? message) {
    if (message == null) return;

    _navigateToNotificationPage;
  }

  void _navigateToNotificationPage(BuildContext context) {
    // Navigate to notification page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          NotificationScreen(),
      ), // Replace NotificationPage with your actual notification page
    );
  }
  Future initPushNotifications() async{
    FirebaseMessaging.instance.getInitialMessage().then(handelmessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handelmessage);
  }
}