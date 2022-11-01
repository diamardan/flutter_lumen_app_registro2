import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:lumen_app_registro/src/models/notification_model.dart' as n;
import 'package:lumen_app_registro/src/models/user_model.dart';
import 'package:lumen_app_registro/src/provider/user_provider.dart';
import 'package:lumen_app_registro/src/data/RegistrationService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

final school = AppConstants.fsCollectionName;

class AccessList extends StatefulWidget {
  @override
  _AccessListState createState() => _AccessListState();
}

class _AccessListState extends State<AccessList> {
  UserProvider userProvider;
  Registration user;

  final RegistrationService registrationService = RegistrationService();
  String downloadMessageId = "";
  double fontSize = 14;
  String selectedOrigin = "message";

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    user = userProvider.getRegistration;
    super.initState();
  }

  showDownload(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PaginateFirestore(
      // Use SliverAppBar in header to make it sticky
      //footer: SliverToBoxAdapter(child: Text('FOOTER')),

      itemBuilderType: PaginateBuilderType.listView, //Change types accordingly
      itemBuilder: (context, documentSnapshot, index) {
        final data = documentSnapshot[index].data() as Map;
        n.Notification notification = n.Notification.fromJson(data);
        return _notification(notification);
      },
      query: FirebaseFirestore.instance
          .collection('schools')
          .doc(school)
          .collection("registros")
          .doc(user.id)
          .collection("notifications")
          .where("origin", isEqualTo: "access")
          .orderBy("sent_date", descending: true),
      isLive: true,
    );
  }

  _notification(n.Notification notification) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _header(notification),
                SizedBox(
                  height: 10,
                ),
                //_body(notification)
              ],
            ),
          )
        ]);
  }

  _header(n.Notification notification) {
    var dateTime =
        DateFormat("dd-MM-y HH:mm").format(notification.receivedDate);

    return Row(children: [
      Expanded(
          child: Container(
              margin: EdgeInsets.only(left: 10, top: 10, right: 10),
              decoration: BoxDecoration(
                // color: Colors.orange.shade50,
                // border: Border.all(width: 0.5, color: Color(0XFFABABAB)),
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                      child: Icon(
                        Icons.account_box_outlined,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.green.withOpacity(0.1)),
                  title: notification.title == null
                      ? Text('No disponible')
                      : Text(notification.title),
                  subtitle: Text(
                    dateTime,
                    style: TextStyle(fontSize: 12),
                  )))),
    ]);
  }

  _body(n.Notification notification) {
    var message = notification.message;
    message = message.length > 100 ? message.substring(0, 99) + "..." : message;
    return Container(
      decoration: BoxDecoration(
        color: Color(0XFFE0E0E0).withOpacity(0.05),
        border: Border.all(
          width: 1,
          color: Colors.green.withOpacity(0.1),
        ),
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      width: double.infinity,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: GestureDetector(
          onTap: () {
            showMessage(context, notification);
          },
          child: Text(message)),
    );
  }

  Future<void> showMessage(BuildContext context, n.Notification notification) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              content: Container(
                  // height: 500,
                  child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.clear),
                      onPressed: () => {Navigator.of(context).pop()},
                    ),
                  ),
                  Expanded(
                      child: message(notification.title, notification.message)),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  fontSize -= 2;
                                });
                              },
                              icon: Icon(
                                Icons.zoom_out,
                                size: 40,
                              )),
                          SizedBox(width: 10),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  fontSize += 2;
                                });
                              },
                              icon: Icon(Icons.zoom_in, size: 40))
                        ],
                      ))
                ],
              )));
        });
      },
    );
  }

  message(String title, String body) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize),
        ),
        SizedBox(
          height: 12,
        ),
        Text(
          body,
          style: TextStyle(fontSize: fontSize),
        )
      ],
    ));
  }
}
