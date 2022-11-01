import 'package:flutter/material.dart';
import 'package:lumen_app_registro/src/constants/constants.dart';
//import 'package:cetis32_app_registro/ui/screens/pago/payment_form.dart';

import '../../res/colors.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({Key key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Método de pago"),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                height: 110,
                decoration: BoxDecoration(color: AppColors.paymentInfoHeader),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: <Widget>[
                      Text(
                        "Artículos: 1",
                        style: TextStyle(color: AppColors.text2, fontSize: 20),
                      ),
                      Text(
                        "Subtotal: \$150",
                        style: TextStyle(color: AppColors.text2, fontSize: 20),
                      ),
                      Text(
                        "Concepto: Inscripción del alumno",
                        style: TextStyle(color: AppColors.text2, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      pagoEnTienda(),
                      Divider(),
                      pagoPorTarjeta()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget pagoEnTienda() {
    return MaterialButton(
      padding: EdgeInsets.all(0),
      onPressed: () {},
      child: Container(
        height: 160,
        decoration: cardDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(children: <Widget>[
            Text('Pago en tienda de autoservicio'),
            Text('Puede pagar en los siguientes establecimientos'),
            new Image.asset(
              'assets/img/tiendas.png',
              height: 80,
            ),
            Text('La tienda puede aplicar una comisión sobre el pago')
          ]),
        ),
      ),
    );
  }

  Widget pagoPorTarjeta() {
    return MaterialButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        /* Navigator.push(
            context, MaterialPageRoute(builder: (context) => PaymentForm())); */
      },
      child: Container(
        height: 160,
        decoration: cardDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(children: <Widget>[
            Text('Pago por tarjeta de crédito / débito'),
            Text('el cobro se hace es porcesado directamente por'),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Image.asset(
                'assets/img/openpay_color.png',
                height: 60,
              ),
            ),
            Text('no hay tarifas extras y se refleja al instante')
          ]),
        ),
      ),
    );
  }

  BoxDecoration cardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
            color: Colors.black26,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 4.0))
      ],
      color: Colors.white,
    );
  }
}
