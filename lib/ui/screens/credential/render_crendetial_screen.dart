import 'package:lumen_app_registro/ui/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
/* 
class RenderCredentialScreen extends StatelessWidget {
  final String pdfPath;
  const RenderCredentialScreen({this.pdfPath, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PdfView(path: pdfPath);
  }
} */

class RenderCredentialScreen extends StatefulWidget {
  final String pdfPath;
  final String pdfName;

  RenderCredentialScreen({this.pdfPath, this.pdfName, Key key})
      : super(key: key);

  @override
  _RenderCredentialScreenState createState() => _RenderCredentialScreenState();
}

class _RenderCredentialScreenState extends State<RenderCredentialScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.morenaColor,
        title: Text(this.widget.pdfName),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              Share.shareFiles(['${this.widget.pdfPath}'],
                  text: "Ésta es mi credencial digital");
            },
          ),
        ],
      ),
      body: SfPdfViewer.file(
        File(this.widget.pdfPath),
        key: _pdfViewerKey,
      ),
    );
  }
}
