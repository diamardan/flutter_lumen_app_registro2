import 'package:lumen_app_registro/ui/res/colors.dart';
import 'package:lumen_app_registro/ui/screens/access/calendar.dart';
import 'package:flutter/material.dart';

class AccessesScreen extends StatefulWidget {
  AccessesScreen({Key key}) : super(key: key);
  @override
  _AccessesScreenState createState() => _AccessesScreenState();
}

_getEventsForDay(DateTime day) {}

class _AccessesScreenState extends State<AccessesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accesos'),
        centerTitle: true,
        //  backgroundColor: Colors.green,
        // foregroundColor: Colors.white,
      ),
      body: SafeArea(child: Calendar()),
    );
  }
}
