import 'dart:math';

import 'package:lumen_app_registro/src/models/user_model.dart';
import 'package:lumen_app_registro/src/data/AuthenticationService.dart';
import 'package:lumen_app_registro/src/data/RegistrationService.dart';
import 'package:lumen_app_registro/src/utils/enums.dart';

class AuthSign {
  static RegistrationService registrationService = RegistrationService();

  static AuthenticationService authenticationService = AuthenticationService();

// * * *  Sign up email and password  * * *
  static signUpWithEmailAndPassword(String email) async {
    Registration registration = await RegistrationService().checkEmail(email);

    if (registration == null) {
      return AuthResponseStatus.USER_NOT_FOUND;
    }

    var password = generatePassword();

    Map<String, String> result = await authenticationService
        .signUpEmailAndPassword(email: email, password: password);

    switch (result['code']) {
      case "sign_up_success":
        await authenticationService.sendPassword(email, password);
        await authenticationService.savePassword(registration.id, password);
        return AuthResponseStatus.SUCCESS;
      case "email-already-in-use":
        return AuthResponseStatus.EMAIL_ALREADY_EXISTS;
      default:
        return AuthResponseStatus.ANOTHER_ERROR;
    }
  }

  // * * *  Utilities  * * *

  static String generatePassword() {
    final length = 12;
    final letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
    final letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    final number = '01234567890123456789';
    final special = '@#%+&#%+&';

    String chars = "";
    chars += '$letterLowerCase$letterUpperCase';
    chars += '$number';
    chars += '$special';

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');
  }
}
