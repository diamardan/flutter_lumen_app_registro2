import 'package:lumen_app_registro/ui/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class NotifyUI {
  static Future<void> showBasic(
      BuildContext context, String title, String message) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.blackTransparent,
          title: Text(title),
          titleTextStyle: TextStyle(color: AppColors.redError),
          content: new Text(message, style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static flushbar(BuildContext context, String message) {
    Flushbar(
      messageText:
          Text(message, style: TextStyle(fontSize: 13, color: Colors.white)),
      margin: EdgeInsets.fromLTRB(2, 0, 2, 40),
      mainButton: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'Entendido',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    ).show(context);
  }

  static flushbarAutoHide(BuildContext context, String message) {
    Flushbar(
      messageText:
          Text(message, style: TextStyle(fontSize: 13, color: Colors.white)),
      margin: EdgeInsets.fromLTRB(2, 0, 2, 40),
      duration: Duration(seconds: 3),
    ).show(context);
  }

  static Future<void> showError(
      BuildContext context, String title, String message) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          actionsPadding: EdgeInsets.zero,
          titleTextStyle: TextStyle(
              color: AppColors.morenaColor,
              fontSize: 16,
              fontWeight: FontWeight.w500),
          content: Container(
              //height: MediaQuery.of(context).size.width * .4,
              //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: 15,
            ),
            Icon(
              Icons.error_outline_rounded,
              size: 90,
              color: AppColors.secondary.withOpacity(0.7),
            ),
            SizedBox(
              height: 10,
            ),
            Text(title,
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10,
            ),
            Text(message, style: TextStyle(color: Colors.black)),
          ])),
          actions: [
            Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: AppColors.primary),
                  child: Text('Cerrar', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ))
          ],
        );
      },
    );
  }
}
