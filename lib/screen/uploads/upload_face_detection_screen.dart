import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:tomnenh/helper/helper.dart';
import 'package:tomnenh/screen/uploads/upload_cubit.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/app_bar_custom_simple.dart'
    show AppbarCustomSimple;
import 'package:tomnenh/widget/elevated_btn_cus.dart';
import 'package:tomnenh/widget/text_widget.dart';
import 'package:tomnenh/widget/upload_image.dart';

class UploadFaceDetectionScreen extends StatefulWidget {
  const UploadFaceDetectionScreen({super.key});
  static const String routeName = "face_detection";

  @override
  State<UploadFaceDetectionScreen> createState() =>
      _UploadFaceDetectionScreenState();
}

class _UploadFaceDetectionScreenState extends State<UploadFaceDetectionScreen> {
  File? _image;
  ui.Image? _displayImage;
  List<Face> _detectedFaces = [];
  String? _predictedLabel;
  tfl.Interpreter? _interpreter;
  List<String> _labels = [];
  final ImagePicker _picker = ImagePicker();
  final faceDetector = GoogleMlKit.vision.faceDetector();
  final screenCubit = UploadCubit();
  List<String> listLabels = [];

  @override
  void initState() {
    super.initState();
    _loadModel();
    _loadLabels();
  }

  Future<void> checkAttendance() async {
    final names = listLabels.map((e) => e.split(' (').first).toList();
    print("==========================listUserName ==============${names}");
    final result = await screenCubit.checkAttendance(names);
    if (result) {
      Helper.showMessage(msg: "Attendance submitted successfully!");
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> _loadModel() async {
    try {
      File? tLifeFile = await Helper.getLocalModelFile('face_detection.tflite');
      print("===========file: ${tLifeFile?.path}");
      if (tLifeFile != null) {
        final exists = await tLifeFile.exists();
        print("File exists: $exists");
        _interpreter = await tfl.Interpreter.fromFile(tLifeFile);
        print("Model loaded!");
      } else {
        print("Model not found. Please download it first.");
      }
    } catch (e) {
      debugPrint("Error loading model: $e");
    }
  }

  Future<void> _loadLabels() async {
    try {
      File? labelFile = await Helper.getLocalModelFile('labels.txt');
      if (labelFile != null && await labelFile.exists()) {
        String labelData = await labelFile.readAsString();
        setState(() {
          _labels =
              labelData.split("\n").where((label) => label.isNotEmpty).toList();
        });
      } else {
        debugPrint("Label file not found.");
      }
    } catch (e) {
      debugPrint("Error loading labels: $e");
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() => _image = imageFile);
      listLabels.clear();
      _predictImage(imageFile);
    }
  }

  Future<void> _predictImage(File image) async {
    if (_interpreter == null || _labels.isEmpty) {
      setState(() {
        _predictedLabel = "Model or labels not loaded.";
        _displayImage = null;
      });
      return;
    }

    _detectedFaces =
        await faceDetector.processImage(InputImage.fromFile(image));
    print("Number of faces detected: ${_detectedFaces.length}");

    if (_detectedFaces.isEmpty) {
      setState(() {
        _predictedLabel = "No faces detected";
        _displayImage = null;
      });
      return;
    }

    listLabels.clear();
    List<String> detectedLabels = [];
    Set<String> usedNames = {}; // To prevent duplicate predictions

    for (int i = 0; i < _detectedFaces.length; i++) {
      final face = _detectedFaces[i];
      final croppedFace = await _cropFace(image, face);

      final input = await _processImage(croppedFace);
      final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));

      _interpreter?.run(input, output);

      final scores = output[0];
      print("Scores for face $i: $scores");

      List<MapEntry<String, double>> predictions = [];

      for (int j = 0; j < scores.length; j++) {
        if (scores[j] > 0.001) {
          final name = _labels[j].replaceAll('pins_', '');
          if (!usedNames.contains(name)) {
            predictions.add(MapEntry(name, scores[j]));
          }
        }
      }

      predictions.sort((a, b) => b.value.compareTo(a.value));

      if (predictions.isNotEmpty) {
        final bestPred = predictions.first;
        usedNames.add(bestPred.key);
        detectedLabels.add(
            "${bestPred.key} (${(bestPred.value * 100).toStringAsFixed(1)}%)");

        print("Face $i predictions:");
        for (var pred in predictions.take(3)) {
          print("  ${pred.key}: ${(pred.value * 100).toStringAsFixed(1)}%");
        }
      }
    }

    final imageBytes = await image.readAsBytes();
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();

    setState(() {
      _displayImage = frame.image;
      _predictedLabel = detectedLabels.isEmpty
          ? "No faces confidently detected"
          : detectedLabels.join("\n");
      listLabels.clear();
      listLabels.addAll(detectedLabels);
    });

    print("Number of predictions: ${detectedLabels.length}");
    print("Final predictions: $detectedLabels");
  }

  Future<File> _cropFace(File image, Face face) async {
    final Uint8List imageData = await image.readAsBytes();
    img.Image? rawImage = img.decodeImage(imageData);
    if (rawImage == null) throw Exception("Error decoding image");

    final rect = face.boundingBox;

    int x = rect.left.toInt().clamp(0, rawImage.width - 1);
    int y = rect.top.toInt().clamp(0, rawImage.height - 1);
    int width = rect.width.toInt().clamp(1, rawImage.width - x);
    int height = rect.height.toInt().clamp(1, rawImage.height - y);

    img.Image cropped =
        img.copyCrop(rawImage, x: x, y: y, width: width, height: height);

    final tempPath =
        '${(await getTemporaryDirectory()).path}/cropped_face_${DateTime.now().millisecondsSinceEpoch}.png';
    return File(tempPath)..writeAsBytesSync(img.encodePng(cropped));
  }

  /// Process the image into 224x224 format and normalize for model input
  Future<List<List<List<List<double>>>>> _processImage(File image) async {
    final Uint8List imageData = await image.readAsBytes();
    img.Image? rawImage = img.decodeImage(imageData);
    if (rawImage == null) throw Exception("Error decoding image");

    // Resize image to model input size
    img.Image resizedImage = img.copyResize(rawImage, width: 224, height: 224);

    // Normalize pixel values to [0, 1] — adjust depending on your model
    List<List<List<double>>> inputImage = List.generate(
      224,
      (y) => List.generate(
        224,
        (x) {
          final pixel = resizedImage.getPixel(x, y);
          return [
            pixel.r / 255.0,
            pixel.g / 255.0,
            pixel.b / 255.0,
          ];
        },
      ),
    );

    return [inputImage]; // model expects 4D: [1, 224, 224, 3]
  }

  // ==================================================old===

  // Future<void> _predictImage(File image) async {
  //   if (_interpreter == null || _labels.isEmpty) {
  //     setState(() {
  //       _predictedLabel = "Model or labels not loaded.";
  //       _displayImage = null;
  //     });
  //     return;
  //   }
  //
  //   _detectedFaces =
  //       await faceDetector.processImage(InputImage.fromFile(image));
  //   print("Number of faces detected: ${_detectedFaces.length}");
  //
  //   if (_detectedFaces.isEmpty) {
  //     setState(() {
  //       _predictedLabel = "No faces detected";
  //       _displayImage = null;
  //     });
  //     return;
  //   }
  //
  //   listLabels.clear();
  //   List<String> detectedLabels = [];
  //   Set<String> usedNames = {}; // Track used names
  //
  //   // Process each face separately
  //   for (int i = 0; i < _detectedFaces.length; i++) {
  //     final face = _detectedFaces[i];
  //     final croppedFace = await _cropFace(image, face);
  //     final input = await _processImage(croppedFace);
  //     final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));
  //
  //     _interpreter?.run(input, output);
  //     final scores = output[0];
  //     print("Scores for face $i: $scores");
  //
  //     // Get all predictions above threshold for this face
  //     List<MapEntry<String, double>> predictions = [];
  //     for (int j = 0; j < scores.length; j++) {
  //       if (scores[j] > 0.03) {
  //         // Lower threshold to see more candidates
  //         final name = _labels[j].replaceAll('pins_', '');
  //         if (!usedNames.contains(name)) {
  //           // Only consider unused names
  //           predictions.add(MapEntry(name, scores[j]));
  //         }
  //       }
  //     }
  //
  //     // Sort predictions by confidence
  //     predictions.sort((a, b) => b.value.compareTo(a.value));
  //
  //     // Take best unused prediction
  //     if (predictions.isNotEmpty) {
  //       final bestPred = predictions.first;
  //       usedNames.add(bestPred.key); // Mark name as used
  //       detectedLabels.add(
  //           "${bestPred.key} (${(bestPred.value * 100).toStringAsFixed(1)}%)");
  //
  //       // Debug print all considered predictions for this face
  //       print("Face $i predictions:");
  //       for (var pred in predictions.take(3)) {
  //         print("  ${pred.key}: ${(pred.value * 100).toStringAsFixed(1)}%");
  //       }
  //     }
  //   }
  //
  //   final imageBytes = await image.readAsBytes();
  //   final codec = await ui.instantiateImageCodec(imageBytes);
  //   final frame = await codec.getNextFrame();
  //
  //   setState(() {
  //     _displayImage = frame.image;
  //     _predictedLabel = detectedLabels.isEmpty
  //         ? "No faces confidently detected"
  //         : detectedLabels.join("\n");
  //     listLabels.clear();
  //     listLabels.addAll(detectedLabels);
  //   });
  //
  //   print("Number of faces detected: ${_detectedFaces.length}");
  //   print("Number of predictions: ${detectedLabels.length}");
  //   print("Final predictions: $detectedLabels");
  // }

  // Future<File> _cropFace(File image, Face face) async {
  //   final Uint8List imageData = await image.readAsBytes();
  //   img.Image? rawImage = img.decodeImage(imageData);
  //   if (rawImage == null) throw Exception("Error decoding image");
  //
  //   final rect = face.boundingBox;
  //   int x = (rect.left - 20).toInt().clamp(0, rawImage.width);
  //   int y = (rect.top - 20).toInt().clamp(0, rawImage.height);
  //   int width = (rect.width + 40).toInt().clamp(0, rawImage.width - x);
  //   int height = (rect.height + 40).toInt().clamp(0, rawImage.height - y);
  //   img.Image cropped =
  //       img.copyCrop(rawImage, x: x, y: y, width: width, height: height);
  //
  //   final tempPath = '${(await getTemporaryDirectory()).path}/cropped_face.png';
  //   return File(tempPath)..writeAsBytesSync(img.encodePng(cropped));
  // }
  //
  // Future<List<List<List<List<double>>>>> _processImage(File image) async {
  //   final Uint8List imageData = await image.readAsBytes();
  //   img.Image? rawImage = img.decodeImage(imageData);
  //   if (rawImage == null) throw Exception("Error decoding image");
  //
  //   img.Image resizedImage = img.copyResize(rawImage, width: 224, height: 224);
  //   List<List<List<double>>> inputImage = List.generate(
  //     224,
  //     (y) => List.generate(
  //       224,
  //       (x) {
  //         var pixel = resizedImage.getPixel(x, y);
  //         return [
  //           (pixel.r - 128) / 128,
  //           (pixel.g - 128) / 128,
  //           (pixel.b - 128) / 128,
  //         ];
  //       },
  //     ),
  //   );
  //   return [inputImage];
  // }

  @override
  void dispose() {
    _interpreter?.close();
    faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarCustomSimple(title: "Upload Face Detection"),
      persistentFooterButtons: [
        ElevatedBtnCus(
          onTap: () => checkAttendance(),
          isFullWidth: true,
          btnName: "Submit Attendance",
        ),
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: TextWidget(
                  text: "Note: Upload image by Tap below.",
                  color: mainColor,
                ),
              ),
              Stack(
                children: [
                  UploadImage(imgFile: _image),
                  if (_displayImage != null)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: FacePainter(
                          faces: _detectedFaces,
                          image: _displayImage!,
                        ),
                      ),
                    ),
                ],
              ),
              ElevatedBtnCus(
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return buildOptionSelectPicture();
                    },
                  );
                },
                icon: Icons.image,
                btnName: "Upload Image",
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: TextWidget(
                  text: "List of Student",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              listLabels.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(noDataPng, height: 300),
                          const Text("Data not found yet!",
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        listLabels.length,
                        (int index) {
                          return Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.green, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                RegExp(r'^(.*?)\s*\(')
                                        .firstMatch(listLabels[index])
                                        ?.group(1) ??
                                    '',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOptionSelectPicture() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: TextWidget(
                text: "Let's pick image from option below.",
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              leading: Icon(Icons.info, color: mainColor),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () => _pickImage(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }
}

// =======================1000==========================================
// import 'dart:io';
// import 'dart:ui' as ui;
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
// import 'package:tomnenh/helper/helper.dart';
// import 'package:tomnenh/screen/uploads/upload_cubit.dart';
// import 'package:tomnenh/style/assets.dart';
// import 'package:tomnenh/style/colors.dart';
// import 'package:tomnenh/widget/app_bar_custom_simple.dart'
//     show AppbarCustomSimple;
// import 'package:tomnenh/widget/elevated_btn_cus.dart';
// import 'package:tomnenh/widget/text_widget.dart';
// import 'package:tomnenh/widget/upload_image.dart';
//
// class UploadFaceDetectionScreen extends StatefulWidget {
//   const UploadFaceDetectionScreen({super.key});
//   static const String routeName = "face_detection";
//
//   @override
//   State<UploadFaceDetectionScreen> createState() =>
//       _UploadFaceDetectionScreenState();
// }
//
// class _UploadFaceDetectionScreenState extends State<UploadFaceDetectionScreen> {
//   File? _image;
//   ui.Image? _displayImage;
//   List<Face> _detectedFaces = [];
//   String? _predictedLabel;
//   tfl.Interpreter? _interpreter;
//   List<String> _labels = [];
//   final ImagePicker _picker = ImagePicker();
//   final faceDetector = GoogleMlKit.vision.faceDetector();
//   final screenCubit = UploadCubit();
//
//   List<String> listLabels = [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     _loadModel();
//     _loadLabels();
//   }
//
//   Future<void> checkAttendance() async {
//     final names = listLabels.map((e) => e.split(' (').first).toList();
//     final result = await screenCubit.checkAttendance(names);
//     if (result) {
//       Helper.showMessage(msg: "Attendance submitted successfully!");
//       if (!mounted) return;
//       Navigator.pop(context);
//     }
//     print("==========================${result}");
//   }
//
//   Future<void> _loadModel() async {
//     try {
//       File? tLifeFile = await Helper.getLocalModelFile('face_detection.tflite');
//       if (tLifeFile != null) {
//         // Load into interpreter
//         _interpreter = tfl.Interpreter.fromFile(tLifeFile);
//         print("Model loaded!");
//       } else {
//         print("Model not found. Please download it first.");
//       }
//     } catch (e) {
//       debugPrint("Error loading model: $e");
//     }
//   }
//
//   Future<void> _loadLabels() async {
//     try {
//       // Get the local model file path
//       File? labelFile = await Helper.getLocalModelFile('labels.txt');
//
//       if (labelFile != null && await labelFile.exists()) {
//         String labelData = await labelFile.readAsString();
//
//         setState(() {
//           _labels =
//               labelData.split("\n").where((label) => label.isNotEmpty).toList();
//         });
//       } else {
//         debugPrint("Label file not found.");
//       }
//     } catch (e) {
//       debugPrint("Error loading labels: $e");
//     }
//   }
//
//   Future<void> _pickImage(ImageSource source) async {
//     Navigator.pop(context);
//     final pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile != null) {
//       File imageFile = File(pickedFile.path);
//       setState(() => _image = imageFile);
//       listLabels.clear();
//       _predictImage(imageFile);
//     }
//   }
//
//   Future<void> _predictImage(File image) async {
//     if (_interpreter == null || _labels.isEmpty) return;
//     _detectedFaces =
//         await faceDetector.processImage(InputImage.fromFile(image));
//     if (_detectedFaces.isEmpty) {
//       setState(() => _predictedLabel = "No faces detected");
//       return;
//     }
//
//     List<String> detectedFaces = [];
//     for (var face in _detectedFaces) {
//       var croppedFace = await _cropFace(image, face);
//       var input = await _processImage(croppedFace);
//       var output = List.generate(1, (_) => List.filled(_labels.length, 0.0));
//       _interpreter?.run(input, output);
//       List<double> outputList = List<double>.from(output[0]);
//       for (int i = 0; i < outputList.length; i++) {
//         if (outputList[i] > 0.5) {
//           detectedFaces.add(
//               "${_labels[i]} (${(outputList[i] * 100).toStringAsFixed(1)}%)");
//         }
//       }
//     }
//
//     final imgData = await image.readAsBytes();
//     final codec = await ui.instantiateImageCodec(imgData);
//     final frame = await codec.getNextFrame();
//     setState(() {
//       _displayImage = frame.image;
//       _predictedLabel = detectedFaces.isEmpty
//           ? "No faces confidently detected"
//           : detectedFaces.join("\n");
//       listLabels.addAll(detectedFaces);
//     });
//     print("==========================listUserName ==============${listLabels}");
//   }
//
//   Future<File> _cropFace(File image, Face face) async {
//     final Uint8List imageData = await image.readAsBytes();
//     img.Image? rawImage = img.decodeImage(imageData);
//     if (rawImage == null) throw Exception("Error decoding image");
//
//     final rect = face.boundingBox;
//     int x = (rect.left - 20).toInt().clamp(0, rawImage.width);
//     int y = (rect.top - 20).toInt().clamp(0, rawImage.height);
//     int width = (rect.width + 40).toInt().clamp(0, rawImage.width - x);
//     int height = (rect.height + 40).toInt().clamp(0, rawImage.height - y);
//     img.Image cropped =
//         img.copyCrop(rawImage, x: x, y: y, width: width, height: height);
//
//     final tempPath = '${(await getTemporaryDirectory()).path}/cropped_face.png';
//     return File(tempPath)..writeAsBytesSync(img.encodePng(cropped));
//   }
//
//   Future<List<List<List<List<double>>>>> _processImage(File image) async {
//     final Uint8List imageData = await image.readAsBytes();
//     img.Image? rawImage = img.decodeImage(imageData);
//     if (rawImage == null) throw Exception("Error decoding image");
//
//     img.Image resizedImage = img.copyResize(rawImage, width: 224, height: 224);
//     List<List<List<double>>> inputImage = List.generate(
//       224,
//       (y) => List.generate(
//         224,
//         (x) {
//           var pixel = resizedImage.getPixel(x, y);
//           return [
//             (pixel.r - 128) / 128,
//             (pixel.g - 128) / 128,
//             (pixel.b - 128) / 128
//           ];
//         },
//       ),
//     );
//     return [inputImage];
//   }
//
//   @override
//   void dispose() {
//     _interpreter?.close();
//     faceDetector.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const AppbarCustomSimple(
//         title: "Upload Face Detection",
//       ),
//       persistentFooterButtons: [
//         ElevatedBtnCus(
//           onTap: () => checkAttendance(),
//           isFullWidth: true,
//           btnName: "Submit Attendance",
//         ),
//       ],
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             spacing: 8,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               const Align(
//                 alignment: Alignment.topLeft,
//                 child: TextWidget(
//                   text: "Note: Upload image by Tap below.",
//                   color: mainColor,
//                 ),
//               ),
//               Stack(
//                 children: [
//                   UploadImage(
//                     imgFile: _image,
//                   ),
//                   if (_displayImage != null)
//                     Positioned.fill(
//                       child: CustomPaint(
//                         painter: FacePainter(
//                           faces: _detectedFaces,
//                           image: _displayImage!,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               ElevatedBtnCus(
//                 onTap: () {
//                   showModalBottomSheet<void>(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return buildOptionSelectPicture();
//                     },
//                   );
//                 },
//                 icon: Icons.image,
//                 btnName: "Upload Image",
//               ),
//               const Align(
//                 alignment: Alignment.topLeft,
//                 child: TextWidget(
//                   text: "List of Student",
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               listLabels.isEmpty
//                   ? Padding(
//                       padding: const EdgeInsets.only(top: 16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Image.asset(
//                             noDataPng,
//                             height: 300,
//                           ),
//                           const Text("Data not found yet!",
//                               style: TextStyle(fontSize: 16)),
//                         ],
//                       ),
//                     )
//                   : Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: List.generate(
//                         listLabels.length,
//                         (int index) {
//                           return Row(
//                             children: [
//                               const Icon(Icons.check_circle,
//                                   color: Colors.green, size: 18),
//                               const SizedBox(width: 8),
//                               Text(
//                                 RegExp(r'^(.*?)\s*\(')
//                                         .firstMatch(
//                                             listLabels[index].toString())
//                                         ?.group(1) ??
//                                     '',
//                                 style: const TextStyle(fontSize: 16),
//                                 textAlign: TextAlign.start,
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildOptionSelectPicture() {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 16,
//         vertical: 8,
//       ),
//       width: double.infinity,
//       child: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           spacing: 8,
//           children: [
//             const ListTile(
//               title: TextWidget(
//                 text: "Let's pick image from option below.",
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//               leading: Icon(
//                 Icons.info,
//                 color: mainColor,
//               ),
//             ),
//             // Image.asset(
//             //   getImagePng,
//             //   height: 200,
//             // ),
//             ElevatedBtnCus(
//               onTap: () => _pickImage(ImageSource.camera),
//               icon: Icons.camera_alt,
//               btnName: "Pick form Camera",
//             ),
//             ElevatedBtnCus(
//               onTap: () => _pickImage(ImageSource.gallery),
//               icon: Icons.photo,
//               btnName: "Pick form Image",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
class FacePainter extends CustomPainter {
  final List<Face> faces;
  final ui.Image image;

  FacePainter({required this.faces, required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    double scaleX = size.width / image.width;
    double scaleY = size.height / image.height;

    for (Face face in faces) {
      Rect rect = face.boundingBox;
      Rect scaledRect = Rect.fromLTRB(
        rect.left * scaleX,
        rect.top * scaleY,
        rect.right * scaleX,
        rect.bottom * scaleY,
      );
      canvas.drawRect(scaledRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
