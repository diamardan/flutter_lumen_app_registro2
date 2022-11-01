import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SharedService {
  Future<Map<String, dynamic>> get(String docId, String collection) {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .get()
        .then((result) {
      print(result);
      if (result.exists) {
        return {...result.data()};
      } else
        return null;
    });
  }

  Future<List<Map<String, dynamic>>> getAll(String collection) {
    return FirebaseFirestore.instance
        .collection('schools')
        .doc(AppConstants.fsCollectionName)
        .collection(collection)
        .orderBy("position")
        .get()
        .then((result) {
      print(result);
      final data = result.docs.map((doc) => ({"id": doc.id, ...doc.data()}));
      return data.toList();
    });
  } //function

}
