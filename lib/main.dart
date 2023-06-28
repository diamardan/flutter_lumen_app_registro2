import 'package:lumen_app_registro/app.dart';
import 'package:lumen_app_registro/fcm/fcm_service.dart';
import 'package:lumen_app_registro/geo_access/GeoAccessService.dart';
import 'package:lumen_app_registro/src/models/notification_model.dart'
    as nm_app;
import 'package:lumen_app_registro/src/data/MessagingService.dart';
import 'package:lumen_app_registro/ui/res/local_motifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification.body}');

  RemoteNotification notification = message.notification;

  AndroidNotification android = message.notification?.android;

  if (notification != null && android != null) {
    await Firebase.initializeApp();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("registration_id");

    nm_app.Notification _notification =
        nm_app.Notification.fromRemoteMessage(message);
    //MessagingService().addNotification(userId, _notification);
    /* LocalNotificationsService().showNotification(
        notification.hashCode, notification.title, notification.body); */
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationsService().init();
  await GeoAccessService.StartListening();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  FCMService.setForegroundOptions();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  Future.delayed(const Duration(seconds: 3), () {
    print("10 segundos");
    initializeDateFormatting().then((_) => runApp(MyApp()));
  });
}
