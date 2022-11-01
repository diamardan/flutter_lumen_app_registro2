import 'package:flutter/material.dart';
import 'package:lumen_app_registro/src/data/PaymentsService.dart';
//credit card
import 'package:flutter_credit_card/flutter_credit_card.dart';
//import 'package:flutter_openpay/flutter_openpay.dart';

//end credit card
class PaymentForm extends StatefulWidget {
  PaymentForm({Key key}) : super(key: key);

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  PaymentsService paymentsService = PaymentsService();
  String _name = "";
  String _number = "";
  String _expMonth = "";
  String _expYear = "";
  String _cvc = "";
  String _token = "";
  String _deviceSessionId = "";
  String expiryDate = '';

  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {});
    super.initState();
  }

  Future<void> submit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      String token;

      try {
        Map<String, dynamic> result;
        List<String> expiry = expiryDate.split('/');
        print("estoy recibiendo el card number: $_number");
        /* token = await FlutterOpenpay.tokenizeCard(
          cardholderName: _name,
          cardNumber: _number.replaceAll(new RegExp(r"\s+"), ""),
          cvv: _cvc,
          expiryMonth: expiry[0],
          expiryYear: expiry[1],
          publicApiKey: 'pk_6f4a5e3d039f4c2d97f3458401b973f7',
          merchantId: 'mgq9hsebo1sbdtf1ifpz',
          productionMode: false,
        ); */

        String amount = "150.0";
        String description = "pago del alumno DIMD890715ss";
        String orderId = "oid-GENERICCURP";
        Map<String, dynamic> charge = {};
        charge['source_id'] = token;
        charge['amount'] = amount;
        charge['order_id'] = orderId;
        charge['description'] = description;
        charge['deviceSessionId'] = await requestDeviceSessionId();
        result = await paymentsService.create(charge);
        print("el resultado es $result");
      } catch (e) {
        print("holitas $e.toString()");
        token = "No se puede tokenizar la tarjeta";
      }

      setState(() {
        _token = token;
      });
    }
  }

  Future<String> requestDeviceSessionId() async {
    String deviceSessionId;
    try {
      /* deviceSessionId = await FlutterOpenpay.getDeviceSessionId(
        publicApiKey: 'pk_6f4a5e3d039f4c2d97f3458401b973f7',
        merchantId: 'mgq9hsebo1sbdtf1ifpz',
        productionMode: false,
      );
      setState(() {
        _deviceSessionId = deviceSessionId;
      });
      return deviceSessionId; */
    } catch (e) {
      print(e.toString());
      deviceSessionId = "Unable to tokenize card";
      setState(() {
        _deviceSessionId = deviceSessionId;
      });
      return "error";
    }
  }

  Widget tokenizeCardButton() {
    return new Container(
      width: 240,
      height: 48,
      child: new RaisedButton(
        child: new Text(
          'Pagar',
          style: new TextStyle(color: Colors.white),
        ),
        onPressed: () => submit(),
        color: Colors.blue,
      ),
      margin: new EdgeInsets.only(top: 16.0),
    );
  }

  Widget deviceSessionIdButton() {
    return new Container(
      width: 240,
      height: 48,
      child: new RaisedButton(
        child: new Text(
          'Get device session id',
          style: new TextStyle(color: Colors.white),
        ),
        onPressed: requestDeviceSessionId,
        color: Colors.blue,
      ),
      margin: new EdgeInsets.only(top: 16.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: formPago(),
    );
  }

  Widget formPago() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Pago por tarjeta"),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: _number,
                expiryDate: expiryDate,
                cardHolderName: _name,
                labelCardHolder: "Titular",
                labelExpiredDate: "MM/AA",
                obscureCardCvv: false,
                obscureCardNumber: false,
                cvvCode: _cvc,
                showBackView: isCvvFocused,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        CreditCardForm(
                          formKey: formKey,
                          obscureCvv: false,
                          obscureNumber: false,
                          numberValidationMessage:
                              'Número de tarjeta no válido',
                          dateValidationMessage: 'Formato de fecha no válido',
                          cvvValidationMessage: 'CVV no válido',
                          cardHolderName: "asd",
                          cardNumberDecoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Número de tarjeta',
                            hintText: 'XXXX XXXX XXXX XXXX',
                          ),
                          expiryDateDecoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Expiración',
                            hintText: 'XX/XX',
                          ),
                          cvvCodeDecoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'CVV',
                            hintText: 'XXX',
                          ),
                          cardHolderDecoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nombre del titular',
                          ),
                          onCreditCardModelChange: onCreditCardModelChange,
                        ),
                        tokenizeCardButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    print(_number);
    setState(() {
      _number = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      _name = creditCardModel.cardHolderName;
      _cvc = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
