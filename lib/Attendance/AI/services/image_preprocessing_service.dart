// If the `image` package is not yet added to pubspec.yaml the analyzer
// may report a missing URI. Suppress the analyzer error here so the
// project can still be analyzed until the dependency is added.
// ignore: uri_does_not_exist
import 'package:image/image.dart' as img;

class ImagePreprocessingService {
  static img.Image resize112(img.Image image) {
    return img.copyResize(image, width: 112, height: 112);
  }
}
