import 'package:lumen_app_registro/ui/res/colors.dart';
import 'package:lumen_app_registro/ui/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

import '../login/login_screen.dart';

class LastScreen extends StatelessWidget {
  const LastScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro finalizado"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return LoginScreen();
              }),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
                height: size.height * .4,
                child: Center(child: AppLogo(context))),
            //TextoFin(context),
            Center(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Tu preregistro se realizó con éxito",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Positioned(
              bottom: 120,
              left: size.width * .2,
              right: size.width * .2,
              child: Center(
                  child: MaterialButton(
                minWidth: 200.0,
                height: 35,
                color: AppColors.primary,
                child: new Text('Salir',
                    style: new TextStyle(fontSize: 16.0, color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return LoginScreen();
                    }),
                  );
                  //Navigator.popUntil(context, ModalRoute.withName('login'));
                },
              )),
            )
          ],
        ),
      ),
    );
  }

  Widget AppLogo(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          height: size.height * .3,
          child: Image.asset('assets/img/logo-3.png'),
        )
      ],
    );
  }

  Widget TextoFin(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          height: size.height * .4,
          child: Image.asset('assets/img/logo.png'),
        )
      ],
    );
  }
}
