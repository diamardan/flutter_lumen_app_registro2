import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lumen_app_registro/src/utils/net_util.dart';

class PaymentsService {
  getAll() async {
    String url = 'http://192.168.0.10:5000/api/v1/payments/create';

    var uri = Uri.parse(url);
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
    print("\nmi respuesta es $responseJson   \nla url es $url");

    return responseJson;
  }

  create(Map<String, dynamic> charge) async {
    String url = 'http://192.168.0.10:5000/api/v1/payments/create';
    var uri = Uri.parse(url);
    Map<String, String> headers = {
      "Content-type": "application/json; charset=UTF-8"
    };
    String json = jsonEncode(<String, String>{
      "source_id": charge['source_id'],
      "amount": charge['amount'],
      "order_id": charge['order_id'],
      "description": charge['description'],
      "device_session_id": charge['deviceSessionId'],
    });
    print(charge['customer']);
    http.Response response = await http.post(uri, headers: headers, body: json);
    //  int statusCode = response.statusCode;
    String data = response.body;
    return jsonDecode(data);
  }
}
