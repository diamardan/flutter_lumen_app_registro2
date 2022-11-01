import 'package:flutter/material.dart';
import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:lumen_app_registro/src/data/SharedService.dart';
import 'package:location/location.dart';
import 'package:lumen_app_registro/src/utils/attendance.dart';

class AttendanceLinkScreen extends StatefulWidget {
  const AttendanceLinkScreen({this.key, this.urlString}) : super(key: key);
  final key;
  final urlString;
  @override
  _AttendanceLinkScreenState createState() => _AttendanceLinkScreenState();
}

class _AttendanceLinkScreenState extends State<AttendanceLinkScreen> {
  final SharedService sharedService = SharedService();
  Map<String, dynamic> attRegister;
  Map<String, dynamic> placeLocation;
  String url;
  String status = "NOT_FOUND";
  String registerId;
  final offsetLocation = 0.000045;
  final Location location = Location();
  LocationData userLocation;
  double distanceRadius;

  @override
  void initState() {
    url = widget.urlString;
    registerId = getRegisterId();
    print("vamos");
    print("registerId  $registerId");
    if (registerId != null) {
      sharedService.get(registerId, "attendance_records").then((result) {
        print("OBJETO  $result");
        if (result != null) {
          print("no es nulo");
          setState(() {
            attRegister = result;
            placeLocation = attRegister['location'];
            status = "FOUND";
          });
        }
      });
    }

    super.initState();
  }

  String getRegisterId() {
    try {
      return url.substring(AppConstants.urlAttendanceIdPosition);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> _isUserInLocation() async {
    userLocation = await location.getLocation();
    final latitude = userLocation.latitude;
    final longitude = userLocation.longitude;
    final isInsideLatitudeRange =
        latitude > (placeLocation['latitude'] - offsetLocation) &&
            latitude < (placeLocation['latitude'] + offsetLocation);
    final isInsideLongitudeRange =
        longitude > (placeLocation['longitude'] - offsetLocation) &&
            longitude < (placeLocation['longitude'] + offsetLocation);
    if (isInsideLatitudeRange && isInsideLongitudeRange)
      return true;
    else
      return false;
  }

  _sayPresent() async {
    userLocation = await location.getLocation();

    final double placeX = placeLocation['longitude'];
    final double placeY = placeLocation['latitude'];
    final double userX = userLocation.longitude;
    final double userY = userLocation.latitude;
    distanceRadius = distance(placeX, placeY, userX, userY);
    if (distanceRadius <= 0.000045) {
      showAlert(context, "ASISTENCIA", "Tu asistencia ha sido registrada");
    } else
      showAlert(
          context, "ERROR ASISTENCIA", "No estás en la ubicación requerida");
  }

  Future<void> showAlert(BuildContext context, String title, String message) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            children: [
              Text(message, style: TextStyle(color: Colors.black)),
              SizedBox(height: 10),
              Text("Coordenadas esperadas",
                  style: TextStyle(color: Colors.black)),
              Text(placeLocation['latitude'].toString(),
                  style: TextStyle(color: Colors.black)),
              Text(placeLocation['longitude'].toString(),
                  style: TextStyle(color: Colors.black)),
              SizedBox(height: 10),
              Text("Coordenadas del usuario",
                  style: TextStyle(color: Colors.black)),
              Text(userLocation.latitude.toString(),
                  style: TextStyle(color: Colors.black)),
              Text(userLocation.longitude.toString(),
                  style: TextStyle(color: Colors.black)),
              SizedBox(height: 10),
              Text("Radio de distancia", style: TextStyle(color: Colors.black)),
              Text(distanceRadius.toString(),
                  style: TextStyle(color: Colors.black)),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("hola $status");
    return Scaffold(
      appBar: AppBar(title: Text("MArca tu asistencia")),
      body: status == "FOUND" ? _attendance() : _notFounded(),
    );
  }

  _attendance() {
    print(attRegister);
    return Center(
        child: Card(
      child: Padding(
          padding: EdgeInsets.all(50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Materia",
                            textAlign: TextAlign.right,
                          ),
                          Text(
                            "Fecha",
                            textAlign: TextAlign.right,
                          ),
                          Text("Hora"),
                          Text("Salón"),
                        ],
                        mainAxisSize: MainAxisSize.min,
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(attRegister['subject']),
                          Text(attRegister['date']),
                          Text(attRegister['time']),
                          Text(attRegister['place']),
                        ],
                        mainAxisSize: MainAxisSize.min,
                      )),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _sayPresent();
                },
                child: Text("Presente"),
              )
            ],
          )),
    ));
  }

  _notFounded() {
    final id = getRegisterId();
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("ESPERE POR FAVOR"),
        Text(id != null ? id : "Id no encontrado")
      ],
    ));
  }
}
