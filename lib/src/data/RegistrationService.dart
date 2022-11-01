import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:lumen_app_registro/src/models/user_model.dart';
import 'package:lumen_app_registro/src/data/SharedService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const school = AppConstants.fsCollectionName;

class RegistrationService {
  final db = FirebaseFirestore.instance.collection("schools").doc(school);

  checkCurp(String curp) async {
    return SharedService().get(curp, "registrations");
  }

  Future<Registration> checkQr(String qrData) async {
    var result =
        await db.collection("registros").where("qr", isEqualTo: qrData).get();

    if (result.docs.isNotEmpty) {
      var data = result.docs.first.data();
      return Registration.fromJson({"id": result.docs.first.id, ...data});
    } else
      return null;
  }

  Future<Registration> checkEmail(String email) async {
    var result = await FirebaseFirestore.instance
        .collection("schools")
        .doc(school)
        .collection("registros")
        .where("correo", isEqualTo: email)
        .get();

    if (result.docs.isNotEmpty) {
      var data = result.docs.first.data();
      var registrationMap = {"id": result.docs.first.id, ...data};
      return Registration.fromJson(registrationMap);
    } else
      return null;
  }

  Future<Registration> get(String registrationId) {
    return FirebaseFirestore.instance
        .collection("schools")
        .doc(school)
        .collection("registros")
        .doc(registrationId)
        .get()
        .then((result) {
      if (result.exists) {
        var data = result.data();
        var registrationMap = {"id": result.id, ...data};
        Registration registration = Registration.fromJson(registrationMap);
        return registration;
      } else
        return null;
    });
  }
}
