import 'dart:ffi';

import 'package:lumen_app_registro/src/utils/routes_arguments.dart';
import 'package:lumen_app_registro/ui/res/colors.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class MenuButton extends StatelessWidget {
  final String route;
  final IconData iconData;
  final String title;
  final String subtitle;
  final incoming;
  MenuButton(
      {this.title,
      this.iconData,
      this.route,
      this.subtitle,
      this.incoming = false});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        child: ElevatedButton(
            onPressed: () {
              print(incoming);
              if (!incoming)
                Navigator.pushNamed(context, route);
              else
                Navigator.pushNamed(context, 'incoming',
                    arguments: IncomingScreenArguments(title));
            },
            style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(0.5),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                overlayColor: MaterialStateProperty.all<Color>(
                    Colors.lightGreen.withOpacity(0.5)),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)))),
            //  onSurface: Colors..withOpacity(0.0)),
            child: Row(children: [
              Icon(iconData,
                  size: 45,
                  color: /* Colors.orange.withOpacity(
                      0.7) */
                      AppColors.secondary),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    //  mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black.withOpacity(0.8).withBlue(20))

                          /*  style: GoogleFonts.bebasNeue(
                            color: Colors.black54, fontSize: 14),*/
                          ),
                      /* Text(subtitle,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color:
                                  Colors.black.withOpacity(0.3).withBlue(20))),*/
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_ios_outlined,
                          color: AppColors.secondary.withOpacity(0.7))))
            ])));
  }
}
