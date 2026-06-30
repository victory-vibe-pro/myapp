import 'package:camera/camera.dart';

class CaptureService {
  Future<XFile> capture(CameraController controller) async {
    if (!controller.value.isInitialized) {
      throw Exception("Camera is not initialized");
    }

    if (controller.value.isTakingPicture) {
      throw Exception("Camera is already capturing");
    }

    return await controller.takePicture();
  }
}
