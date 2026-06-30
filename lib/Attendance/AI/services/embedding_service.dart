//This converts the image into the normalized format MobileFaceNet expects.
import 'package:image/image.dart' as img;

class EmbeddingService {
  List<List<List<double>>> preprocess(img.Image image) {
    final output = List.generate(
      112,
      (y) => List.generate(112, (x) {
        final pixel = image.getPixel(x, y);

        return [
          (pixel.r - 127.5) / 127.5,

          (pixel.g - 127.5) / 127.5,

          (pixel.b - 127.5) / 127.5,
        ];
      }),
    );

    return output;
  }
}
