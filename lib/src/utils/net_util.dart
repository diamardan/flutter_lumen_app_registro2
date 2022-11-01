import 'package:lumen_app_registro/src/utils/enums.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Map<String, String> getResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      print(responseJson);
      return {"code": "delivery_email_successful"};
    case 400:
      return {"code": "bad_request"};
    case 401:
    case 403:
      return {"code": "unauthorised_access"};
    case 500:
    default:
      return {"code": "communication_error"};
  }
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return _message;
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message]) : super(message);
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Petición invalida: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "No tiene permisos: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message])
      : super(message, "Entrada Inválida: ");
}

dynamic returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      print(responseJson);
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error ocurrido durante la Communicación con el Servidorr con código de estatus : ${response.statusCode}');
  }
}

class ApiResponse<T> {
  Status status;
  T data;
  String message;

  ApiResponse.loading(this.message) : status = Status.LOADING;
  ApiResponse.completed(this.data) : status = Status.COMPLETED;
  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}
