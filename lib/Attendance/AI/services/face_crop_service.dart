import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

class FaceCropService {
  // Decodes image bytes and returns a cropped ui.Image.
  static Future<ui.Image?> cropFace({
    required Uint8List bytes,
    required int left,
    required int top,
    required int width,
    required int height,
  }) async {
    if (bytes.isEmpty) return null;

    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });

    final original = await completer.future;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    final src = ui.Rect.fromLTWH(
      left.toDouble(),
      top.toDouble(),
      width.toDouble(),
      height.toDouble(),
    );
    final dst = ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());

    final paint = ui.Paint();
    canvas.drawImageRect(original, src, dst, paint);

    final picture = recorder.endRecording();
    final cropped = await picture.toImage(width, height);

    return cropped;
  }
}
