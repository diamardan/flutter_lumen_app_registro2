import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:lumen_app_registro/src/models/notification_model.dart' as n;
import 'package:lumen_app_registro/src/models/user_model.dart';
import 'package:lumen_app_registro/src/provider/user_provider.dart';
import 'package:lumen_app_registro/ui/screens/notifications/attachments_screen.dart';
import 'package:lumen_app_registro/src/data/RegistrationService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

import '../../res/colors.dart';

final school = AppConstants.fsCollectionName;

class NMessagesList extends StatefulWidget {
  final origin;

  NMessagesList({this.origin});
  @override
  _NMessagesListState createState() => _NMessagesListState();
}

class _NMessagesListState extends State<NMessagesList> {
  UserProvider userProvider;
  Registration user;

  final RegistrationService registrationService = RegistrationService();
  bool _downloadingAttachments = false;
  String downloadMessageId = "";
  double fontSize = 14;
  String selectedOrigin = "message";
  String origin;
  var query;
  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    user = userProvider.getRegistration;

    origin = widget.origin;
    print("initState Origin: $origin");
    query = getQuery();
    super.initState();
  }

  showDownload(dynamic value) {
    setState(() {
      _downloadingAttachments = value;
    });
  }

  getQuery() {
    var queryRef = FirebaseFirestore.instance
        .collection('schools')
        .doc(school)
        .collection("registros")
        .doc(user.id)
        .collection("notifications");
    if (origin != "all")
      return queryRef.where("origin", isEqualTo: selectedOrigin);
    else
      return queryRef;
  }

  @override
  Widget build(BuildContext context) {
    return PaginateFirestore(
      // Use SliverAppBar in header to make it sticky
      //footer: SliverToBoxAdapter(child: Text('FOOTER')),

      itemBuilderType: PaginateBuilderType.listView, //Change types accordingly
      itemBuilder: (context, documentSnapshots, index) {
        final data = documentSnapshots[index].data() as Map;
        n.Notification notification = n.Notification.fromJson(data);
        return _notificationBox(notification);
      },
      query: query.orderBy("sent_date", descending: true),
      isLive: true,
    );
  }

  _notificationBox(n.Notification notification) {
    return TextButton(
      onPressed: () {
        showMessage(context, notification);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(notification),
          _body(notification),
          Divider(
            thickness: 1.5,
            height: 5,
            //  color: Colors.red,
          ),
        ],
      ),
    );
  }

  _header(n.Notification notification) {
    var dateTime =
        DateFormat("dd-MM-y HH:mm").format(notification.receivedDate);

    return ListTile(
      //  dense: true,
      leading: CircleAvatar(
          child: Icon(Icons.message_outlined,
              size: 35, color: AppColors.morenaColor),
          backgroundColor: Colors.white),
      title: notification.title == null
          ? Text('No disponible')
          : Text(
              notification.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
      subtitle: Text(
        dateTime,
        style: TextStyle(fontSize: 12),
      ),
      trailing: notification.haveAttachments
          ? _attachment(notification.messageId)
          : Container(
              width: 10,
            ),
    );
  }

  _body(n.Notification notification) {
    var _message = notification.message;

    return Padding(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Text(
          _message,
          textAlign: TextAlign.left,
          maxLines: 4,
          style: TextStyle(color: Colors.black54),
        ));
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

  Widget _attachment(messageId) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.secondaryColor.withOpacity(0.1),
            //border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AttachmentsScreen(
                          messageId: messageId,
                        )));
          },
          icon: Icon(Icons.attach_file, size: 25, color: Colors.black54),
        ));
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
}
