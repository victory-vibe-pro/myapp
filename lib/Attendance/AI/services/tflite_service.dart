import 'package:tflite_flutter/tflite_flutter.dart';

class TfliteService {
  static final TfliteService instance = TfliteService._();

  TfliteService._();

  Interpreter? _interpreter;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('models/mobilefacenet.tflite');

      print("✅ MobileFaceNet Loaded");
      print("Input Shape : ${_interpreter!.getInputTensor(0).shape}");
      print("Output Shape : ${_interpreter!.getOutputTensor(0).shape}");
    } catch (e) {
      print(e);
    }
  }

  Interpreter get interpreter => _interpreter!;

  void close() {
    _interpreter?.close();
  }
}
