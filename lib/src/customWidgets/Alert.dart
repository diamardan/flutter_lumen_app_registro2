import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lumen_app_registro/ui/screens/pago/payment_wrapper.dart';
import 'package:lumen_app_registro/ui/screens/preregistro/create_form.dart';

showAlertDialog(BuildContext context, String title, String message,
    [String kind, bool redirect = false]) {
  // Create button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );
  String lottiePath = "";
  switch (kind) {
    case "error":
      lottiePath = 'assets/lotties/error_animation.json';
      break;
    default:
      lottiePath = 'assets/lotties/warning_animation.json';
  }
  Widget goToPayButton() {
    return TextButton(
        child: Text("Pagar"),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentPage(),
              )); // .of(context).pop();
        });
  }

  Widget alertLottie() {
    return Lottie.asset(lottiePath, repeat: true, height: 130.0);
  }

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        alertLottie(),
        Text(message),
      ],
    ),
    actions: [
      okButton,
      //redirect != false ? goToPayButton() : null
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertPago(BuildContext context, String title, String message) {
  // Create button
  Widget okButton = ElevatedButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PreregForm()));
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showCompletedDownload(BuildContext context, title, message) {
  Widget okButton = ElevatedButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
