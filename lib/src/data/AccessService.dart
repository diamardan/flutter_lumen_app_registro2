import 'dart:convert';
import 'dart:io';

import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:lumen_app_registro/src/models/acceses_model.dart';
import 'package:lumen_app_registro/src/utils/net_util.dart';
import 'package:http/http.dart' as http;

class AccessService {
  getAll() async {
    String endpoint = AppConstants.backendUrl + '/lumen/accesos/getAll';
    var uri = Uri.parse(endpoint);
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
    print(responseJson);
    return responseJson;
  }

  getAllById(String idbio) async {
    String endpoint = AppConstants.backendUrl + '/lumen/accesos/getAllById';
    var uri = Uri.parse(endpoint);
    Map<String, String> headers = {
      "Content-type": "application/json; charset=UTF-8"
    };
    String json = jsonEncode(<String, String>{
      "idbio": idbio,
    });
    var responseJson;
    try {
      http.Response response =
          await http.post(uri, headers: headers, body: json);
      //   int statusCode = response.statusCode;
      //  String data = response.body;
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    // print("\nmi respuesta es $responseJson   \n la url es $endpoint");
    if (responseJson["message"] == "SUCCESS") {
      List data = responseJson["data"];
      return data.map((event) => Event.fromJson(event)).toList();
    } else
      return [];
  }
}
