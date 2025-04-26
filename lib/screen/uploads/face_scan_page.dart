import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FaceScannerPage extends StatefulWidget {
  const FaceScannerPage({super.key});
  static const String routeName = "scan_face_page";

  @override
  State<FaceScannerPage> createState() => _FaceScannerPageState();
}

class _FaceScannerPageState extends State<FaceScannerPage> {
  late CameraController _controller;
  late FaceDetector _faceDetector;
  XFile? _capturedImage;
  String _instruction = "Look up";
  final String _currentTargetInstruction = "Look up";
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
        (camera) => camera.lensDirection == CameraLensDirection.front,
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
            final pitch = face.headEulerAngleX ?? 0; // <-- Fix here
            final roll = face.headEulerAngleZ ?? 0; // <-- And here

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

              case "Look down":
                isAligned = pitch < -7; // Now this will work
                if (!isAligned && _instruction != "Please look down") {
                  _updateInstruction("Please look down");
                }
                break;

              case "Look up":
                isAligned = pitch > 7; // Now this will work
                if (!isAligned && _instruction != "Please look up") {
                  _updateInstruction("Please look up");
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
      if (!mounted) return;
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
                _initializeCamera();
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
              color: Colors.black.withValues(alpha: 0.5),
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

  const FaceGuideOverlay({super.key, required this.isAligned});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size:
            Size.infinite, // This ensures the overlay covers the entire screen
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
    // Step 1: Create a paint for the overlay (outside the face area)
    final overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.7); // Transparent black overlay

    // Step 2: Draw the full screen overlay
    final fullScreenPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Step 3: Define the larger face area with a decreased height
    final faceRect = Rect.fromLTWH(
      size.width * 0.1, // X position of the face area (left) - reduced margin
      size.height *
          0.2, // Y position of the face area (top) - adjusted for better centering
      size.width * 0.8, // Width of the face area - increased width
      size.height * 0.5, // Height of the face area - reduced height
    );
    final facePath = Path()..addOval(faceRect);

    // Step 4: Cut out the face area from the full screen overlay
    final clearFacePath =
        Path.combine(PathOperation.difference, fullScreenPath, facePath);

    // Step 5: Draw the full screen overlay, leaving a clear space for the face
    canvas.drawPath(clearFacePath, overlayPaint);

    // Step 6: Draw the face border (green for aligned, red for misaligned)
    final borderPaint = Paint()
      ..color = isAligned ? Colors.green : Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    // Draw the face border (an oval around the detected face)
    canvas.drawPath(facePath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant FaceShapePainter oldDelegate) {
    return oldDelegate.isAligned != isAligned;
  }
}
