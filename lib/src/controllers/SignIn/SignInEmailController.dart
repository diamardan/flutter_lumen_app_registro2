import 'package:lumen_app_registro/src/controllers/SignIn/SignInController.dart';
import 'package:lumen_app_registro/src/models/user_model.dart';
import 'package:lumen_app_registro/src/data/RegistrationService.dart';
import 'package:flutter/cupertino.dart';

class SignInEmailController extends SignInController {
  Map<String, String> authErrorRes = {
    "user-not-found":
        "No tienes activado el acceso por este medio. Solicita la activación de tu cuenta.",
    "wrong-password": "Contraseña incorrecta."
  };

  Future<Map<String, dynamic>> authenticate(
      BuildContext context, String email, String password) async {
    r = await RegistrationService().checkEmail(email);
    if (r is Registration) {
      String res1 = await registerDeviceWithToken(r);
      if (res1 == "device_registered_success") {
        await persistUserData(r.id, "email");
        var res2 = await authenticationService.signInEmailAndPassword(
            email: email, password: password);
        String code = res2["code"];
        if (code == "sign_in_success") {
          subscribeToTopics(r);
          return {"code": code, "message": ""};
        } else {
          // clean
          await cleanPersistence();
          await unregisterDeviceAndToken(r.id);
          var message = authErrorRes[code];
          if (message is String)
            return {"code": code, "message": message};
          else
            return {"code": code, "message": "No se identificó al usuario."};
        }
      } else
        return {
          "code": "-",
          "message": "Verifique el número de dispositivos de tu licencia"
        };
    } else
      return {"code": "user-not-found", "message": "Usuario no encontrado."};
  }

  Future<Map<String, String>> recoveryPassword(String email) async {
    r = await RegistrationService().checkEmail(email);

    if (r == null) {
      return {"code": "user_not_found", "message": "Usuario no encontrado"};
    }

    var result = await authenticationService.signInEmailAndPassword(
        email: email, password: "xxxxxx");

    if (result['code'] == "wrong-password") //means user exists
    {
      await authenticationService.remindPassword(email, r.password);
      return {'code': "success"};
    } else {
      return {"code": "error", "message": "Cuenta no identificada."};
    }
  }

  void setStateAndPersistence(BuildContext context, response, String s) {}
}
