import 'package:flutter/material.dart';

class FaceValidationService {
  static bool isFaceInsideGuideBox({
    required Rect faceRect,
    required Rect guideRect,
  }) {
    return guideRect.contains(faceRect.topLeft) &&
        guideRect.contains(faceRect.bottomRight);
  }
}
