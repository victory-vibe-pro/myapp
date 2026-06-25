import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class InputImageConverter {
  static InputImage? convert(CameraImage image, CameraDescription camera) {
    final rotation = InputImageRotationValue.fromRawValue(
      camera.sensorOrientation,
    );

    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    if (format == null) return null;

    if (image.planes.isEmpty) return null;

    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,

      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),

        rotation: rotation,

        format: format,

        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }
}
