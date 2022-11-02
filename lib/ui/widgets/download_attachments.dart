import 'dart:convert';
import 'dart:io';

import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final school = AppConstants.fsCollectionName;

class DownloadAttchments extends StatefulWidget {
  final String messageId;
  final BuildContext parentContext;
  const DownloadAttchments(
      {Key key, @required this.parentContext, @required this.messageId})
      : super(key: key);

  @override
  _DownloadAttchmentsState createState() => _DownloadAttchmentsState();
}

class _DownloadAttchmentsState extends State<DownloadAttchments> {
  String fileName;
  bool downloading = false;
  final Dio _dio = Dio();
  String progress = "-";
  String messageId;
  String fileUrl;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    messageId = widget.messageId;
    fileName = "$school-adjunto-$messageId.zip";
    fileUrl =
        "https://api.escuelas.infon.mx/public/uploads/$school/attachments/zips/$fileName";

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/launch');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);

    _download();
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      /* return await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);*/
      return await DownloadsPathProvider.downloadsDirectory;
    }
    return await getApplicationDocumentsDirectory();
  }

  Future<bool> _requestPermissions() async {
    var isDenied = await Permission.storage.isDenied;
    var permissionStatus;
    if (isDenied) {
      permissionStatus = await Permission.storage.request();
      //permission = await Permission.storage.isDenied;
    } else {
      permissionStatus = PermissionStatus.granted;
    }
    return permissionStatus == PermissionStatus.granted;
  }

  Future<void> _download() async {
    final dir = await _getDownloadDirectory();
    print(dir);
    final isPermissionStatusGranted = await _requestPermissions();
    var uniqueKey = UniqueKey(); // generate unique key
    var uniqueId = uniqueKey.toString();
    if (isPermissionStatusGranted) {
      final savePath = path.join(dir.path, "$school-adjuntos-$uniqueId.zip");
      await _startDownload(savePath);
    } else {
      // handle the scenario when user declines the permissions
    }
    // download
  }

  Future<void> _startDownload(String savePath) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(fileUrl, savePath,
          onReceiveProgress: _onReceiveProgress);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      print(ex.toString());
      result['error'] = ex.toString();
    } finally {
      Navigator.pop(widget.parentContext);
      await _showNotification(result);
    }
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        progress = (received / total * 100).toStringAsFixed(0) + "%";
      });
    }
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails('channel id', 'channel name',
        priority: Priority.high, importance: Importance.max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Descarga completa' : 'Descarga fállida',
        isSuccess
            ? '$fileName guardado en Descargas!'
            : 'Ocurrió un error mientras se descargaba el archivo.',
        platform,
        payload: json);
  }

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);
    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Text('Progreso de descarga:',
            style: TextStyle(color: Colors.black87, fontSize: 18)),
        SizedBox(
          height: 10,
        ),
        Text(
          progress,
          style: TextStyle(fontSize: 32, color: Colors.black38),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
