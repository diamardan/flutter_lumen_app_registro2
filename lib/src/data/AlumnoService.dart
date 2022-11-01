//import 'dart:html';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:mime_type/mime_type.dart';
import 'package:lumen_app_registro/src/utils/net_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AlumnoService {
  checkCurp(String curpAlumno) async {
    String endpoint = AppConstants.backendUrl + '/preregistros/checkCurp';
    var uri = Uri.parse(endpoint);
    Map<String, String> headers = {
      "Content-type": "application/json; charset=UTF-8"
    };
    String json = jsonEncode(<String, String>{
      "curp": curpAlumno,
      "schoolName": AppConstants.fsCollectionName
    });
    http.Response response = await http.post(uri, headers: headers, body: json);
    //  int statusCode = response.statusCode;
    String data = response.body;
    print(data);
    return jsonDecode(data);
  }

  finish(Map<String, dynamic> alumno, File voucher, File foto, firma) async {
    String url = AppConstants.backendUrl + '/preregistros/finish';
    final dir = await getTemporaryDirectory();
    await dir.create(recursive: true);
    final imgFirma = File(path.join(dir.path,
        "firma.jpg")); //  '${(await getTemporaryDirectory()).path}/lumen_app/firma.jpg');
    await imgFirma.writeAsBytes(
        firma.buffer.asUint8List(firma.offsetInBytes, firma.lengthInBytes));
    final endpoint = Uri.parse(url);
    final fotoMime = mime(foto.path).split('/');
    final voucherMime = mime(foto.path).split('/');
    // final firmaMime = mime(imgFirma.path).split('/');

    var request = http.MultipartRequest('POST', endpoint)
      ..fields["nombres"] = alumno['nombres']
      ..fields["apellidos"] = alumno['apellidos']
      ..fields["curp"] = alumno['curp']
      ..fields["correo"] = alumno['correo']
      ..fields["celular"] = alumno['celular']
      ..fields["carrera"] = alumno['carrera']
      ..fields["grado"] = alumno['grado']
      ..fields["grupo"] = alumno['grupo']
      ..fields["turno"] = alumno['turno']
      ..fields["matricula"] = alumno['matricula']
      ..fields["sexo"] = alumno['sexo']
      ..fields["tipo_registro"] = "APP"
      ..fields["escuela"] = AppConstants.fsCollectionName;

    if (foto != null) {
      request.files.add(await http.MultipartFile.fromPath('foto', foto.path,
          contentType: MediaType(fotoMime[0], fotoMime[1]), filename: "FOTO"));
    }
    if (voucher != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'voucher', voucher.path,
          contentType: MediaType(voucherMime[0], voucherMime[1]),
          filename: "FOTO"));
    }
    if (firma != null) {
      request.files
          .add(await http.MultipartFile.fromPath('firma', imgFirma.path,
              contentType: MediaType('image', 'jpg'),
              /* MediaType(firmaMime[0], firmaMime[1] )*/
              filename: "FIRMA"));
    }

    var responseJson;

    try {
      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);
      responseJson = returnResponse(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException("No internet Connection");
    }
    //return responseJson;
  }
}
