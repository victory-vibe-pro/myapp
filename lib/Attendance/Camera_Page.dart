import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'services/input_image_converter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:project/Attendance/services/Camera_service.dart';

import 'services/face_detector_service.dart';

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

  bool _isProcessing = false;
  bool _isDetecting = false;

  int faceCount = 0;

  List<Face> faces = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await _cameraService.initialize();
    selectedCamera = _cameraService.controller!.description;
    await _cameraService.startImageStream((image) async {
      if (_isDetecting) return;

      _isDetecting = true;

      // ML Kit will go here

      _isDetecting = false;
    });
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
    await _cameraService.startImageStream((CameraImage image) async {
      if (_isDetecting) return;

      _isDetecting = true;

      try {
        final inputImage = InputImageConverter.convert(image, selectedCamera!);

        if (inputImage != null) {
          faces = await _faceDetectorService.detectFaces(inputImage);

          faceCount = faces.length;

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

    _faceDetectorService.dispose();
    super.dispose();
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
          Positioned.fill(child: CameraPreview(_cameraService.controller!)),

          Center(
            child: Container(
              width: 250,
              height: 330,

              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 4),
                borderRadius: BorderRadius.circular(20),
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

              child: const Text(
                "Faces Detected : $faceCount",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
