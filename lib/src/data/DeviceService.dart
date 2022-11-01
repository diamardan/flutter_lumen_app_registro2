import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:lumen_app_registro/src/provider/Device.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const school = AppConstants.fsCollectionName;

class DeviceService {
  final db = FirebaseFirestore.instance.collection("schools").doc(school);

  Future<int> getActivedDevices(String regId) async {
    var res =
        await db.collection("registros").doc(regId).collection("devices").get();
    return res.size;
  }

  Future<void> addDevice(String regId, Device device) async {
    await db
        .collection("registros")
        .doc(regId)
        .collection("devices")
        .doc(device.id)
        .set(device.toJson());
  }

  Future<void> removeDevice(String regId, String deviceId) async {
    await db
        .collection("registros")
        .doc(regId)
        .collection("devices")
        .doc(deviceId)
        .delete();
  }
}
