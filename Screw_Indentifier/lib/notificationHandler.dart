import 'dart:async';
import 'dart:io';
import 'package:best_flutter_ui_templates/receiveDetails.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class NotificationHandler {
  double length;
  double pitch;
  final changeNotifier = new StreamController.broadcast();

  FirebaseMessaging _firebaseMessaging;

  Future<String> setUpFirebase() async {
    String _token;

    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessaging_Listeners();

    _token = await _firebaseMessaging.getToken();
      print("1: " + _token);

    return _token;
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) => recieved(message),
      onResume: (Map<String, dynamic> message) => recieved(message),
      onLaunch: (Map<String, dynamic> message) => recieved(message),
    );
  }

  Future recieved(_message) async {
    try {
      List body = _message['notification']['body'].split(',');
      length = double.parse(body[0]);
      pitch = double.parse(body[1]);
      changeNotifier.sink.add(null);
      changeNotifier.close();
    } catch (e) {
      print(e);
    }
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}