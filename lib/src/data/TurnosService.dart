import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:lumen_app_registro/src/utils/net_util.dart';

class TurnosService {
  getAll() async {
    String endpoint = AppConstants.backendBaseUrl + '/turns';
    Uri uri = Uri.parse(endpoint);
    Map<String, String> headers = {
      "Content-type": "application/json; charset=UTF-8"
    };
    var responseJson;
    try {
      final response = await http.get(uri, headers: headers);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    print("\nmi respuesta es $responseJson   \n la url es $endpoint");
    return responseJson;
  }
}
