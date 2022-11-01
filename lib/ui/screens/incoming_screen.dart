import 'package:lumen_app_registro/src/utils/routes_arguments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IncomingScreen extends StatelessWidget {
  static const routeName = 'incoming';
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as IncomingScreenArguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(args.title),
          centerTitle: true,
        ),
        body: Center(
            child: Card(
          child: Padding(
            child: Text(
              'Próximamente',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
            padding: EdgeInsets.all(20),
          ),
        )));
  }
}
