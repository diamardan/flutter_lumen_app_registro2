import 'package:lumen_app_registro/src/models/user_model.dart';
import 'package:lumen_app_registro/src/provider/Device.dart';
import 'package:lumen_app_registro/src/provider/supscritions_provider.dart';
import 'package:lumen_app_registro/src/provider/user_provider.dart';
import 'package:lumen_app_registro/src/data/AuthenticationService.dart';
import 'package:lumen_app_registro/src/data/DeviceService.dart';
import 'package:lumen_app_registro/src/data/MessagingService.dart';
import 'package:lumen_app_registro/src/data/RegistrationService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInController {
  final RegistrationService registrationService = RegistrationService();
  final AuthenticationService authenticationService = AuthenticationService();
  final MessagingService messagingService = MessagingService();
  final DeviceService deviceService = DeviceService();
  Registration r;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> registerDeviceWithToken(Registration r) async {
    int devCount = await deviceService.getActivedDevices(r.id);

    if (devCount < r.maxDevicesAllowed) {
      Device device = await DeviceProvider.instance.device;
      String token = await messaging.getToken();
      DeviceProvider.instance.addToken(token);
      await deviceService.addDevice(r.id, device);
      return "device_registered_success";
    } else
      return "max_devices_registered";
  }

  Future<void> unregisterDeviceAndToken(String regId) async {
    Device device = await DeviceProvider.instance.device;
    await deviceService.removeDevice(regId, device.id);
  }

  void subscribeToTopics(Registration r) {
    messagingService.subscribeToTopics(r);
  }

  void unsubscribeFromTopics(Registration r) {
    messagingService.unsubscribeFromTopics(r);
  }

  Future<void> persistUserData(String regId, String access) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("registration_id", regId);
    await prefs.setString("auth_method", access);
  }

/*  void cleanUserProvider(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setRegistration(null);
    userProvider.setLogging(false);
  }
*/
  Future<void> cleanPersistence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  cleanAuthenticationData(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    SubscriptionsProvider subscriptionsProvider =
        Provider.of<SubscriptionsProvider>(context, listen: false);
    await subscriptionsProvider.cancelSubscriptions();

    Registration r = userProvider.getRegistration;
    await unregisterDeviceAndToken(r.id);
    unsubscribeFromTopics(r);
    await cleanPersistence();
    print("ENTRANDO-.........");
    userProvider.setRegistration(null);
    print("PASÓ..............");
    userProvider.setLogging(false);
  }
}
