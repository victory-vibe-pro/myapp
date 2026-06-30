import 'package:image/image.dart' as img;

class ImageService {
  static img.Image resize(img.Image image) {
    return img.copyResize(image, width: 112, height: 112);
  }
}
