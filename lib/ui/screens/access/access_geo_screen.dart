import 'package:lumen_app_registro/ui/screens/access/calendar.dart';
import 'package:flutter/material.dart';

class AccessesGeoScreen extends StatefulWidget {
  AccessesGeoScreen({Key key}) : super(key: key);
  @override
  _AccessesGeoScreenState createState() => _AccessesGeoScreenState();
}

//_getEventsForDay(DateTime day) {}

class _AccessesGeoScreenState extends State<AccessesGeoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Accesos Geolocalización'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white),
      body: SafeArea(
        child: Calendar(),
      ),
    );
    //);
  }
}
