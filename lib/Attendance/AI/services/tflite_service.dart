import 'package:tflite_flutter/tflite_flutter.dart';

class TfliteService {
  static final TfliteService instance = TfliteService._();

  TfliteService._();

  Interpreter? _interpreter;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('models/mobilefacenet.tflite');

      print("✅ MobileFaceNet Loaded Successfully");
    } catch (e) {
      print("❌ Error Loading Model: $e");
    }
  }

  Interpreter? get interpreter => _interpreter;

  void close() {
    _interpreter?.close();
  }
}
