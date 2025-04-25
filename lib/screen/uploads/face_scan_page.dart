import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FaceScannerPage extends StatefulWidget {
  const FaceScannerPage({Key? key}) : super(key: key);
  static const String routeName = "scan_face_page";

  @override
  State<FaceScannerPage> createState() => _FaceScannerPageState();
}

class _FaceScannerPageState extends State<FaceScannerPage> {
  late CameraController _controller;
  late FaceDetector _faceDetector;
  XFile? _capturedImage;
  String _instruction = "Look right";
  String _currentTargetInstruction = "Look right";
  bool _isCameraInitialized = false;
  final bool _isAligned = false;

  @override
  void initState() {
    super.initState();
    _initializeFaceDetector();
    _initializeCamera();
  }

  void _initializeFaceDetector() {
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
        enableClassification: true,
        performanceMode: FaceDetectorMode.fast, // Change this to fast
      ),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _controller.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });

      bool isDetecting = false;
      int lastProcessedTime = 0;

      _controller.startImageStream((CameraImage image) async {
        if (isDetecting) return;

        final currentTime = DateTime.now().millisecondsSinceEpoch;
        if (currentTime - lastProcessedTime < 1000) return;
        lastProcessedTime = currentTime;

        isDetecting = true;

        try {
          // Convert the YUV420 camera image directly to an InputImage
          final camera = _controller.description;
          final rotation = InputImageRotationValue.fromRawValue(
                camera.sensorOrientation,
              ) ??
              InputImageRotation.rotation0deg;

          final WriteBuffer allBytes = WriteBuffer();
          for (final plane in image.planes) {
            allBytes.putUint8List(plane.bytes);
          }

          final bytes = allBytes.done().buffer.asUint8List();

          final inputImage = InputImage.fromBytes(
            bytes: bytes,
            metadata: InputImageMetadata(
              size: Size(image.width.toDouble(), image.height.toDouble()),
              rotation: rotation,
              format: InputImageFormat.nv21, // Change here
              bytesPerRow: image.planes[0].bytesPerRow,
            ),
          );

          final List<Face> faces = await _faceDetector.processImage(inputImage);
          print("Number of faces detected: ${faces.length}");
          int noFaceCount = 0;
          if (faces.isNotEmpty) {
            final face = faces.first;
            final yaw = face.headEulerAngleY ?? 0;
            bool isAligned = false;

            switch (_currentTargetInstruction) {
              case "Look left":
                isAligned = yaw < -7;
                if (!isAligned &&
                    _instruction != "Please look more to your left") {
                  _updateInstruction("Please look more to your left");
                }
                break;

              case "Look right":
                isAligned = yaw > 7;
                if (!isAligned &&
                    _instruction != "Please look more to your right") {
                  _updateInstruction("Please look more to your right");
                }
                break;

              case "Look straight":
                isAligned = yaw.abs() < 7;
                if (!isAligned &&
                    _instruction != "Please look straight ahead") {
                  _updateInstruction("Please look straight ahead");
                }
                break;
            }

            if (isAligned) {
              setState(
                  () => _instruction = "Face aligned! Capturing picture...");
              await _controller.stopImageStream();
              await Future.delayed(const Duration(milliseconds: 300));
              await _takePicture();
            }
          } else {
            noFaceCount++;
            if (noFaceCount >= 3) {
              _updateInstruction("No face detected");
              noFaceCount = 0; // reset again to avoid spamming
            }
          }
        } catch (e) {
          print("Detection error: $e");
        } finally {
          isDetecting = false;
        }
      });
    } catch (e) {
      print('Error initializing camera: $e');
      setState(() {
        _instruction = "Failed to initialize camera.";
      });
    }
  }

// Helper function to concatenate YUV planes into a single byte array
  Uint8List concatenatePlanes(List<Plane> planes) {
    final bytes = <int>[];
    for (var plane in planes) {
      bytes.addAll(plane.bytes);
    }
    return Uint8List.fromList(bytes);
  }

  void _updateInstruction(String message) {
    setState(() {
      _instruction = message;
    });
  }

  Future<void> _takePicture() async {
    try {
      final XFile picture = await _controller.takePicture();
      setState(() {
        _capturedImage = picture;
        _instruction = "Picture captured!";
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Captured Image'),
          content: Image.file(File(_capturedImage!.path)),
          actions: <Widget>[
            TextButton(
              child: const Text('Retake'),
              onPressed: () {
                Navigator.of(context).pop();
                _initializeCamera(); // restart camera
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Face Scanner')),
      body: Stack(
        children: [
          CameraPreview(_controller),
          FaceGuideOverlay(isAligned: _isAligned),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.black.withOpacity(0.5),
              child: Text(
                _instruction,
                style: const TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FaceGuideOverlay extends StatelessWidget {
  final bool isAligned;
  const FaceGuideOverlay({Key? key, required this.isAligned}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(
            color: isAligned ? Colors.green : Colors.red,
            width: 3,
          ),
        ),
      ),
    );
  }
}
