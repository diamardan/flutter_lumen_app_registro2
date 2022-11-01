import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const school = AppConstants.fsCollectionName;

class LogService {
  static final db =
      FirebaseFirestore.instance.collection("schools").doc(school);

  static sendMessage(String message) async {
    db.collection("log").add({"message": message});
  }
}
