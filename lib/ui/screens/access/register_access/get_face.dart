/* //import 'package:appfacedetector/Utils/FaceDetectorPainter.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/material.dart';

import '../../../res/face_scanner.dart';

class GetFace extends StatefulWidget {
  @override
  _GetFaceState createState() => _GetFaceState();
}

class _GetFaceState extends State<GetFace> {
  CameraController cameraController;
  CameraDescription cameraDescription;
  CameraLensDirection cameraLensDirection = CameraLensDirection.front;
  // FaceDetector faceDetector;
  bool isWorking = false;
  Size size;
  List<Face> facesList;
  FaceScanner faceScanner = FaceScanner();

  initCamera() async {
    cameraDescription = await faceScanner.getCamera(cameraLensDirection);

    cameraController = CameraController(
        cameraDescription, ResolutionPreset.medium,
        enableAudio: false);

    /*faceDetector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(
        ));*/

    // final options = FaceDetectorOptions();
    //  faceDetector = FaceDetector(options: options);

    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }

      Future.delayed(Duration(milliseconds: 200));

      cameraController.startImageStream((imageFromStream) {
        if (!isWorking) {
          isWorking = true;

          //implementar FaceDetection
          performDetectionOnStreamFrame(imageFromStream);
        }
      });
    });
  }

  dynamic scannResult;

  performDetectionOnStreamFrame(CameraImage imageFromStream) {
    faceScanner
        .detect(
            image: imageFromStream,
            //  detectInImage: faceDetector.processImage,
            imageRotation: cameraDescription.sensorOrientation)
        .then((dynamic result) {
      setState(() {
        scannResult = result;
      });
    }).whenComplete(() {
      isWorking = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController?.dispose();
    //  faceDetector.close();
  }

  Widget buildResult() {
    if (scannResult == null ||
        cameraController == null ||
        !cameraController.value.isInitialized) {
      return Container();
    }

    final Size imageSize = Size(cameraController.value.previewSize.height,
        cameraController.value.previewSize.width);

    // customPainter
    CustomPainter customPainter =
        FaceDetectorPainter(imageSize, scannResult, cameraLensDirection);

    return CustomPaint(
      painter: customPainter,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackWidgetChildren = [];
    size = MediaQuery.of(context).size;

    // add streaming camera
    if (cameraController != null) {
      stackWidgetChildren.add(Positioned(
          top: 30,
          left: 0,
          width: size.width,
          height: size.height - 250,
          child: Container(
            child: (cameraController.value.isInitialized)
                ? AspectRatio(
                    aspectRatio: cameraController.value.aspectRatio,
                    child: CameraPreview(cameraController))
                : Container(),
          )));
    }

    // toggle camera

    stackWidgetChildren.add(Positioned(
        top: 30,
        left: 0.0,
        width: size.width,
        height: size.height - 250,
        child: buildResult()));

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 0),
        color: Colors.grey,
        child: Stack(
          children: stackWidgetChildren,
        ),
      ),
    );
  }
}

class FaceDetectorPainter extends CustomPainter {
  final Size absulteImageSize;
  final List<Face> faces;
  CameraLensDirection cameraLensDirection;

  FaceDetectorPainter(
      this.absulteImageSize, this.faces, this.cameraLensDirection);

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absulteImageSize.width;
    final double scaleY = size.height / absulteImageSize.height;
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.greenAccent;

    for (Face face in faces) {
      canvas.drawRect(
          Rect.fromLTRB(
              cameraLensDirection == CameraLensDirection.back
                  ? face.boundingBox.left * scaleX
                  : (absulteImageSize.width - face.boundingBox.right) * scaleX,
              face.boundingBox.top * scaleY,
              cameraLensDirection == CameraLensDirection.back
                  ? face.boundingBox.right * scaleX
                  : (absulteImageSize.width - face.boundingBox.left) * scaleX,
              face.boundingBox.bottom * scaleY),
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant FaceDetectorPainter oldDelegate) {
    return oldDelegate.absulteImageSize != absulteImageSize ||
        oldDelegate.faces != faces;
  }
}
 */