/* import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class FaceScanner {
  FaceDetector faceDetector;

  FaceScanner() {
    final options = FaceDetectorOptions(
        enableClassification: true,
        minFaceSize: 0.1,
        performanceMode: FaceDetectorMode.fast);
    faceDetector = FaceDetector(options: options);
  }

  Future<CameraDescription> getCamera(
      CameraLensDirection cameraLensDirection) async {
    return await availableCameras().then((List<CameraDescription> cameras) =>
        cameras.firstWhere((CameraDescription cameraDescription) =>
            cameraDescription.lensDirection == cameraLensDirection));
  }

  Future<dynamic> detect({CameraImage image, int imageRotation}) async {
    return faceDetector.processImage(InputImage.fromBytes(
        bytes: _concatenatePlanes(image.planes),
        inputImageData:
            _buildMetadata(image, rotationValToImageRotation(imageRotation))));
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();

    for (Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  InputImageData _buildMetadata(
      CameraImage image, InputImageRotation imageRotation) {
    return InputImageData(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        inputImageFormat: InputImageFormatValue.fromRawValue(image.format.raw),
        imageRotation: imageRotation,
        planeData: image.planes.map((Plane plane) {
          return InputImagePlaneMetadata(
              bytesPerRow: plane.bytesPerRow,
              height: plane.height,
              width: plane.width);
        }).toList());
  }

  static rotationValToImageRotation(int rotation) {
    switch (rotation) {
      case 0:
        return InputImageRotation.rotation0deg; //. ImageRotation.rotation0;
      case 90:
        return InputImageRotation.rotation90deg; // ImageRotation.rotation90;
      case 180:
        return InputImageRotation.rotation180deg; // ImageRotation.rotation180;
      default:
        assert(rotation == 270);
        return InputImageRotation.rotation270deg; //ImageRotation.rotation270;
    }
  }
}
 */