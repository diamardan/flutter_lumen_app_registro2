import 'package:lumen_app_registro/ui/res/colors.dart';
import 'package:lumen_app_registro/ui/screens/access/register_access/get_face.dart';
import 'package:lumen_app_registro/ui/screens/access/register_access/get_signature.dart';
import 'package:lumen_app_registro/src/utils/routes_arguments.dart';
import "package:flutter/material.dart";

class MenuButton2 extends StatelessWidget {
  final String route;
  final IconData icon;
  final String title;
  final incoming;
  MenuButton2({this.title, this.icon, this.route, this.incoming = false});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        //  margin: EdgeInsets.symmetric(vertical: 5),
        child: TextButton(
            onPressed: () {
              print(incoming);

              Navigator.pushNamed(context, route);
              /* if (!incoming)
                Navigator.push(context, route);
              else
                Navigator.pushNamed(context, 'incoming',
                    arguments: IncomingScreenArguments(title));*/
            },
            style: OutlinedButton.styleFrom(
                elevation: 0.3,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            //  onSurface: Colors..withOpacity(0.0)),
            child: Row(children: [
              Icon(icon, // Icons.app_registration_outlined,
                  size: 40,
                  color: AppColors.primary),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 3,
                child: Text(title,
                    style: TextStyle(
                        //fontSize: 14,
                        //fontWeight: FontWeight.w500,
                        color: Colors.black87)),
              ),
              Expanded(
                  flex: 1,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_ios_outlined,
                          color: Colors.black87)))
            ])));
  }
}
