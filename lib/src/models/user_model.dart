import 'package:cloud_firestore/cloud_firestore.dart';

class Registration {
  String id;
  String name;
  String surnames;
  String curp;
  String email;
  String cellphone;
  String registrationCode;
  String career;
  String grade;
  String group;
  String turn;
  String sex;
  String password;
  String fotoUsuarioDrive;
  Timestamp fecha_registro;
  int idbio;
  String qrDrive;
  String firmaDrive;
  List devices;
  int maxDevicesAllowed;
  String accessMethod;

  Registration(
      {this.id,
      this.name,
      this.surnames,
      this.curp,
      this.email,
      this.cellphone,
      this.registrationCode,
      this.career,
      this.grade,
      this.group,
      this.turn,
      this.sex,
      this.password,
      this.fotoUsuarioDrive,
      this.idbio,
      this.qrDrive,
      this.firmaDrive,
      this.fecha_registro,
      this.maxDevicesAllowed,
      this.devices,
      this.accessMethod});

  factory Registration.fromJson(Map<String, dynamic> json) => Registration(
        id: json["id"],
        name: json["nombres"],
        surnames: json["apellidos"],
        curp: json["curp"],
        email: json["correo"],
        cellphone: json["celular"],
        registrationCode: json["matricula"],
        career: json["carrera"],
        grade: json["grado"],
        group: json["grupo"],
        turn: json["turno"],
        sex: json["sexo"],
        password: json["password"],
        fotoUsuarioDrive: json["foto_usuario_drive"],
        idbio: json["idbio"] is int ? json["idbio"] : int.parse(json["idbio"]),
        qrDrive: json["qr_drive"],
        firmaDrive: json["firma_drive"],
        fecha_registro: json["fecha_registro"],
        devices: json["devices"] ?? [],
        maxDevicesAllowed: json["max_devices_allowed"] ?? 3,
      );

  @override
  String toString() {
    var strOutput =
        ''' id $id 
            name: $name  
            surnames $surnames   
            curp: $curp  
            email: $email  
            cellphone: $cellphone   
            registrationCode: $registrationCode  
            carrera: $career 
            grade: $grade  
            group: $group  
            turn: $turn   
            sex: $sex   
            password: $password  
            max devices allowed: $maxDevicesAllowed 
            devices: ${devices.toString()},
            idbio: $idbio
              ''';
    return strOutput;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombres": name,
        "apellidos": surnames,
        "curp": curp,
        "correo": email,
        "celular": cellphone,
        "matricula": registrationCode,
        "carrera": career,
        "grado": grade,
        "grupo": group,
        "turno": turn,
        "sexo": sex,
        "password": password,
        "fotoDriveId": fotoUsuarioDrive,
        "idbio": idbio,
        "qrDrive": qrDrive,
        "firmaDrive": firmaDrive,
        "devices": devices,
        "fecha_registro": fecha_registro,
        "devices_max": maxDevicesAllowed,
      };
}
