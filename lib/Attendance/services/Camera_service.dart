import 'package:camera/camera.dart';

class CameraService {
  CameraController? controller;

  Future<void> initialize() async {
    final cameras = await availableCameras();

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    controller = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await controller!.initialize();
  }

  Future<void> dispose() async {
    await controller?.dispose();
  }

  Future<void> startImageStream(Function(CameraImage image) onImage) async {
    if (controller == null) return;

    if (controller!.value.isStreamingImages) return;

    await controller!.startImageStream(onImage);
  }

  Future<void> stopImageStream() async {
    if (controller == null) return;

    if (controller!.value.isStreamingImages) {
      await controller!.stopImageStream();
    }
  }
}
