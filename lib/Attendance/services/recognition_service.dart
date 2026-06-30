import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

class RecognitionService {
  final FaceDetector detector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
      enableLandmarks: true,
      enableClassification: true,
      enableContours: false,
      enableTracking: true,
    ),
  );

  Future<List<Face>> detectFace(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);

    return await detector.processImage(inputImage);
  }

  Future<void> dispose() async {
    await detector.close();
  }

  Future<img.Image?> cropFace({
    required String imagePath,
    required Face face,
  }) async {
    final bytes = await File(imagePath).readAsBytes();

    final original = img.decodeImage(bytes);

    if (original == null) return null;

    final rect = face.boundingBox;

    return img.copyCrop(
      original,
      x: rect.left.toInt(),
      y: rect.top.toInt(),
      width: rect.width.toInt(),
      height: rect.height.toInt(),
    );
  }
}
