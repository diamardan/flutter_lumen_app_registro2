import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lumen_app_registro/ui/res/notify_ui.dart';
import 'dart:io';

import '../res/colors.dart';

class WhatsappHelpBtn extends StatefulWidget {
  WhatsappHelpBtn({Key key, @required this.context, this.showLabel = true})
      : super(key: key);
  final BuildContext context;
  final bool showLabel;
  _WhatsappHelpBtnState createState() => _WhatsappHelpBtnState();
}

class _WhatsappHelpBtnState extends State<WhatsappHelpBtn> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.6,
      child: ElevatedButton(
        onPressed: () {
          enviarWhatsapp(context);
        },
        style: ElevatedButton.styleFrom(
            primary: AppColors.whatsappColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.whatsapp,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            /* Text(
              'Ayuda',
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
            ) */
          ],
        ),
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
          : await NotifyUI.showBasic(
              _context, 'Aviso', 'WhatsApp no instalado');
    }
    /* await launch(
        "${AppConstants.whatsappNumber}?text=${AppConstants.whatsappText}"); */
  }
}
