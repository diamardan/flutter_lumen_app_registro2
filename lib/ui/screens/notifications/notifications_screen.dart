import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:lumen_app_registro/src/models/user_model.dart';
import 'package:lumen_app_registro/src/provider/user_provider.dart';
import 'package:lumen_app_registro/ui/screens/notifications/list_access_widget.dart';
//import 'package:lumen_app_registro/ui/screens/notifications/list_access_widget.dart';
import 'package:lumen_app_registro/ui/screens/notifications/list_messages_widget.dart';
import 'package:lumen_app_registro/src/data/RegistrationService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final school = AppConstants.fsCollectionName;

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // UserProvider userProvider;
  // Registration user;

  final RegistrationService registrationService = RegistrationService();
  // bool _downloadingAttachments = false;
  String downloadMessageId = "";
  double fontSize = 14;
  String selectedOrigin = "message";

  @override
  void initState() {
    // userProvider = Provider.of<UserProvider>(context, listen: false);
    //user = userProvider.getRegistration;
    super.initState();
  }

  setOrigin(String value) {
    setState(() {
      selectedOrigin = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Notificaciones'),
              centerTitle: true,
              bottom: TabBar(
                //labelColor: Colors.white,
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.message_outlined,
                    ),
                    text: 'Mensajes',
                  ),
                  Tab(
                      icon: Icon(
                        Icons.account_box_outlined,
                      ),
                      text: 'Accesos'),
                  Tab(
                      icon: Icon(
                        Icons.account_box_outlined,
                      ),
                      text: 'Asistencias'),
                ],
              ),
            ),
            body: TabBarView(children: [
              NMessagesList(),
              AccessList() /* Container() */,
              Container()
            ])));
  }

  /* Widget filters() {
    return Container(
        color: Colors.white,
        child: Row(
          //  mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedButton.icon(
                icon: Icon(Icons.message_outlined, color: Colors.black54),
                onPressed: () {
                  setOrigin("message");
                },
                style: selectedOrigin == "message"
                    ? OutlinedButton.styleFrom(
                        backgroundColor: Colors.orange.withOpacity(0.2))
                    : OutlinedButton.styleFrom(),
                label: Text(
                  "Mensajes",
                  style: TextStyle(color: Colors.black54),
                )),
            OutlinedButton.icon(
                icon: Icon(
                  Icons.account_box_outlined,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setOrigin("access");
                },
                style: selectedOrigin == "access"
                    ? OutlinedButton.styleFrom(
                        backgroundColor: Colors.green.withOpacity(0.2))
                    : OutlinedButton.styleFrom(),
                label:
                    Text("Accesos", style: TextStyle(color: Colors.black54))),
            /*   Container(
                color: AppColors.morenaLightColor.withOpacity(0.1),
                child: IconButton(
                    onPressed: () {
                      setOrigin("all");
                    },
                    icon: Icon(Icons.ac_unit)))*/
          ],
        ));
  }*/

}
