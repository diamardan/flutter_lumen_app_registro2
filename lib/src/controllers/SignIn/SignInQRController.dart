import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:lumen_app_registro/src/controllers/SignIn/SignInController.dart';
import 'package:lumen_app_registro/src/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_tools/qr_code_tools.dart';

class SignInQRController extends SignInController {
  Future<String> scanQR() async {
    var options = ScanOptions(
      restrictFormat: [BarcodeFormat.qr],
    );
    var futureString = await BarcodeScanner.scan(options: options);
    return futureString.rawContent;
  }

  Future<String> decodeImage(String imagePath) async {
    String qrString = await QrCodeToolsPlugin.decodeFrom(imagePath);
    return qrString;
  }

  // * * *  Sing in with code QR from Camera  * * *
  Future<Map<String, dynamic>> authenticate(String qr) async {
    r = await registrationService.checkQr(qr);
    if (r is Registration) {
      String res1 = await registerDeviceWithToken(r);
      if (res1 == "device_registered_success") {
        await persistUserData(r.id, "email");
        subscribeToTopics(r);
        await authenticationService.signInAnonymously();
        return {"code": "sign_in_success", "message": "login exitoso"};
      } else
        return {
          "code": "-",
          "message": "Verifique el número de dispositivos de tu licencia"
        };
      // return {"code": "-", "message": "No se identificó a este usuario."};
    } else
      return {"code": "user-not-found", "message": "Usuario no encontrado."};
  }

  void setStateAndPersistence(BuildContext context, response, String s) {}
}
