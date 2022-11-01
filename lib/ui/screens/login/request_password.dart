import 'dart:math';
import 'package:lumen_app_registro/src/data/AuthenticationService.dart';
import 'package:lumen_app_registro/src/utils/auth_sign.dart';
import 'package:lumen_app_registro/src/utils/enums.dart';
import 'package:lumen_app_registro/ui/res/notify_ui.dart';
import 'package:lumen_app_registro/src/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../res/colors.dart';

class RequestPasswordScreen extends StatefulWidget {
  _RequestPasswordScreenState createState() => _RequestPasswordScreenState();
}

class _RequestPasswordScreenState extends State<RequestPasswordScreen> {
  bool showeSigInButton = false;
  bool enabledSendButton = true;
  bool loading = false;
  final _authService = AuthenticationService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = "";
  bool emailError = false;

  @override
  void dispose() {
    super.dispose();
  }

  String generatePassword() {
    final length = 12;
    final letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
    final letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    final number = '01234567890123456789';
    final special = '@#%+&@#%+&';

    String chars = "";
    chars += '$letterLowerCase$letterUpperCase';
    chars += '$number';
    chars += '$special';

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');
  }

  _createAccount() async {
    setState(() {
      loading = true;
    });

    _formKey.currentState.save();
    if (!_formKey.currentState.validate()) return;

    var result = await AuthSign.signUpWithEmailAndPassword(_email);
    switch (result) {
      case AuthResponseStatus.SUCCESS:
        NotifyUI.flushbar(context, "El correo electrónico ha sido enviado.");
        setState(() {
          enabledSendButton = false;
          showeSigInButton = true;
        });
        break;
      case AuthResponseStatus.EMAIL_ALREADY_EXISTS:
        await NotifyUI.showError(context, "Error de activación de cuenta",
            "Ya existe una cuenta activa para este correo. ");
        break;
      case AuthResponseStatus.USER_NOT_FOUND:
        await NotifyUI.showError(context, "Error de activación de cuenta",
            "El correo proporcionado no fue encontrado. ");
        break;
      case AuthResponseStatus.ANOTHER_ERROR:
        await NotifyUI.showError(
            context, "Error de activación de cuenta ", result['code']);
        break;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              title: Text("ACTIVAR CUENTA"),
              titleTextStyle: TextStyle(color: Colors.black87),
            ),
            //resizeToAvoidBottomInset: false,
            body: ModalProgressHUD(
              inAsyncCall: loading,
              child: SingleChildScrollView(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          kToolbarHeight,
                      //decoration: BoxDecoration(color: Color(0Xcdcdcdff)),
                      child: Center(
                        child: _content(),
                      ))),
            )));
  }

  _content() {
    return (Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.05),
          border: Border.all(color: Colors.grey.withOpacity(0.7), width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        width: 280,
        height: 560,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),
            Icon(
              Icons.account_circle,
              size: 70,
              color: AppColors.secondary,
            ),
            SizedBox(
              height: 20,
            ),
            _form(),
            SizedBox(
              height: 20,
            ),
            showeSigInButton == true
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("INICIAR SESIÓN"),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.morenaLightColor)),
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
          ],
        )));
  }

  _form() {
    return Form(
        key: _formKey,
        child: Column(children: [
          Text(
            "Introduce el correo electrónico que registraste: ",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
          _emailTextField(),
          SizedBox(
            height: 20,
          ),
          Text(
            "Activaremos tu cuenta y te enviaremos un correo electrónico con tu contraseña",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textFieldLabel),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: _email != "" && enabledSendButton == true
                ? _createAccount
                : null,
            child: Text(
              "ENVIAR C ORREO ELECTRÓNICO",
              textAlign: TextAlign.center,
            ),
            style: ElevatedButton.styleFrom(
                primary: AppColors.morenaLightColor.withOpacity(0.9),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                textStyle:
                    TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ]));
  }

  _emailTextField() {
    return Container(
        height: !emailError ? 64 : 84,
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          maxLength: 50,
          decoration: InputDecoration(
              //contentPadding: const EdgeInsets.all(8.0),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: AppColors.morenaLightColor, width: 2.0),
                borderRadius: BorderRadius.circular(20.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 1),
              hintText: "",
              isCollapsed: false,
              counter: Offstage()),
          validator: (value) {
            var error = ValidatorsLumen().validateEmail(value);
            if (error != null) {
              setState(() {
                emailError = true;
              });
              return error;
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _email = value.trim();
            });
          },
        ));
  }
}
