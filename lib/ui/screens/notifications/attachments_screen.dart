import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:lumen_app_registro/src/data/MessagingService.dart';
import 'package:lumen_app_registro/ui/widgets/download_attachments.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AttachmentsScreen extends StatefulWidget {
  const AttachmentsScreen({Key key, this.messageId}) : super(key: key);
  final messageId;
  @override
  _AttachmentsScreenState createState() => _AttachmentsScreenState();
}

class _AttachmentsScreenState extends State<AttachmentsScreen> {
  final messageService = MessagingService();
  Map<String, dynamic> message;
  List<dynamic> attachments = [];

  @override
  void initState() {
    fetchMessage();
    super.initState();
  }

  fetchMessage() async {
    String id = widget.messageId;
    id = id.substring(5);
    print(id);
    messageService.getMessage(id).then((_message) {
      print(_message);
      setState(() {
        message = _message;
        attachments = _message["attachments"];
      });
    });
  }

  _launchURL(String fileName) async {
    fileName = fileName.replaceAll(" ", "-");
    var url =
        '${AppConstants.backendPublicUrl}/uploads/${AppConstants.fsCollectionName}/attachments/heap/${widget.messageId}/$fileName';
    //"https://api.escuelas.infon.mx/public/uploads/cetis32/attachments/heap/${widget.messageId}/$fileName";
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _downloadZip() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            child: DownloadAttchments(
                parentContext: context, messageId: widget.messageId));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Archivos adjuntos'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87),
        //backgroundColor: Color(0XFFDDDDDD),
        bottomSheet: Container(
          height: 100,
          width: double.infinity,
          child: zipButton(),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: ListView.builder(
                itemCount: attachments.length,
                itemBuilder: (context, index) {
                  return Container(
                      width: 200,
                      height: 60,
                      margin: EdgeInsets.only(bottom: 20),
                      child: OutlinedButton.icon(
                          icon: Icon(Icons.download),
                          onPressed: () {
                            _launchURL(attachments[index]);
                          },
                          label: Text(
                            attachments[index],
                            textAlign: TextAlign.center,
                          )));
                })));
  }

  zipButton() {
    return OutlinedButton(
        onPressed: () {
          _downloadZip();
        },
        child: Text(
          "Descargar todo comprimido",
          textAlign: TextAlign.center,
        ),
        style: OutlinedButton.styleFrom(backgroundColor: Color(0XFFEEEEEE)));
  }
}
