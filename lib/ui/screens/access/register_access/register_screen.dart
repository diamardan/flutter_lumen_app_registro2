/* import 'package:lumen_app_registro/ui/res/colors.dart';
import 'package:lumen_app_registro/ui/screens/access/register_access/get_face.dart';
import 'package:lumen_app_registro/ui/widgets/access_button.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RegisterAccess extends StatefulWidget {
  RegisterAccess({Key key}) : super(key: key);

  @override
  State<RegisterAccess> createState() => _RegisterAccessState();
}

class _RegisterAccessState extends State<RegisterAccess> {
  List<String> biometrics = [
    "Firma",
    "Reconocimiento facial",
    "Huella",
    "Reconocimiento de voz",
    "Huella dactilar"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold/*  */(appBar: _header(), body: _biometrics());
  }

  Widget _header() => AppBar(
        automaticallyImplyLeading: false,
        title: Column(children: [
          Text(
            "ENTRADA",
            style: GoogleFonts.bungee(letterSpacing: 2),
          ),
          SizedBox(height: 10),
          Icon(
            Icons.location_pin,
            color: Colors.green.withOpacity(0.8),
            size: 70,
          ),
          SizedBox(
            height: 15,
          ),
          _clock(),
        ]),
        centerTitle: true,
        toolbarHeight: 200,
      );

  Widget _clock() => StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1)),
        builder: (context, snapshot) {
          return Center(
            child: Text(
                DateFormat('hh:mm:ss').format(
                  DateTime.now(),
                ),
                style: GoogleFonts.graduate(fontSize: 24)),
          );
        },
      );

  Widget _biometrics() => Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AccessButton(
            title: "Firma",
            action: "signature",
            icon: Icons.app_registration_outlined,
          ),
          AccessButton(
            title: "Reconocimiento facial",
            action: "",
            icon: Icons.portrait_outlined,
          ),
          AccessButton(
              title: "Huella", action: "", icon: Icons.fingerprint_outlined),
          AccessButton(
              title: "Reconocimiento de voz", action: "", icon: Icons.mic)
        ],
      ));

  Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            content: GetFace(),
            actionsAlignment: MainAxisAlignment.center,
            actions: [ElevatedButton(onPressed: () {}, child: Text("Enviar "))],
          );
        });
      },
    );
  }
}
 */