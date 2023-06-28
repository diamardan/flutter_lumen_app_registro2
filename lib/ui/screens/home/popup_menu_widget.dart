import 'dart:io';

import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:lumen_app_registro/src/controllers/SignIn/SignInController.dart';
import 'package:lumen_app_registro/src/models/user_model.dart';
import 'package:lumen_app_registro/ui/res/notify_ui.dart';
import 'package:lumen_app_registro/ui/widgets/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lumen_app_registro/src/utils/auth_sign_psw.dart';

import '../../../src/data/AuthenticationService.dart';

popupMenu() {
  return PopupMenuButton(
    //color: Colors.white,

    icon: Icon(
      Icons.more_vert_rounded,
      color: Colors.white,
      size: 30,
    ),
    itemBuilder: (BuildContext context2) => [
      //  _settingsItem(context2),
      // _profileItem(context2),
      _myDevicesItem(context2),
      _changePassword(context2),
      //  _whatsapp(context2),
      _logoutItem(context2),
    ],
  );
}

PopupMenuItem _settingsItem(BuildContext ctx) {
  return PopupMenuItem(
    onTap: () {
      Future.delayed(
          Duration(seconds: 0), () => Navigator.pushNamed(ctx, "settings"));
    },
    child: Row(
      children: [
        Icon(
          Icons.settings,
          color: Colors.black,
        ),
        Text("  Configuración"),
      ],
    ),
  );
}

PopupMenuItem _changePassword(BuildContext ctx) {
  Registration user;
  return /* user.qrDrive != "email"
      ? Container()
      :  */
      PopupMenuItem(
          /* onTap: () {
            Future.delayed(Duration(seconds: 0),
                () => Navigator.pushNamed(ctx, "change-password"));
          }, */
          child: Row(children: [
    Icon(
      Icons.phone_android_rounded,
      color: Colors.black,
    ),
    TextButton(
        onPressed: () {
          //AuthSignPassword.changePassword(ctx);
        },
        child: Text(
          "Cambiar contraseña",
        ))
  ]));
}

PopupMenuItem _profileItem(BuildContext ctx) {
  return PopupMenuItem(
    onTap: () {
      Future.delayed(
          Duration(seconds: 0), () => Navigator.pushNamed(ctx, "profile"));
    },
    child: Row(
      children: [
        Icon(
          Icons.account_box_rounded,
          color: Colors.black,
        ),
        Text("  Perfil"),
      ],
    ),
  );
}

PopupMenuItem _myDevicesItem(BuildContext ctx) {
  return PopupMenuItem(
    onTap: () {
      Future.delayed(
          Duration(seconds: 0), () => Navigator.pushNamed(ctx, "my-devices"));
    },
    child: Row(
      children: [
        Icon(
          Icons.phone_android_rounded,
          color: Colors.black,
        ),
        Text("  Mis dispositivos"),
      ],
    ),
  );
}

PopupMenuItem _logoutItem(BuildContext ctx) {
  return PopupMenuItem(
    onTap: () {
      Future.delayed(Duration(seconds: 0), () async {
        bool res = await showLogoutDialog(ctx, "main");
        if (res) {
          await SignInController().cleanAuthenticationData(ctx);
          AuthenticationService().signOut();
        }
      });
    },
    child: Row(
      children: [
        Icon(
          Icons.logout_rounded,
          color: Colors.black,
        ),
        Text("  Salir"),
      ],
    ),
  );
}

PopupMenuItem _whatsapp(BuildContext ctx) {
  return PopupMenuItem(
    onTap: () {
      enviarWhatsapp(ctx);
    },
    child: Row(
      children: [
        Icon(
          Icons.help,
          color: Colors.black,
        ),
        Text("  Ayuda Whatsapp"),
      ],
    ),
  );
}

enviarWhatsapp(BuildContext _context) async {
  var url =
      "whatsapp://send?phone=${AppConstants.whatsappNumber}&text=${AppConstants.whatsappText}, ";
  /* var url =
        "${AppConstants.whatsappNumber}?text=${AppConstants.whatsappText}"; */
  if (Platform.isIOS) {
    print('ios1');
    if (await canLaunch('whatsapp://')) {
      await launch(
          "whatsapp://wa.me/${AppConstants.whatsappNumber}?text=${AppConstants.whatsappText},",
          forceSafariVC: false);
    } else {
      print('android');

      await launch(url, forceSafariVC: true);
    }
  } else {
    await canLaunch(url)
        ? launch(url)
        : await NotifyUI.showBasic(_context, 'Aviso', 'WhatsApp no instalado');
  }
  /* await launch(
        "${AppConstants.whatsappNumber}?text=${AppConstants.whatsappText}"); */
}
