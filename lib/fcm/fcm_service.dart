import 'dart:async';
import 'package:lumen_app_registro/src/data/MessagingService.dart';
import 'package:lumen_app_registro/ui/res/local_motifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../src/provider/supscritions_provider.dart';
import 'package:lumen_app_registro/src/models/notification_model.dart' as app;

extension StreamSubscriptionState on StreamSubscription {
  void addToState(BuildContext context) {
    SubscriptionsProvider subscriptionProvider =
        Provider.of<SubscriptionsProvider>(context, listen: false);
    subscriptionProvider.addSubscription(this);
  }
}

class FCMService {
  final MessagingService _messagingService = MessagingService();

  final context;
  String userId;
  FCMService(this.userId, this.context);

  _getNotificationObject(RemoteMessage message) {
    return app.Notification(
        serverMessageId: message.messageId,
        title: message.notification.title,
        message: message.notification.body,
        receivedDate: DateTime.now(),
        sentDate: message.sentTime,
        senderName: message.data["sender"],
        messageId: message.data["messageId"],
        origin: message.data["origin"],
        haveAttachments:
            message.data["haveAttachments"] == "yes" ? true : false,
        inputMode: "foreground",
        read: false);
  }

  // shows local notification when app receives a fcm
  starOnMessagetListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        LocalNotificationsService().showNotification(
            notification.hashCode, notification.title, notification.body);
        app.Notification appNotification = _getNotificationObject(message);
        _messagingService.addNotification(userId, appNotification);
      }
    }).addToState(context);
  }

  // when user open app from notification
  startOnMessageOpenedAppListener() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Navigator.pushNamed(context, "notification");
    }).addToState(context);
  }

  static setForegroundOptions() async {
    await FirebaseMessaging.instance // for ios
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
