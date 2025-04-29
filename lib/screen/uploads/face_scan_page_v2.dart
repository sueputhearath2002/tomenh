import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:tomnenh/screen/uploads/face_from_capture.dart';

class FaceScannerPageV2 extends StatefulWidget {
  const FaceScannerPageV2({super.key});
  static const String routeName = "scan_face_page_v2";

  @override
  State<FaceScannerPageV2> createState() => _FaceScannerPageV2State();
}

class _FaceScannerPageV2State extends State<FaceScannerPageV2> {
  late CameraController _controller;
  late FaceDetector _faceDetector;
  bool _isCameraInitialized = false;
  bool _isDetecting = false;
  int _lastProcessedTime = 0;
  int _currentInstructionIndex = 0;
  bool _isAligned = false;
  final List<XFile> _capturedImages = [];

  final List<String> _instructions = [
    "Look left",
    "Look right",
    "Look straight",
    "Look down",
    "Look up",
    "Tilt head left",
    "Tilt head right",
    "Slightly turn left",
    "Slightly turn right",
    "Raise your eyebrows",
    "Close your eyes",
    "Smile",
    "Open your mouth",
  ];

  String _instructionText = "Initializing...";

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
        enableTracking: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
        _instructionText = _instructions[_currentInstructionIndex];
      });

      // Start the camera stream (still mirrored by default)
      await _controller.startImageStream(_processCameraImage);
    } catch (e) {
      print('Error initializing camera: $e');
      setState(() {
        _instructionText = "Failed to initialize camera.";
      });
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (_isDetecting) return;

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime - _lastProcessedTime < 1000) return; // process every 1s
    _lastProcessedTime = currentTime;

    _isDetecting = true;

    try {
      final camera = _controller.description;
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();
      InputImageRotation rotation;
      switch (_controller.description.sensorOrientation) {
        case 0:
          rotation = InputImageRotation.rotation0deg;
          break;
        case 90:
          rotation = InputImageRotation.rotation90deg;
          break;
        case 180:
          rotation = InputImageRotation.rotation180deg;
          break;
        case 270:
          rotation = InputImageRotation.rotation270deg;
          break;
        default:
          rotation = InputImageRotation.rotation0deg;
          break;
      }

      // Create InputImage
      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.nv21, // Change here
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      // Perform face detection
      final List<Face> faces = await _faceDetector.processImage(inputImage);
      print("Faces detected: ${faces.length}");
      int failedAlignments = 0;
      const int maxFailedAttempts = 3;

      if (faces.isNotEmpty) {
        final face = faces.first;

        final yaw = face.headEulerAngleY ?? 0;
        final pitch = face.headEulerAngleX ?? 0;
        final roll = face.headEulerAngleZ ?? 0;
        final smileProb = face.smilingProbability ?? 0;
        final leftEyeOpenProb = face.leftEyeOpenProbability ?? 1;
        final rightEyeOpenProb = face.rightEyeOpenProbability ?? 1;

        _isAligned = _checkAlignment(
          _instructions[_currentInstructionIndex],
          yaw,
          pitch,
          roll,
          smileProb,
          leftEyeOpenProb,
          rightEyeOpenProb,
        );

        if (_isAligned) {
          failedAlignments = 0; // <== reset
          await _captureAndProceed();
        } else {
          failedAlignments++;
          if (failedAlignments >= maxFailedAttempts) {
            if (mounted) {
              setState(() {
                _instructionText = "Please align your face properly.";
              });
            }
          }
        }
      }
    } catch (e) {
      print("Error during face detection: $e");
    } finally {
      _isDetecting = false;
    }
  }

  bool _checkAlignment(
    String instruction,
    double yaw,
    double pitch,
    double roll,
    double smileProb,
    double leftEyeOpenProb,
    double rightEyeOpenProb,
  ) {
    switch (instruction) {
      case "Look left":
        return yaw > 15;
      case "Look right":
        return yaw < -15;
      case "Look straight":
        return yaw.abs() < 10 && pitch.abs() < 10;
      case "Look down":
        return pitch < -15;
      case "Look up":
        return pitch > 15;
      case "Tilt head left":
        return roll > 15;
      case "Tilt head right":
        return roll < -15;
      case "Slightly turn left":
        return yaw > 5 && yaw < 15;
      case "Slightly turn right":
        return yaw < -5 && yaw > -15;
      case "Raise your eyebrows":
        return pitch < -5;
      case "Close your eyes":
        return leftEyeOpenProb < 0.3 && rightEyeOpenProb < 0.3;
      case "Smile":
        return smileProb > 0.6;
      case "Open your mouth":
        return smileProb > 0.3;
      default:
        return false;
    }
  }

  Future<void> _captureAndProceed() async {
    try {
      await _controller.stopImageStream();
      await Future.delayed(const Duration(milliseconds: 300));

      final XFile picture = await _controller.takePicture();
      _capturedImages.add(picture);

      if (_currentInstructionIndex + 1 < _instructions.length) {
        setState(() {
          _currentInstructionIndex++;
          _instructionText = _instructions[_currentInstructionIndex];
        });
        await _controller.startImageStream(_processCameraImage);
      } else {
        _showCapturedImages();
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  void _showCapturedImages() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CapturedImagesPage(images: _capturedImages),
      ),
    );
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Face Scanner')),
      body: Stack(
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(pi), // Flipping horizontally
            child: CameraPreview(_controller), // Your camera preview widget
          ),
          FaceGuideOverlay(isAligned: _isAligned),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.black.withOpacity(0.5),
              child: Text(
                _instructionText,
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

  const FaceGuideOverlay({super.key, required this.isAligned});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size.infinite,
        painter: FaceShapePainter(isAligned: isAligned),
      ),
    );
  }
}

class FaceShapePainter extends CustomPainter {
  final bool isAligned;

  FaceShapePainter({required this.isAligned});

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.7);

    final fullScreenPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final faceRect = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.2,
      size.width * 0.8,
      size.height * 0.5,
    );
    final facePath = Path()..addOval(faceRect);

    final clearFacePath =
        Path.combine(PathOperation.difference, fullScreenPath, facePath);

    canvas.drawPath(clearFacePath, overlayPaint);

    final borderPaint = Paint()
      ..color = isAligned ? Colors.green : Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawPath(facePath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant FaceShapePainter oldDelegate) {
    return oldDelegate.isAligned != isAligned;
  }
}
