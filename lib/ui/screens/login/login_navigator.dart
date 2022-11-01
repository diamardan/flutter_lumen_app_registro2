import 'package:lumen_app_registro/ui/screens/login/login_screen.dart';
import 'package:lumen_app_registro/ui/screens/login/recovery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumen_app_registro/ui/screens/login/login_email_screen.dart';

class LoginNavigator extends StatefulWidget {
  @override
  _LoginNavigatorState createState() => _LoginNavigatorState();
}

class _LoginNavigatorState extends State<LoginNavigator> {
  GlobalKey<NavigatorState> _loginNavigatorKey = GlobalKey<NavigatorState>();

  Future<bool> _systemBackButtonPressed() async {
    if (_loginNavigatorKey.currentState.canPop()) {
      _loginNavigatorKey.currentState.pop(_loginNavigatorKey.currentContext);
    } else {
      await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _systemBackButtonPressed,
        child: Navigator(
          key: _loginNavigatorKey,
          onGenerateRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                settings: settings,
                builder: (BuildContext context) {
                  switch (settings.name) {
                    case '/emal':
                      return LoginEmailScreen();
                    case "recovery-password":
                      return RecoveryPasswordScreen();

                    default:
                      return LoginScreen();
                  }
                });
          },
        ));
  }
}
