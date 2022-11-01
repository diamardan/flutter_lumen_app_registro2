import 'package:lumen_app_registro/src/provider/user_provider.dart';
import 'package:lumen_app_registro/ui/screens/home/layout_screen.dart';
import 'package:lumen_app_registro/ui/screens/login/login_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final firebaseUser = Provider.of<User>(context);

    if (firebaseUser != null) {
      if (!userProvider.isLoggingIn) userProvider.initUSer();
      return LayoutScreen();
    } else {
      return LoginNavigator();
    }
  }
}
