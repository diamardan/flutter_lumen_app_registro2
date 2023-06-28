import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:lumen_app_registro/src/models/user_model.dart';
import 'package:lumen_app_registro/src/provider/user_provider.dart';
import 'package:lumen_app_registro/ui/res/colors.dart';
import 'package:lumen_app_registro/ui/screens/credential/render_crendetial_screen.dart';
import 'package:lumen_app_registro/src/utils/imageUtil.dart';
import 'package:lumen_app_registro/src/utils/widget_to_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date format
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';

class DigitalCredentialScreen extends StatefulWidget {
  @override
  _DigitalCredentialScreenState createState() =>
      _DigitalCredentialScreenState();
}

const timeout = const Duration(seconds: 5);

class _DigitalCredentialScreenState extends State<DigitalCredentialScreen> {
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
          child: Center(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            SizedBox(
              height: 15,
            ),
            _anversoCredencial(),
            WidgetToImage(builder: (key) {
              this.key2 = key;
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10,
                child: Container(
                  height: 215,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        image: AssetImage(
                            'assets/img/credencial/reverso2022.png')),
                  ),
                  child: Column(
                    children: <Widget>[
                      _cintillaTurno(),
                      _midReverso(),
                      /*  _espacioQR(),
                      _firmaAlumno(),
                      _fotoReverso() */
                    ],
                  ),
                ),
              );
            }),
            /* buildImage(bytes1),
            buildImage(bytes2), */
          ]),
        ),
      )),
    );
  }

  Widget _midReverso() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    height: 25,
                    width: 25,
                    margin: EdgeInsets.fromLTRB(92, 15, 0, 0),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border.all(color: Colors.transparent, width: 1)),
                    child: Text(
                      '${register.grade}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 25,
                    width: 25,
                    margin: EdgeInsets.fromLTRB(92, 12, 0, 0),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border.all(color: Colors.transparent, width: 1)),
                    child: Text(
                      '${register.group}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, 20, 0, 0),
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlue, width: 1),
                ),
                child: _networkImageWidget(110, 110, register.qrDrive),
              ),
            ]),
        Container(
            height: 30,
            width: 125,
            margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
            child: _networkImageWidget(110, 110, register.firmaDrive)),
      ],
    );
  }

/*   Widget _anversoCredencial2() {
    return WidgetToImage(builder: (key) {
      this.key1 = key;
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        elevation: 10,
        child: Container(
          height: 490,
          width: 310,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            image: DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                image: AssetImage('assets/img/credencial/anverso.png')),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: 128),
              _cintillaFoto(),
              _cintillaBlanca(),
              _cintillaNombre(),
              _cintillaEspecialidad(),
              _cintillaNumeroControl(),
            ],
          ),
        ),
      );
    });
  }
 */
  Widget _anversoCredencial() {
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
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            image: DecorationImage(
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
                image: AssetImage('assets/img/credencial/anverso2022.png')),
          ),
          child: Row(
            children: [
              Column(
                children: <Widget>[
                  SizedBox(height: 35),
                  _espacioFoto(),
                  _espacioFooter(),
                  /* _cintillaFoto(),
                      _cintillaBlanca(),
                      _cintillaNombre(),
                      _cintillaEspecialidad(),
                      _cintillaNumeroControl(), */
                ],
              ),
              SizedBox(
                width: 7,
              ),
              RotatedBox(
                quarterTurns: 1,
                child: Text(
                  '${register.career}' ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'montserrat',
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _espacioFooter() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String tempMatric = register.registrationCode.toString();
    String matricula = tempMatric != 'null' ? tempMatric : '';
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
        padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
        width: screenWidth * .8,
        height: screenHeight * .07,
        /* decoration:
            BoxDecoration(border: Border.all(color: Colors.white, width: 3)), */
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
                  child: Text(
                    '$matricula' ?? '',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.amber,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                matricula != null && matricula != ''
                    ? Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        color: Colors.white,
                        child: BarcodeWidget(
                          barcode: Barcode.code128(),
                          data: '$matricula',
                          width: 130,
                          height: 20,
                          drawText: false,
                        ))
                    : Container()
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
              child: Text(
                '${register.idbio}' ?? '',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.amber,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _espacioFoto() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 2,
          width: 11,
        ),
        _networkImageWidget(124, 98, register.fotoUsuarioDrive),
        Container(
          height: 95,
          width: 180,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent, width: 2)),
          margin: EdgeInsets.fromLTRB(5, 19, 0, 0),
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FittedBox(
                child: Text(
                  '${register.name}' ?? "",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.amber,
                      fontWeight: FontWeight.normal),
                ),
              ),
              FittedBox(
                child: Text(
                  '${register.surnames}' ?? "",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.amber,
                      fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                height: 14,
              ),
              FittedBox(
                child: Text(
                  '${register.curp}' ?? "",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.amber,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _cintillaFoto() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 174,
          width: 81,
        ),
        //_networkImageWidget(174, 148, register.fotoUsuarioDrive),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              width: 80,
              child: Text(
                register.group ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "GRUPO",
              style: TextStyle(color: Colors.white),
            )
          ],
        )
      ],
    );
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
            } /* else {
              if (loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes ==
                      1.0 &&
                  image == this.register.fotoUsuarioDrive) {
                startTimeout();
              }
            } */

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

  Widget _cintillaBlanca() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 70,
          //color: Colors.red,
          child: Column(
            children: [
              Text(
                register.idbio.toString() != null
                    ? register.idbio.toString()
                    : "-",
                style: TextStyle(color: AppColors.textoRojoCredencial),
              ),
              Text(
                "IDBIO",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textoRojoCredencial),
              ),
            ],
          ),
        ),
        Container(
          width: 170,
          //color: Colors.blue,
          child: Column(
            children: [
              Text(
                register.id ?? '-',
                style: TextStyle(
                    color: AppColors.textoRojoCredencial, fontSize: 12),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "ALUMNO",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textoRojoCredencial),
              ),
            ],
          ),
        ),
        Container(
          width: 70,
          //color: Colors.green,
          child: Column(
            children: [
              Text(
                register.grade != null ? register.grade : "-",
                style: TextStyle(color: AppColors.textoRojoCredencial),
              ),
              Text(
                "SEMESTRE",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textoRojoCredencial),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _cintillaNombre() {
    return Container(
      height: 60,
      width: double.infinity,
      //color: Colors.blueGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 30,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(register.name != null ? register.name : "-",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
          Container(
            height: 30,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(register.surnames != null ? register.surnames : "-",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cintillaEspecialidad() {
    return Container(
      height: 40,
      width: double.infinity,
      //color: Colors.amber,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 20,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text("ESPECIALIDAD",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textoRojoCredencial)),
            ),
          ),
          Container(
            height: 20,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(register.career != null ? register.career : "-",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textoRojoCredencial)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cintillaNumeroControl() {
    return Container(
      height: 35,
      child: Column(
        children: <Widget>[
          Text(
            'No. CONTROL   ${register.registrationCode != "" ? register.registrationCode : "NO CAPTURADO"}',
            style: TextStyle(color: AppColors.textoRojoCredencial),
          ),
          Image.asset(
            'assets/img/credencial/barcode.PNG',
            fit: BoxFit.fitWidth,
            width: double.infinity,
          )
        ],
      ),
    );
  }

  Widget _cintillaTurno() {
    DateFormat df = DateFormat('dd-MM-yyyy');
    int fecha = register.fecha_registro != null
        ? register.fecha_registro.millisecondsSinceEpoch
        : DateTime.now().millisecondsSinceEpoch;
    var fch1 = df.format(new DateTime.fromMillisecondsSinceEpoch(fecha));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.fromLTRB(70, 14, 0, 0),
          //color: Colors.red,
          height: 30,
          width: 200,
          child: Text(
            register.turn != null ? register.turn : "-",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
          //color: Colors.red,
          height: 30,
          width: 80,
          child: Text(
            fch1.toString() != null ? fch1.toString() : '',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _espacioQR() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          //color: Colors.amber,
        ),
        Container(
          width: 150,
          height: 150,
          //color: Colors.redAccent,
          child: Column(
            children: [
              SizedBox(
                height: 35,
              ),
              //_networkImageWidget(110, 110, register.qrDrive)
              /* Image.network(
                'https://drive.google.com/uc?export=view&id=${register.qrDrive}',
                height: 110,
              ), */
            ],
          ),
        ),
      ],
    );
  }

  Widget _firmaAlumno() {
    DateFormat df = DateFormat('dd-MM-yyyy');
    int fecha = register.fecha_registro != null
        ? register.fecha_registro.millisecondsSinceEpoch
        : DateTime.now().millisecondsSinceEpoch;
    var fch1 = df.format(new DateTime.fromMillisecondsSinceEpoch(fecha));
    //var fecha_emision = fecha.split(" ")[0];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          //color: Colors.amber,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                fch1.toString() != null ? fch1.toString() : '',
                style: TextStyle(
                    color: AppColors.morenaColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        //_networkImageWidget(50, 200, register.firmaDrive, false, true, 15.0)
        /* Container(
          width: 200,
          height: 60,
          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
          //color: Colors.redAccent,
          child: Image.network(
            'https://drive.google.com/uc?export=view&id=${register.firmaDrive}',
            height: 50,
            //fit: BoxFit.fitHeight,
          ),
        ), */
      ],
    );
  }

  Widget _fotoReverso() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container()
        //_networkImageWidget(90, 80, register.fotoUsuarioDrive, true)
      ],
    );
  }

  Widget buildImage(Uint8List bytes) =>
      bytes != null ? Image.memory(bytes) : Container();

  void _showSnackbar(String content) {
    final snackBar = SnackBar(content: (Text(content)));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
