import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lumen_app_registro/src/models/user_model.dart';
import 'package:lumen_app_registro/src/provider/user_provider.dart';
import 'package:lumen_app_registro/src/utils/imageUtil.dart';
import 'package:lumen_app_registro/src/utils/widget_to_image.dart';
import 'package:lumen_app_registro/ui/res/colors.dart';
import 'package:lumen_app_registro/ui/screens/credential/render_crendetial_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';

class LumenCredentialScreen extends StatefulWidget {
  LumenCredentialScreen({Key key}) : super(key: key);

  @override
  State<LumenCredentialScreen> createState() => _LumenCredentialScreenState();
}

const timeout = const Duration(seconds: 5);

class _LumenCredentialScreenState extends State<LumenCredentialScreen> {
  GlobalKey key1;
  GlobalKey key2;
  Uint8List bytes1;
  Uint8List bytes2;
  bool visibleButton;
  Registration register;
  String savePDFFolderName;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getStudentData();
  }

  _getStudentData() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    register = userProvider.getRegistration;
  }

  startTimeout() {
    return new Timer(timeout, handleTimeout);
  }

  void handleTimeout() {
    if (mounted)
      setState(() {
        visibleButton = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Credencial inteligente"),
        centerTitle: true,
      ),
      floatingActionButton: Visibility(
        visible: visibleButton == true ? true : false,
        child: FloatingActionButton.extended(
            backgroundColor: AppColors.morenaColor,
            //backgroundColor: canDownload == true ? Colors.blue : Colors.grey,
            label: Text("Descargar"),
            icon: Icon(Icons.download),
            /* child: 
                Icon(Icons.download),
            ), */
            onPressed: () async {
              _showSnackbar("Su descarga comenzará en breve");
              final bytes1 = await ImageUtils.capture(key1);
              final bytes2 = await ImageUtils.capture(key2);

              setState(() {
                this.bytes1 = bytes1;
                this.bytes2 = bytes2;
              });
              makePdf();
            }),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                _anversoCredencial(),
                _reversoCredencial(),
                Container(
                  child: Text("Credencial de lumen"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _anversoCredencial() {
    String clave1 = "";
    String clave2 = "-";
    switch (register.career) {
      case "SECUNDARIA":
        clave1 = "ES-843";
        clave2 = "C.C.T.09PES0843C";
        break;
      case "PREPARATORIA":
        clave1 = "EMS-3/434";
        break;
      case "LICENCIATURA EN MUSICA":
        clave1 = "RVOE:20122995";
        break;
    }
    return WidgetToImage(builder: (key) {
      this.key1 = key;
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        elevation: 10,
        child: Container(
          height: 215,
          width: 350,
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            image: DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                image: AssetImage('assets/img/credencial/anverso.png')),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                /* decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber, width: 2)), */
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 95,
                      ),
                      FittedBox(
                          child: Text(
                        '${register.surnames} ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                      FittedBox(
                          child: Text(
                        '${register.name} ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                      Text(
                        'ALUMNO(A)',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.green, width: 1)),
                            width: 80,
                            height: 40,
                          ),
                          Container(
                            height: 45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                FittedBox(
                                    child: Text(
                                  '${register.career}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )),
                                FittedBox(
                                  child: Text(
                                    clave1,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                FittedBox(
                                  child: Text(
                                    clave2,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 200,
                        /* decoration: BoxDecoration(
                            border: Border.all(color: Colors.amber, width: 2)), */
                      ),
                    ]),
              ),
              Container(
                width: 110,
                /* decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber, width: 2)), */
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: _networkImageWidget(
                          114, 98, register.fotoUsuarioDrive),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Matrícula: ',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        FittedBox(
                            child: Text(
                          '${register.registrationCode}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'IDBIO: ',
                          style: TextStyle(
                              fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                        FittedBox(
                            child: Text(
                          '${register.idbio}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 7,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _reversoCredencial() {
    String tempMatric = register.registrationCode.toString();
    String matricula = tempMatric != 'null' ? tempMatric : '';

    return WidgetToImage(builder: (key) {
      this.key2 = key;
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        elevation: 10,
        child: Container(
          height: 215,
          width: 350,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            image: DecorationImage(
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
                image: AssetImage('assets/img/credencial/reverso.png')),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 55,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                      width: 160,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.transparent, width: 1)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 66,
                          ),
                          Text(
                            '    ${register.career}',
                            style: TextStyle(
                                fontSize: 5, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.transparent, width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          _networkImageWidget(80, 84, register.qrDrive),
                          SizedBox(
                            height: 10,
                          ),
                          matricula != null && matricula != ''
                              ? Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.transparent, width: 1)),
                                  child: BarcodeWidget(
                                    barcode: Barcode.code128(),
                                    data: '${register.curp}',
                                    width: 115,
                                    height: 32,
                                    drawText: true,
                                    style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold),
                                  ))
                              : Container()
                        ],
                      ),
                    ),
                  ]),
            ],
          ),
        ),
      );
    });
  }

  void _showSnackbar(String content) {
    final snackBar = SnackBar(content: (Text(content)));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _networkImageWidget(double height, double width, String image,
      [bool transparency, bool margin, double marginTop]) {
    if (register.fotoUsuarioDrive == null || image == "") {
      image = "1TvA4s1r-c2NpsPCRdHozdk8dk0xQ_riY";
    }
    return Container(
        height: height,
        width: width,
        margin: margin == true ? EdgeInsets.fromLTRB(0, marginTop, 0, 0) : null,
        child: Image.network(
          'https://drive.google.com/uc?export=view&id=${image}',
          alignment: Alignment.center,
          fit: BoxFit.fill,
          color: transparency == true
              ? const Color.fromRGBO(255, 255, 255, 0.5)
              : null,
          colorBlendMode: transparency == true ? BlendMode.modulate : null,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) {
              startTimeout();
              return child;
            }

            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                  Text("Descargando imagen ")
                ],
              ),
            );
          },
        ));
  }

  Future<void> makePdf() async {
    final pdf = pw.Document();

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: <pw.Widget>[
              pw.Image(
                pw.MemoryImage(
                  bytes1,
                ),
                height: 300,
                //fit: pw.BoxFit.fitHeight
              ),
              pw.SizedBox(width: 10),
              pw.Image(
                pw.MemoryImage(
                  bytes2,
                ),
                height: 300,
                //fit: pw.BoxFit.fitHeight
              ),
              // ImageImage(bytes1),
              //pw.Image(pw.MemoryImage(bytes1)),
            ]),
      ),
    );

// the downloads folder path
    //Directory output = await getDownloadsDirectory();
    // String tempPath = '/storage/emulated/0/Download';
    String tempPath = await getPublicExternalStorageDirectoryPath();
    String apellidos =
        register.surnames != null ? register.surnames : "SIN APELLIDOS";
    String nombre = register.name != null ? register.name : "SIN NOMBRE";
    //output.path;
    var pdfName = apellidos + " " + nombre + ".pdf";
    var filePath = tempPath + '/${pdfName.replaceAll(" ", "_")}';
    final file = File(filePath);
    //
    /* final output = await getExternalStorageDirectory();
    final path = "${output.path}/credencial.pdf";
    final file = File(path); */
    print(filePath);
    /* final file = File('example.pdf');*/
    await file.writeAsBytes(await pdf.save());
    print("hola");
    _showSnackbar("El PDF está en su carpeta de Descargas");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RenderCredentialScreen(
                  pdfPath: filePath,
                  pdfName: pdfName,
                )));
    //launch(filePath);
  }

  Future<String> getPublicExternalStorageDirectoryPath() async {
    Directory directory;
    if (Platform.isIOS) {
      // Platform is imported from 'dart:io' package
      directory = await getApplicationDocumentsDirectory();
      savePDFFolderName = 'Documentos';
    } else if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
      savePDFFolderName = 'Descargas';
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
        savePDFFolderName = directory.path;
      }

      //directory = await getExternalStorageDirectory();
    }
    return directory.path;
  }
}
