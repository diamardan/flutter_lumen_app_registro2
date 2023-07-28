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
    String endpoint =
        AppConstants.backendBaseUrl + '/preregistrations/verify-curp';
    var uri = Uri.parse(endpoint);
    print(endpoint);
    Map<String, String> headers = {
      "Content-type": "application/json; charset=UTF-8"
    };
    String json = jsonEncode(<String, String>{
      "curp": curpAlumno,
    });
    http.Response response = await http.post(uri, headers: headers, body: json);
    //  int statusCode = response.statusCode;
    String data = response.body;
    print(data);
    return jsonDecode(data);
  }

  finish(Map<String, dynamic> alumno, File voucher, File foto, firma,
      bool existe) async {
    String url = AppConstants.backendBaseUrl + '/preregistrations';
    existe ? url = url + '/${alumno['id']}' : url = url;
    print(alumno['id']);
    final dir = await getTemporaryDirectory();
    await dir.create(recursive: true);
    final imgFirma = File(path.join(dir.path,
        "firma.jpg")); //  '${(await getTemporaryDirectory()).path}/lumen_app/firma.jpg');
    await imgFirma.writeAsBytes(
        firma.buffer.asUint8List(firma.offsetInBytes, firma.lengthInBytes));
    final endpoint = Uri.parse(url);
    // final firmaMime = mime(imgFirma.path).split('/');

    var request = http.MultipartRequest(existe ? 'PATCH' : 'POST', endpoint)
      ..fields["names"] = alumno['names']
      ..fields["surnames"] = alumno['surnames']
      ..fields["curp"] = alumno['curp']
      ..fields["email"] = alumno['email']
      ..fields["cellphone"] = alumno['cellphone']
      ..fields["career"] = alumno['career']
      ..fields["grade"] = alumno['grade']
      ..fields["group"] = alumno['group']
      ..fields["turn"] = alumno['turn']
      ..fields["registration_number"] = alumno['registration_number']
      /* ..fields["sex"] = alumno['sex'] */
      ..fields["registration_type"] = "APP";
    /* ..fields["school"] = AppConstants.fsCollectionName; */

    if (foto != null) {
      final fotoMime = mime(foto.path).split('/');

      request.files.add(await http.MultipartFile.fromPath(
          'student_photo', foto.path,
          contentType: MediaType(fotoMime[0], fotoMime[1]), filename: "FOTO"));
    }
    if (voucher != null) {
      final voucherMime = mime(voucher.path).split('/');

      request.files.add(await http.MultipartFile.fromPath(
          'student_voucher', voucher.path,
          contentType: MediaType(voucherMime[0], voucherMime[1]),
          filename: "FOTO"));
    }
    if (firma != null) {
      request.files.add(
          await http.MultipartFile.fromPath('student_signature', imgFirma.path,
              contentType: MediaType('image', 'jpg'),
              /* MediaType(firmaMime[0], firmaMime[1] )*/
              filename: "FIRMA"));
    }
    try {
      var responseJson;

      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);
      //responseJson = returnResponse(response);
      return returnResponse(response);
    } on SocketException {
      throw FetchDataException("No internet Connection");
    }
    //return responseJson;
  }
}
