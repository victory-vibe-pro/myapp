import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:project/Attendance/AI/services/tflite_service.dart';
import 'package:project/Attendance/services/face_recognition_Validation_service.dart';

import 'painters/face_painter.dart';
import 'services/input_image_converter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:project/Attendance/services/Camera_service.dart';

import 'services/face_detector_service.dart';
import 'services/capture_service.dart';
import 'dart:io';
// import 'package:camera/camera.dart';
import 'services/recognition_service.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final CameraService _cameraService = CameraService();
  CameraDescription? selectedCamera;
  final FaceDetectorService _faceDetectorService = FaceDetectorService();
  late List<CameraDescription> cameras;
  bool faceDetected = false;

  Color borderColor = Colors.white;

  double borderWidth = 3;

  String statusText = "Looking for Face...";
  bool _isDetecting = false;

  int faceCount = 0;

  List<Face> faces = [];
  final Rect guideRect = Rect.fromLTWH(70, 150, 250, 330);
  Timer? holdTimer;

  bool isHolding = false;

  bool readyForRecognition = false;

  int countdown = 3;

  //capture face varibales
  final CaptureService _captureService = CaptureService();

  XFile? capturedImage;

  bool isCapturing = false;

  //recognizationface initialization
  final RecognitionService _recognitionService = RecognitionService();

  @override
  Future<void> initState() async {
    await TfliteService.instance.loadModel();

    super.initState();
    initializeCamera();
  }
  //caputure face related Future<void> captureFace() async {

  Future<void> captureFace() async {
    if (isCapturing) return;
    if (capturedImage != null) return;

    isCapturing = true;

    try {
      capturedImage = await _captureService.capture(_cameraService.controller!);
      final faces = await _recognitionService.detectFace(capturedImage!.path);
      if (faces.isNotEmpty) {
        await _recognitionService.cropFace(
          imagePath: capturedImage!.path,
          face: faces.first,
        );

        print("Face Cropped Successfully");
      }
      print("Faces Found : ${faces.length}");

      print("Image Saved : ${capturedImage!.path}");
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        if (faces.isNotEmpty) {
          statusText = "Face Detected";
        } else {
          statusText = "No Face Found";
        }
        capturedImage = null;
        readyForRecognition = false;
        isHolding = false;
        countdown = 3;
        statusText = "Looking for Face...";
      });
    } catch (e) {
      print(e);
    }

    isCapturing = false;
  }

  Future<void> initialize() async {
    await _cameraService.initialize();
    await TfliteService.instance.loadModel();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraService.controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraService.controller!.initialize();
    await TfliteService.instance.loadModel();
    selectedCamera = _cameraService.controller!.description;

    await _cameraService.startImageStream((CameraImage image) async {
      print("Image Format: ${image.format.raw}");
      print("Planes: ${image.planes.length}");

      if (_isDetecting) return;

      _isDetecting = true;

      try {
        final inputImage = InputImageConverter.convert(image, selectedCamera!);

        if (inputImage != null) {
          faces = await _faceDetectorService.detectFaces(inputImage);

          faceCount = faces.length;
          if (faceCount > 0) {
            borderColor = Colors.green;

            borderWidth = 5;

            if (faces.isNotEmpty) {
              final faceRect = faces.first.boundingBox;

              if (FaceValidationService.isFaceInsideGuideBox(
                faceRect: faceRect,

                guideRect: guideRect,
              )) {
                statusText = "Hold Still...";

                startHoldTimer();

                borderColor = Colors.green;

                faceDetected = true;
              } else {
                stopHoldTimer();

                statusText = "Center your face";

                borderColor = Colors.white;

                faceDetected = false;
              }
            }

            statusText = "Hold Still...";

            startHoldTimer();
          } else {
            borderColor = Colors.white;

            borderWidth = 3;

            faceDetected = false;

            statusText = "Looking for Face...";
          }

          print("Faces Detected : $faceCount");

          if (mounted) {
            setState(() {});
          }
        }
      } catch (e) {
        print(e);
      }

      _isDetecting = false;
    });

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _recognitionService.dispose();
    _faceDetectorService.dispose();
    TfliteService.instance.close();
    super.dispose();
  }

  void startHoldTimer() {
    if (isHolding) return;

    isHolding = true;

    countdown = 3;

    holdTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      setState(() {
        countdown--;
      });

      if (countdown == 0) {
        timer.cancel();

        readyForRecognition = true;

        statusText = "Capturing...";

        await captureFace();
      }
    });
  }

  void stopHoldTimer() {
    holdTimer?.cancel();

    isHolding = false;

    readyForRecognition = false;

    countdown = 3;
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraService.controller == null ||
        !_cameraService.controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Face Attendance"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: capturedImage != null
                ? Image.file(File(capturedImage!.path), fit: BoxFit.cover)
                : CameraPreview(_cameraService.controller!),
          ),

          Positioned.fill(
            child: CustomPaint(painter: FacePainter(faces: faces)),
          ),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOut,

              width: 250,
              height: 330,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),

                border: Border.all(color: borderColor, width: borderWidth),

                boxShadow: [
                  if (faceDetected)
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.7),
                      blurRadius: 25,
                      spreadRadius: 4,
                    ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,

            child: Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Text(
                readyForRecognition
                    ? "Recognizing..."
                    : isHolding
                    ? "Hold Still... $countdown"
                    : statusText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
