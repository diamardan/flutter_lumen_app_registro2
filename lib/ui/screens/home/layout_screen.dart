import 'dart:async';
import 'package:lumen_app_registro/fcm/fcm_service.dart';
import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:lumen_app_registro/src/controllers/SignIn/SignInController.dart';
import 'package:lumen_app_registro/src/models/user_model.dart';
import 'package:lumen_app_registro/src/provider/Device.dart';
import 'package:lumen_app_registro/src/provider/user_provider.dart';
import 'package:lumen_app_registro/ui/res/colors.dart';
import 'package:lumen_app_registro/ui/screens/home/home_view.dart';
import 'package:lumen_app_registro/ui/screens/home/news_view.dart';
import 'package:lumen_app_registro/ui/screens/notifications/notifications_screen.dart';
import 'package:lumen_app_registro/src/data/AuthenticationService.dart';
import 'package:lumen_app_registro/src/data/RegistrationService.dart';
import 'package:lumen_app_registro/ui/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class LayoutScreen extends StatefulWidget {
  @override
  _homeScreenState createState() => _homeScreenState();
}

// ignore: camel_case_types
class _homeScreenState extends State<LayoutScreen> {
  final _selectedItemColor = Colors.white60;
  final _unselectedItemColor = Colors.white54;
  final _selectedBgColor = AppColors.primary;
  final _unselectedBgColor = AppColors.lightPrimary;
  final RegistrationService registrationService = RegistrationService();
  FCMService fcmService;

  FirebaseMessaging messaging;

  Registration user;
  UserProvider userProvider;

  bool userLoaded = false;
  bool loading;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Inicio',
      style: optionStyle,
    ),
    Text(
      'Index 1: Notificaciones',
      style: optionStyle,
    ),
    Text(
      'Index 2: Noticias',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Color _getBgColor(int index) =>
      _selectedIndex == index ? _selectedBgColor : _unselectedBgColor;

  Color _getItemColor(int index) =>
      _selectedIndex == index ? _selectedItemColor : _unselectedItemColor;

  setLoading(value) {
    setState(() {
      loading = value;
    });
  }

  @override
  didChangeDependencies() {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    user = userProvider.getRegistration;
    //print(user.toString());
    print(user.toString());
    if (user != null && userLoaded == false) {
      fcmService = FCMService(user.id, context);
      fcmService.starOnMessagetListener();
      fcmService.startOnMessageOpenedAppListener();
      startDeviceLIstener();
      userLoaded = true;
    }

    super.didChangeDependencies();
  }

  void startDeviceLIstener() async {
    Device device = await DeviceProvider.instance.device;
    final school = AppConstants.fsCollectionName;

    FirebaseFirestore.instance
        .collection("schools")
        .doc(school)
        .collection("registros")
        .doc(user.id)
        .collection("devices")
        .doc(device.id)
        .snapshots()
        .listen((doc) {
      print(doc);
      if (!doc.exists) {
        print("no hay dispositivo");
        SignInController().cleanAuthenticationData(context);
        AuthenticationService().signOut();
      }
    }).addToState(context);
  }

  void _switchView(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _systemBackButtonPressed() async {
    if (_selectedIndex > 0) {
      setState(() {
        _selectedIndex--;
      });
      return false;
    } else
      return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _systemBackButtonPressed,
        child: CustomLoading(
            inAsyncCall: user == null,
            child: Scaffold(
                body: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    HomeView(),
                    user != null ? NotificationsScreen() : Container(),
                    NewsView()
                  ],
                ),
                bottomNavigationBar: _bottomNavBar()
                //bottomNavBar(),
                )));
  }

  _bottomNavBar() {
    double iconSize = 35;
    const primary = Color(0XFF621152);
    const primary2 = Color(0XFF520142);
    const primary3 = Color(0XFF420032);

    return Container(
      height: 60,
      padding: EdgeInsets.all(0),
      color: Colors.green,
      child: Row(children: [
        Expanded(child: _buildIcon(Icons.home, "Inicio", 0, primary)),
        Expanded(
            child: _buildIcon(
                Icons.notifications_rounded, "Notificaciones", 1, primary2)),
        Expanded(
            child: _buildIcon(Icons.newspaper_rounded, "Noticias", 2, primary3))
      ]),
    );
  }
  /*_bottomNavBar() {
    double iconSize = 35;
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
            icon: _buildIcon(Icons.notifications_rounded, "Notificaciones", 0),
            label: "hola"),
        BottomNavigationBarItem(
            backgroundColor: Colors.grey,
            icon: Icon(
              Icons.home_filled,
              size: iconSize,
            ),
            label: "Home"),
        BottomNavigationBarItem(
            icon: _buildIcon(Icons.notifications_rounded, "Notificaciones", 2),
            label: ""),
        /*Icon(
              Icons.notifications_rounded,
              size: iconSize,
            ),
            label: "Notificac  iones",*/
        BottomNavigationBarItem(
            icon: _buildIcon(Icons.newspaper_rounded, "Noticias", 2), label: ""
            /*Icon(
              Icons.newspaper_rounded,
              size: iconSize,
            ),*/
            ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppColors.morenaLightColor,
      unselectedItemColor: Colors.grey,
      iconSize: 30,
      onTap: _switchView,
    );
  }*/

  Widget _buildIcon(IconData iconData, String text, int index, Color bgColor) =>
      Container(
        //width: 200,
        height: double.infinity,

        //height: kBottomNavigationBarHeight,
        child: Material(
          color: bgColor,
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(iconData, color: _getItemColor(index)),
                Text(text,
                    style:
                        TextStyle(fontSize: 12, color: _getItemColor(index))),
              ],
            ),
            onTap: () => _onItemTapped(index),
          ),
        ),
      );
}
