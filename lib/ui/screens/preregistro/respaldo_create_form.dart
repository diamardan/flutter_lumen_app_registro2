import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:lumen_app_registro/src/customWidgets/Alert.dart';
import 'package:lumen_app_registro/ui/screens/preregistro/last_screen.dart';
import 'package:lumen_app_registro/src/data/AlumnoService.dart';
import 'package:lumen_app_registro/src/data/EspecialidadesService.dart';
import 'package:lumen_app_registro/src/data/GruposService.dart';
import 'package:lumen_app_registro/src/data/SemestresService.dart';
import 'package:lumen_app_registro/src/data/TurnosService.dart';
import 'package:lumen_app_registro/src/utils/txtFormater.dart';
import 'package:lumen_app_registro/src/utils/validator.dart';
import 'package:signature/signature.dart';

class PreregForm extends StatefulWidget {
  PreregForm({Key key}) : super(key: key);

  @override
  _PreregFormState createState() => _PreregFormState();
}

class _PreregFormState extends State<PreregForm> {
  final AlumnoService alumnoService = AlumnoService();
  final EspecialidadesService especialidadesService = EspecialidadesService();
  final SemestresService semestresService = SemestresService();
  final GruposService gruposService = GruposService();
  final TurnosService turnosService = TurnosService();

  final _curpAlumnoController = TextEditingController();
  final _nombreAlumnoController = TextEditingController();
  final _apellidosAlumnoController = TextEditingController();
  final _correoAlumnoController = TextEditingController();
  final _celularAlumnoController = TextEditingController();
  final _matriculaAlumnoControler = TextEditingController();

  int especialidadSeleccionada;
  int semestreSeleccionado;
  int grupoSeleccionado;
  int turnoSeleccionado;
  int id_registro;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  int _currentStep = 0;
  bool completed = false;
  bool _loading = true;
  bool isLoading = false;
  final ValidatorsLumen validators = new ValidatorsLumen();
  final SignatureController _signController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  Map<String, dynamic> resultEsp;
  Map<String, dynamic> resultSem;
  Map<String, dynamic> resultGru;
  Map<String, dynamic> resultTur;

  List _especialidades = [];
  List _semestres = [];
  List _grupos = [];
  List _turnos = [];
  File foto;
  File voucher;

  @override
  void initState() {
    super.initState();
    _cargarEspecialidades();
    _cargarSemestres();
    _cargarGrupos();
    _cargarTurnos();
    setState(() {
      _loading = false;
    });
  }

  void _cargarEspecialidades() async {
    var especialidades;
    try {
      resultEsp = await especialidadesService.getAll();
      especialidades = resultEsp['data'];
      print(especialidades);
      setState(() {
        _especialidades = especialidades;
        _especialidades
            .add({'id': -1, 'ESPECIALIDAD': 'Seleccione una carrera'});
        _loading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  void _cargarSemestres() async {
    var semestres;
    try {
      resultSem = await semestresService.getAll();
      semestres = resultSem['data'];
      print(semestres);
      setState(() {
        _semestres = semestres;
        _semestres.add({'id': -1, 'SEMESTRE': 'Seleccione un semestre'});
        _loading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  void _cargarGrupos() async {
    var grupos;
    try {
      resultGru = await gruposService.getAll();
      grupos = resultGru['data'];
      print(grupos);
      setState(() {
        _grupos = grupos;
        _grupos.add({'id': -1, 'GRUPO': 'Seleccione un grupo'});
        _loading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  void _cargarTurnos() async {
    var turnos;
    try {
      resultTur = await turnosService.getAll();
      turnos = resultTur['data'];
      print(turnos);
      setState(() {
        _turnos = turnos;
        _turnos.add({'id': -1, 'TURNO': 'Seleccione un turno'});
        _loading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  next() {
    if (formKeys[_currentStep].currentState.validate()) {
      if (_currentStep < _mySteps().length - 1) {
        goTo(_currentStep + 1);
      } else {
        if (_currentStep == _mySteps().length - 1) {
          //procesarFirma();
          finishForm();
        }
        setState(() => completed = true);
      }
      /*  _currentStep < _mySteps().length -1
          ? goTo(_currentStep + 1)
          : setState(() => completed = true); */
    }
  }

  cancel() {
    if (_currentStep > 0) {
      goTo(_currentStep - 1);
    } else {
      Navigator.popUntil(context, ModalRoute.withName('inicio'));
    }
  }

  Future<bool> validateCurp(int step) async {
    bool avanza = false;
    Map<String, dynamic> result;

    print('voy a validar');
    try {
      result = await alumnoService.checkCurp(_curpAlumnoController.text);
    } catch (error) {
      print('estoy en catch');
      print(error);
    }

    if (result['message'] == null) {
      showAlertDialog(context, "Error",
          "Ocurrió un error al conectarse al servidor", "error");
    }

    var message = result['message'];
    if (message == "SUCCESS") {
      var alumno = result['data'];
      setState(() {
        id_registro = alumno[0]['ID_REGISTRO'];
      });
      if (alumno.length >= 1) {
        avanza = true;
      }
    } else {
      showAlertDialog(context, "Error",
          "Ocurrió un error al conectarse al servidor", "error");
    }
    print('misVotos: $result');
    /*  setState(() {
      _currentStep = result['data'] == 'SUCCESS' ? step : step - 1;
      _loading = false;
    }); */
    return avanza;
  }

  goTo(int step) async {
    bool avanzar = false;
    String title = "", message = "";

    setState(() {
      _loading = true;
      isLoading = true;
    });
    switch (step) {
      case 0:
        {
          setState(() {
            _currentStep = 0;
            _loading = false;
            isLoading = false;
          });
        }
        break;
      case 1:
        {
          avanzar = await validateCurp(step);
          if (avanzar != true) {
            title = "No encontrado";
            message =
                "La C.U.R.P. ingresada no está en nuestros registros de pago, si considera que ésto es un error puede usar la ayuda por whatsapp";
          }
          print("puedo avanzar ? : $avanzar");
        }
        break;
      case 2:
        {
          checkCombos();
          avanzar = true;
        }
        break;
      case 3:
        {
          avanzar = true;
        }
        break;
      case 4:
        {
          avanzar = true;
        }
        break;
      case 5:
        {
          print("cinco");
          avanzar = await procesarFirma();
          //avanzar = true;
        }
        break;
      default:
        {
          print("defaultOption");
        }
        break;
    }
    avanzar == false ? showAlertDialog(context, title, message, "error") : null;

    setState(() {
      _currentStep = avanzar == true ? step : step - 1;
      _loading = false;
    });
  }

  finishForm() async {
    setState(() {
      _loading = true;
    });
    Map<String, dynamic> _alumno = {};
    _alumno['ID_REGISTRO'] = id_registro.toString();
    _alumno['NOMBRE'] = _nombreAlumnoController.text;
    _alumno['APELLIDOS'] = _apellidosAlumnoController.text;
    _alumno['CURP'] = _curpAlumnoController.text;
    _alumno['CORREO'] = _correoAlumnoController.text;
    _alumno['CELULAR'] = _celularAlumnoController.text;
    _alumno['MATRICULA'] = _matriculaAlumnoControler.text;
    _alumno['IDESPECIALIDAD'] = especialidadSeleccionada.toString();
    _alumno['IDSEMESTRE'] = semestreSeleccionado.toString();
    _alumno['IDGRUPO'] = grupoSeleccionado.toString();
    _alumno['IDTURNO'] = turnoSeleccionado.toString();

    var firma = await _signController.toPngBytes();
    var data = Image.memory(firma);

    final finishStep =
        await alumnoService.finish(_alumno, voucher, foto, firma);
    final result = finishStep['message'];
    if (result == "success") {
      setState(() {
        _loading = false;
        lastScreen(context);
      });
    } else {
      setState(() {
        _loading = false;
      });
      final errorHttp = finishStep['data'];
      showAlertDialog(context, "Error",
          "Ocurrió un error al conectarse al servidor, $errorHttp", "error");
    }
  }

  lastScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return LastScreen();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Proceso de Registro'),
        ),
        body: Stack(children: <Widget>[
          _loading == true
              ? showLoading()
              : Stepper(
                  controlsBuilder:
                      (BuildContext context, ControlsDetails details) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.blue,
                          onPressed: details.onStepContinue,
                          child: const Text(
                            'Continuar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        RaisedButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Atrás'),
                        ),
                      ],
                    );
                  },
                  type: StepperType.horizontal,
                  physics: AlwaysScrollableScrollPhysics(),
                  currentStep: _currentStep,
                  onStepContinue: () {
                    next();
                  },
                  onStepCancel: () {
                    cancel();
                  },
                  steps: _mySteps()),
          /* ProgressHUD(
              inAsyncCall: _loading,
              opacity: 0.4,
              child: Center(
                child: Container(
                  width: 0,
                  height: 0,
                ),
              ),) */
        ]));
  }

  List<Step> _mySteps() {
    List<Step> _steps = [
      _validarCurp(),
      _datosAlumno(),
      _datosEscuela(),
      _foto(),
      _firma()
    ];
    return _steps;
  }

  Step _validarCurp() {
    return Step(
      title: new Text(_currentStep == 0 ? "Validar alumno" : ''),
      content: Form(
        key: formKeys[0],
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (value) => validators.validarCurp(value),
              controller: _curpAlumnoController,
              keyboardType: TextInputType.name,
              inputFormatters: [DigitosLimite(18)],
              decoration: InputDecoration(
                  hintText: '18 digitos',
                  helperText: '',
                  labelText: 'C.U.R.P.'),
            ),
          ],
        ),
      ),
      isActive: _currentStep >= 0,
      state: StepState.indexed,
    );
  }

  Step _datosAlumno() {
    return Step(
      title: new Text(_currentStep == 1 ? "Datos del alumno" : ''),
      content: SingleChildScrollView(
        child: Form(
          key: formKeys[1],
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (value) => validators.notEmptyField(value),
                inputFormatters: [TextoMayusculas()],
                controller: _nombreAlumnoController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextFormField(
                validator: (value) => validators.notEmptyField(value),
                inputFormatters: [TextoMayusculas()],
                controller: _apellidosAlumnoController,
                decoration: InputDecoration(labelText: 'Apellidos'),
              ),
              TextFormField(
                validator: (value) =>
                    validators.validateEmail(value), //notEmptyField(value),
                inputFormatters: [TextoMinusculas()],
                controller: _correoAlumnoController,
                decoration: InputDecoration(labelText: 'Correo'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                validator: (value) => validators.notEmptyField(value),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [TextoMayusculas()],
                controller: _celularAlumnoController,
                decoration: InputDecoration(labelText: 'Celular'),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
      isActive: _currentStep >= 1,
      state: StepState.complete,
    );
  }

  Step _datosEscuela() {
    Size size = MediaQuery.of(context).size;
    return Step(
      title: new Text(_currentStep == 2 ? "Datos de la escuela" : ''),
      content: SingleChildScrollView(
        child: Form(
          key: formKeys[2],
          child: Column(
            children: <Widget>[
              TextFormField(
                inputFormatters: [TextoMayusculas()],
                controller: _matriculaAlumnoControler,
                decoration: InputDecoration(
                    labelText: 'Matricula', hintText: '(Opcional)'),
              ),
              Container(
                width: size.width * 8,
                child: DropdownButtonFormField(
                  validator: (value) => validators.selectSelected(value),
                  value: especialidadSeleccionada,
                  onChanged: (newValue) {
                    setState(() {
                      especialidadSeleccionada = newValue;
                    });
                  },
                  items: _especialidades.map((especialidadItem) {
                    return DropdownMenuItem(
                        value: especialidadItem['IDESPECIALIDAD'],
                        child: Text(especialidadItem['ESPECIALIDAD']));
                  }).toList(),
                ),
              ),
              Container(
                width: size.width * 8,
                child: DropdownButtonFormField(
                  validator: (value) => validators.selectSelected(value),
                  value: semestreSeleccionado,
                  onChanged: (newValue) {
                    setState(() {
                      semestreSeleccionado = newValue;
                    });
                  },
                  items: _semestres.map((semestreItem) {
                    return DropdownMenuItem(
                        value: semestreItem['IDSEMESTRE'],
                        child: Text(semestreItem['SEMESTRE']));
                  }).toList(),
                ),
              ),
              Container(
                width: size.width * 8,
                child: DropdownButtonFormField(
                  validator: (value) => validators.selectSelected(value),
                  value: grupoSeleccionado,
                  onChanged: (newValue) {
                    setState(() {
                      grupoSeleccionado = newValue;
                    });
                  },
                  items: _grupos.map((grupoItem) {
                    return DropdownMenuItem(
                        value: grupoItem['IDGRUPO'],
                        child: Text(grupoItem['GRUPO']));
                  }).toList(),
                ),
              ),
              Container(
                width: size.width * 8,
                child: DropdownButtonFormField(
                  validator: (value) => validators.selectSelected(value),
                  value: turnoSeleccionado,
                  onChanged: (newValue) {
                    setState(() {
                      turnoSeleccionado = newValue;
                    });
                  },
                  items: _turnos.map((turnoItem) {
                    return DropdownMenuItem(
                        value: turnoItem['IDTURNO'],
                        child: Text(turnoItem['TURNO']));
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
      isActive: _currentStep >= 2,
      state: StepState.complete,
    );
  }

  Step _foto() {
    return Step(
        isActive: _currentStep >= 3,
        state: StepState.complete,
        title: Text(_currentStep == 3 ? "Fotografía" : ''),
        content: Form(
          key: formKeys[3],
          child: Stack(
            children: <Widget>[
              _mostrarFoto(),
              Positioned(
                bottom: 5,
                right: 5,
                child: MaterialButton(
                    color: Colors.blue,
                    padding: EdgeInsets.all(0),
                    minWidth: 10,
                    onPressed: () {
                      _tomarFoto();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(22)),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(255, 255, 255, 1)),
                          borderRadius: BorderRadius.circular(22)),
                      child: Center(
                          child: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                      )),
                    )),
              ),
            ],
          ),
        ));
  }

  Step _firma() {
    return Step(
        isActive: _currentStep >= 4,
        state: StepState.complete,
        title: Text(_currentStep == 4 ? "Firma" : ''),
        content: Form(
          key: formKeys[4],
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              //SIGNATURE CANVAS
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Signature(
                  controller: _signController,
                  height: 100,
                  backgroundColor: Colors.white,
                ),
              ),
              //OK AND CLEAR BUTTONS
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(207, 216, 220, 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //SHOW EXPORTED IMAGE IN NEW ROUTE
                    /* IconButton(
                      icon: const Icon(Icons.check),
                      color: Colors.blue,
                      onPressed: () async {
                        if (_signController.isNotEmpty) {
                          procesarFirma();
                        }
                      },
                    ), */
                    //CLEAR CANVAS
                    IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.blue,
                      onPressed: () {
                        setState(() => _signController.clear());
                      },
                    ),
                  ],
                ),
              ),
              /* Container(
                height: 300,
                child: Center(
                  child: Text('Big container to test scrolling issues'),
                ),
              ), */
            ],
          ),
        ));
  }

  Widget showLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            backgroundColor: Color.fromRGBO(236, 186, 17, 1),
            valueColor: AlwaysStoppedAnimation(Colors.green),
            strokeWidth: 5,
          )
        ],
      ),
    );
  }

  checkCombos() async {
    if (_especialidades.length < 1) {
      _cargarEspecialidades();
    }
    if (_semestres.length < 1) {
      _cargarSemestres();
    }
    if (_grupos.length < 1) {
      _cargarGrupos();
    }
    if (_turnos.length < 1) {
      _cargarTurnos();
    }
  }

  Future<bool> procesarFirma() async {
    if (_signController.isNotEmpty) {
      var data = await _signController.toPngBytes();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                  child: Container(
                      color: Colors.grey[300], child: Image.memory(data))),
            );
          },
        ),
      );
      return true;
    }
    return false;
  }

  _tomarFoto() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    //foto = await ImagePicker.pickImage(source: ImageSource.camera);
    //
    foto = File(pickedFile.path);

    if (foto != null) {
      //limpieza
    }

    setState(() {
      //foto = File(pickedFile.path);
    });
  }

  Widget _mostrarFoto() {
    if (foto != null) {
      return Center(
        child: Image(
          image: FileImage(foto /* ?? 'assets/img/no-image.png'  */),
          height: 300.0,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset('assets/img/no-image.png');
  }
}
