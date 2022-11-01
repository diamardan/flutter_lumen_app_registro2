import 'package:lumen_app_registro/src/controllers/SignIn/SignInEmailController.dart';
import 'package:lumen_app_registro/ui/res/notify_ui.dart';
import 'package:lumen_app_registro/src/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../res/colors.dart';

class RecoveryPasswordScreen extends StatefulWidget {
  _RecoveryPasswordScreenState createState() => _RecoveryPasswordScreenState();
}

class _RecoveryPasswordScreenState extends State<RecoveryPasswordScreen> {
  bool showSignInButton = false;
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = "";
  bool enabledSendButton = false;
  bool emailError = false;

  @override
  void dispose() {
    super.dispose();
  }

  setLoading(value) {
    setState(() {
      loading = value;
    });
  }

  _recovery() async {
    _formKey.currentState.save();
    if (!_formKey.currentState.validate()) return;
    setLoading(true);
    try {
      var result = await SignInEmailController().recoveryPassword(_email);
      setLoading(false);
      if (result["code"] == "success") {
        setState(() {
          loading = false;
          enabledSendButton = false;
          showSignInButton = true;
        });
        NotifyUI.flushbar(context,
            "El correo electrónico de restablecimiento de contraseña ha sido enviado");
      } else
        await NotifyUI.showError(
          context,
          "Error de recuperación de contraseña ",
          result["message"],
        );
    } catch (e) {
      await NotifyUI.showError(
        context,
        "Error de recuperación de contraseña ",
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      //resizeToAvoidBottomInset: false,

      body: Center(
          child: ModalProgressHUD(
              inAsyncCall: loading,
              child: SingleChildScrollView(
                child: Center(
                  child: _content(context),
                ),
              ))),
    ));
  }

  _content(BuildContext ctx) {
    return (Container(
        padding: EdgeInsets.symmetric(
            vertical: 20, horizontal: MediaQuery.of(context).size.width * .12),
        height: 540,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo-3.png',
              color: AppColors.primary,
              width: 100,
            ),
            SizedBox(
              height: 50,
            ),
            Text("Recupera tu Contraseña",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2),
            SizedBox(
              height: 40,
            ),
            _form(),
            SizedBox(
              height: 20,
            ),
            showSignInButton == true
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("INICIAR SESIÓN"),
                  )
                : Container(),
          ],
        )));
  }

  _form() {
    return Form(
        key: _formKey,
        child: Column(children: [
          Text(
            "Introduce tu correo electrónico:",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          _emailTextField(),
          SizedBox(
            height: 0,
          ),
          Text(
            "Te enviaremos un correo electrónico con  tu contraseña.",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  _recovery();
                },
                child: Text(
                  "  Enviar correo  ",
                  //textAlign: TextAlign.center,
                ),
              )),
          SizedBox(
            height: 20,
          ),
        ]));
  }

  _emailTextField() {
    return Container(
        height: !emailError ? 64 : 84,
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              //contentPadding: const EdgeInsets.all(8.0),

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
