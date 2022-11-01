import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:lumen_app_registro/src/controllers/SignIn/SignInQRController.dart';
import 'package:lumen_app_registro/ui/res/design_constants.dart';
import 'package:lumen_app_registro/ui/screens/login/login_email_screen.dart';
import 'package:lumen_app_registro/ui/screens/login/recovery_screen.dart';
import 'package:lumen_app_registro/ui/screens/login/request_password.dart';
import 'package:lumen_app_registro/ui/screens/preregistro/create_form.dart';
import 'package:lumen_app_registro/ui/res/notify_ui.dart';
import 'package:lumen_app_registro/ui/widgets/loading.dart';
import 'package:lumen_app_registro/ui/widgets/whatsapp_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../src/controllers/SignIn/SignInEmailController.dart';
import '../../../src/utils/validator.dart';
import '../../res/colors.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final SignInQRController signInController = SignInQRController();
  String messageTitle = 'Error de inicio de sesión';
  int index = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _emailError = false;
  bool _passwordError = false;
  bool _passwordVisible = false;
  final FocusNode passwordFocus = FocusNode();
  final SignInEmailController signInEmailController = SignInEmailController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  void _loginQrFromFile() async {
    setLoading(true);
    final picker = ImagePicker();
    try {
      XFile _file = await picker.pickImage(source: ImageSource.gallery);
      if (_file == null) {
        setLoading(false);
        return;
      }

      String qrText = await signInController.decodeImage(_file.path);
      if (qrText == null || qrText == "") {
        setLoading(false);
        NotifyUI.showError(
            context, messageTitle, 'No se encontró código qr o es inválido');
      }

      Map<String, dynamic> response =
          await signInController.authenticate(qrText);
      print(response);
      if (response["code"].toString() != "sign_in_success") {
        /* } else */
        setLoading(false);
        await NotifyUI.showError(context, messageTitle, response["message"]);
      }
    } catch (error) {
      await NotifyUI.showError(context, messageTitle, error.toString());
    }
  }

  _loginWithCamera(BuildContext context) async {
    try {
      setLoading(true);
      String qr = await signInController.scanQR();

      if (qr == null || qr == "") {
        setLoading(false);
        return;
      }

      Map<String, dynamic> response = await signInController.authenticate(qr);

      print('mi respuesta de login es : ${response["code"].toString()}');
      if (response["code"].toString() != "sign_in_success") {
        /* } else { */
        setLoading(false);
        await NotifyUI.showError(context, messageTitle, response["message"]);
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        showDialogPermissions(context);
      } else {
        print('error: $e');
      }
    } catch (error) {
      setLoading(false);
      await NotifyUI.showError(
          context, "Error de inicio de sesión", error.toString());
    }
  }

  _loginWithWmail() async {
    FocusScope.of(context).requestFocus(FocusNode());
    _formKey.currentState.save();

    _formKey.currentState.validate();
    if (!_formKey.currentState.validate()) return;

    var _email = emailController.text.trim();
    var _password = passwordController.text.trim();

    //   try {
    setLoading(true);
    Map<String, dynamic> response =
        await signInEmailController.authenticate(context, _email, _password);

    if (response["code"] == "sign_in_success") {
    } else {
      setLoading(false);
      await NotifyUI.showError(
          context, "Error de inicio de sesión", response["message"]);
    }
    /* } catch (e) {
      print("error");
      print(e.toString());
      setLoading(false);
      await NotifyUI.showError(
          context, "Error de inicio de sesión", e.toString());
    }*/
  }

  Widget _botonRegistro(BuildContext context) {
    return Container(
        height: 50,
        width: 230,
        child: TextButton.icon(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PreregForm()));
          },
          style: TextButton.styleFrom(
            //  elevation: 1,
            primary: AppColors.primary,

            /*shape: RoundedRectangleBorder(
                // side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(50)),*/
          ),
          icon: Icon(Icons.app_registration),
          label: Text(
            "Ir a Registro",
            textAlign: TextAlign.center,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (index > 0) {
            setState(() {
              index--;
            });
            return false;
          } else
            return true;
        },
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(),
          body: CustomLoading(
            inAsyncCall: loading,
            child: SingleChildScrollView(child: _login_options(context)),
          ),
        )));
  }

  /* Widget _header(BuildContext context) {
    return AppBar(
      title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/img/logo-3.png',
              color: AppColors.white.withOpacity(0.8),
              width: 100,
            ),
            SizedBox(height: 10),
            /*Text(
              "CETIS 32",
              textAlign: TextAlign.center,
                 style: GoogleFonts.bungee(
                  fontSize: 20,
                  //color: AppColors.primary,
                )),*/

            SizedBox(
              height: 0,
            ),
            /*Text("Sistema Escolar Inteligente",
                style: GoogleFonts.adamina(fontSize: 14)),*/
          ]),
      centerTitle: true,
      toolbarHeight: 120,
      /* shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.vertical(
        bottom: new Radius.elliptical(SizeConfig.screenWidth, 56.0),
      ),
    ),*/
    );
  }*/

  // ignore: non_constant_identifier_names
  Widget _login_options(BuildContext context) {
    return Container(
        height: 780,
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .12),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 30,
              ),
              Image.asset(
                'assets/img/logo-3.png',
                width: 120,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Iniciar sesión con',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              _button(Icons.qr_code, "QR desde camara", "camera", context),
              _button(
                  Icons.upload_file_sharp, "QR desde archivo", "qr", context),
              SizedBox(
                height: 10,
              ),
              Container(
                  child: Text(
                "o",
              )),
              _emailOption(),
              SizedBox(
                height: 10,
              ),
              //_botonRegistro(context),
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Container(
                      //width: 150,
                      height: AppSizes.buttonHeight,
                      child: WhatsappHelpBtn(context: context)),
                  SizedBox(
                    height: 20,
                  )
                ],
              ))
            ]));
  }

  _emailOption() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          /*  Align(
                alignment: Alignment.center,
                child: Text("Correo Electrónico: *",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondary,
                    ))),*/
          SizedBox(height: 10),
          _emailTextField(),
          SizedBox(
            height: 0,
          ),
          /*  Align(
              alignment: Alignment.center,
              child: Text(
                "Contraseña: *",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),*/
          SizedBox(
            height: 4,
          ),
          _passwordTextField(),
          SizedBox(
            height: 10,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Material(
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RequestPasswordScreen()));
                    },
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RecoveryPasswordScreen()));
                        },
                        child: Text(
                          "¿Olvidaste tu contraseña?",
                          style:
                              TextStyle(color: AppColors.primary, fontSize: 14),
                        ))),
              )),
          SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: AppSizes.buttonHeight,
            child: ElevatedButton(
              onPressed: _loginWithWmail,
              child: Text("Entrar"),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  elevation: 1,
                  // fixedSize: Size(200, 45),
                  primary: AppColors.primary,
                  textStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  _button(icon, title, key, context) => Container(
      width: MediaQuery.of(context).size.width,
      height: AppSizes.buttonHeight,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton.icon(
          icon: Icon(icon, color: AppColors.onPrimary),
          label: Text(
            "  " + title,
          ),
          onPressed: () {
            switch (key) {
              case "camera":
                _loginWithCamera(context);
                break;
              case "qr":
                _loginQrFromFile();
                break;
            }
          }));

  _emailTextField() {
    return Container(
        height: !_emailError ? 64 : 84,
        child: TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            label: Text("Correo electrónico"),
            //   hintText: "",
          ),
          onFieldSubmitted: (value) => passwordFocus.requestFocus(),
          validator: (value) {
            var error = "";
            if (value.trim() == "") {
              setState(() {
                _emailError = true;
              });
              return "Campo requerido.";
            }
            error = ValidatorsLumen().validateEmail(value);
            if (error != "" && error != null) {
              setState(() {
                _emailError = true;
              });
              return error;
            }

            return null;
          },
        ));
  }

  _passwordTextField() {
    return Container(
      height: !_passwordError ? 64 : 84,
      child: TextFormField(
        controller: passwordController,
        keyboardType: TextInputType.visiblePassword,
        focusNode: passwordFocus,
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                  !_passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
            label: Text("Contraseña"),
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 1)),
        onFieldSubmitted: (value) => _loginWithWmail,
        validator: (value) {
          if (value.trim() == "") {
            setState(() {
              _passwordError = true;
            });
            return "Campo requerido";
          }

          return null;
        },
      ),
    );
  }

  /* _notHavePassword() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            "Si no cuentas con contraseña",
            style: TextStyle(fontSize: 15),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("puedes ", style: TextStyle(fontSize: 15)),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RequestPasswordScreen()));
                },
                child: Text(
                  "solicitarla aquí",
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ))
          ])
        ]));
  }*/

  showDialogPermissions(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Sin acceso a Cámara'),
            content:
                Text('Permitir el acceso de la Cámara para poder escanear'),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () async {
                  await openAppSettings();
                },
              )
            ],
          );
        });
  }
}
