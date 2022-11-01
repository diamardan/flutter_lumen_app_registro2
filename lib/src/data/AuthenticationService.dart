import 'dart:convert';
import 'dart:io';

import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:lumen_app_registro/src/provider/Device.dart';
import 'package:lumen_app_registro/src/utils/net_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final school = AppConstants.fsCollectionName;

  Stream<User> get userState {
    print("stream connected");
    _auth.authStateChanges().listen((event) {
      print("escuché el evento");
    });
    return _auth.authStateChanges();
  }

  Future<Map<String, String>> signInEmailAndPassword(
      {String email, String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return {"code": "sign_in_success"};
    } on FirebaseAuthException catch (e) {
      return {"code": e.code};
    }
  }

  Future<Map<String, String>> signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
      return {"code": "sign_in_success"};
    } on FirebaseAuthException catch (e) {
      return {"code": e.code};
    }
  }

  Future<Map<String, String>> signUpEmailAndPassword(
      {String email, String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return {"code": "sign_up_success"};
    } on FirebaseAuthException catch (e) {
      return {"code": e.code};
    }
  }

  Future<Map<String, String>> signOut() async {
    try {
      await _auth.signOut();
      return {"code": "sign_out_success"};
    } on FirebaseAuthException catch (e) {
      return {"code": e.code};
    }
  }

  Future<Map<String, String>> sendEmailResetPassword({String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {"code": "SUCCESS_LOGIN"};
    } on FirebaseAuthException catch (e) {
      return {"code": e.code};
    }
  }

  User getUser() {
    try {
      return _auth.currentUser;
    } on FirebaseAuthException {
      return null;
    }
  }

  sendPassword(String email, String password) async {
    String endpoint =
        'https://api.escuelas.infon.mx/api/v1/auth-app/sendPassword';
    var uri = Uri.parse(endpoint);
    Map<String, String> headers = {
      "Content-type": "application/json; charset=UTF-8"
    };
    http.Response response;
    String json = jsonEncode(<String, String>{
      "school": school,
      "email": email,
      "password": password
    });
    try {
      response = await http.post(uri, headers: headers, body: json);
    } on SocketException {
      return {"code": 'no-Internet-connection'};
    }
    var _response = getResponse(response);
    return _response;
  }

  remindPassword(String email, String password) async {
    String endpoint =
        'https://api.escuelas.infon.mx/api/v1/auth-app/remindPassword';
    var uri = Uri.parse(endpoint);
    Map<String, String> headers = {
      "Content-type": "application/json; charset=UTF-8"
    };
    http.Response response;
    String json = jsonEncode(<String, String>{
      "school": school,
      "email": email,
      "password": password
    });
    try {
      response = await http.post(uri, headers: headers, body: json);
    } on SocketException {
      return {"code": 'no-Internet-connection'};
    }
    var _response = getResponse(response);
    return _response;
  }

  Future<Map<String, String>> savePassword(
      String docId, String password) async {
    try {
      await _firestore
          .collection('schools')
          .doc(school)
          .collection("registros")
          .doc(docId)
          .update({'password': password});
      return {'code': 'password_saved_success'};
    } catch (e) {
      return {"code": e.code};
    }
  }

  Future<Map<String, String>> changePassword(String password) async {
    User user = _auth.currentUser;
    try {
      await user.updatePassword(password);
      return {"code": "password_changed_successful"};
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return {"code": e.code};
    }
  }

  Future<List<Device>> getDevices(String registrationId) async {
    var result = await FirebaseFirestore.instance
        .collection("schools")
        .doc(school)
        .collection("registros")
        .doc(registrationId)
        .collection("devices")
        .get();

    if (result.size > 0) {
      return result.docs.map((doc) {
        var data = doc.data();
        return Device.fromJson(data);
      }).toList();
    } else
      return [];
  }
}
