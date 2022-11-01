import 'package:lumen_app_registro/src/controllers/SignIn/SignInController.dart';
import 'package:lumen_app_registro/src/provider/Device.dart';
import 'package:lumen_app_registro/src/provider/user_provider.dart';
import 'package:lumen_app_registro/src/data/AuthenticationService.dart';
import 'package:lumen_app_registro/src/data/DeviceService.dart';
import 'package:lumen_app_registro/src/data/RegistrationService.dart';
import 'package:lumen_app_registro/ui/res/typography.dart';
import 'package:lumen_app_registro/ui/widgets/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class MyDevicesScreen extends StatefulWidget {
  const MyDevicesScreen({Key key}) : super(key: key);

  @override
  _MyDevicesScreenState createState() => _MyDevicesScreenState();
}

class _MyDevicesScreenState extends State<MyDevicesScreen> {
  RegistrationService registrationService = RegistrationService();
  DeviceService deviceService = DeviceService();
  List devices = [];
  String userId;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _getDevices();

    super.didChangeDependencies();
  }

  setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  _getDevices() {
    userId =
        Provider.of<UserProvider>(context, listen: false).getRegistration.id;

    AuthenticationService().getDevices(userId).then((_devices) => setState(() {
          devices = _devices;
        }));
  }

  _removeDevice(deviceId) async {
    Device myDevice = await DeviceProvider.instance.device;
    if (deviceId == myDevice.id) {
      bool res = await showLogoutDialog(context, "my-devices-screen");
      if (res) {
        setLoading(true);
        await SignInController().cleanAuthenticationData(context);
        Navigator.pop(context);
        AuthenticationService().signOut();
      }
    } else
      deviceService.removeDevice(userId, deviceId);
    _getDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          centerTitle: true,
        ),
        body: Column(children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(10, 20, 0, 5),
              child: Text(
                "Mis Dispositivos",
                style: TextStyle(
                    fontWeight: AppTypography.header2weight,
                    fontSize: AppTypography.header2size),
              )),
          Expanded(
              child: ListView.builder(
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    var device = devices[index];
                    return Dismissible(
                      key: Key(device.hashCode.toString()),
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 3, color: Color(0XFFEEEEEE)))),
                          child: ListTile(
                            leading:
                                Icon(Icons.phone_android_outlined, size: 50),
                            title: Text(
                              "${device.brand.toString().capitalize()} ",
                            ),
                            subtitle: Text(
                              "${device.model}",
                            ),
                            /* trailing: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () => _removeDevice(device.id)),*/
                          )),
                      background: Container(color: Colors.red),
                      onDismissed: (direction) {},
                    );
                  }))
        ]));
  }
}
