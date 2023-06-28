import 'package:lumen_app_registro/src/models/user_model.dart';
import 'package:lumen_app_registro/src/provider/user_provider.dart';
import 'package:lumen_app_registro/src/data/registrationService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../res/colors.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProvider userProvider;

  Registration user;
  final RegistrationService userService = RegistrationService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getStudentData();
  }

  _getStudentData() {
    userProvider = Provider.of<UserProvider>(context, listen: true);

    user = userProvider.getRegistration;
    print(user.toString());
  }

  bool useNotificationDotOnAppIcon = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: user != null
                ? SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        _blockInfo("Idbio", user.idbio.toString()),
                        _blockInfo("Apellidos:",
                            "${user.surnames ?? "No disponible"}"),
                        _blockInfo(
                            "Nombre:", "${user.name ?? "No disponible"} "),
                        _blockInfo("Matricula", user.registrationCode),
                        _blockInfo("CURP", user.curp),
                        _blockInfo("Grado", user.grade),
                        _blockInfo("Grupo", user.group),
                        _blockInfo("Turno", user.turn),
                        _blockInfo("Correo", user.email),
                        _blockInfo("Celular", user.cellphone),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              'https://drive.google.com/uc?export=view&id=${user.fotoUsuarioDrive}',
                              height: 120,
                            ),
                            Image.network(
                              'https://drive.google.com/uc?export=view&id=${user.firmaDrive}',
                            ),
                            Image.network(
                              'https://drive.google.com/uc?export=view&id=${user.qrDrive}',
                            ),
                          ],
                        ),
                        /* user.accessMethod == "email"
                            ? Center(
                                child: Container(
                                    color: Colors.white70,
                                    width: 260,
                                    height: 40,
                                    padding: EdgeInsets.all(0),
                                    child: TextButton(
                                        onPressed: () {
                                          AuthSignPassword.changePassword(
                                              context);
                                        },
                                        child: Text("Cambiar contraseña",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.blue)))))
                            : Container(), */
                      ]))
                : Container()),
      ),
    );
  }

  _blockInfo(label, field) {
    return ListTile(
      subtitle: Text(label),
      title: TextFormField(
        initialValue: field ?? "No disponible",
        enabled: false,
        style: TextStyle(color: AppColors.morenaColor),
      ),
    );
  }
}
