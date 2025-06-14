// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
// import 'dart:ui' as ui;
// import 'package:flutter/services.dart';
// import 'package:tomnenh/helper/helper.dart';

// class FaceDetectionApp extends StatefulWidget {
//   static const String routeName = '/face_detection';
//   @override
//   _FaceDetectionAppState createState() => _FaceDetectionAppState();
// }

// class _FaceDetectionAppState extends State<FaceDetectionApp> {
//   tfl.Interpreter? interpreter;
//   List<String> labels = [];
//   List<String> results = [];
//   File? imageFile;

//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//     loadLabels();
//   }

//   Future<void> loadModel() async {
//     try {
//       File? tLifeFile = await Helper.getLocalModelFile('face_detection.tflite');
//       print("===========file: ${tLifeFile?.path}");
//       if (tLifeFile != null) {
//         final exists = await tLifeFile.exists();
//         print("File exists: $exists");
//         interpreter = await tfl.Interpreter.fromFile(tLifeFile);
//         print("Model loaded!");
//       } else {
//         print("Model not found. Please download it first.");
//       }
//     } catch (e) {
//       debugPrint("Error loading model: $e");
//     }
//   }

//   Future<void> loadLabels() async {
//     try {
//       File? labelFile = await Helper.getLocalModelFile('labels.txt');
//       if (labelFile != null && await labelFile.exists()) {
//         String labelData = await labelFile.readAsString();
//         setState(() {
//           labels =
//               labelData.split("\n").where((label) => label.isNotEmpty).toList();
//         });
//       } else {
//         debugPrint("Label file not found.");
//       }
//     } catch (e) {
//       debugPrint("Error loading labels: $e");
//     }
//   }

//   Future<void> pickImage() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked == null) return;

//     imageFile = File(picked.path);
//     setState(() {});

//     await runInference(imageFile!);
//   }

//   // Future<Uint8List> imageToByteList(File image, int inputSize) async {
//   //   final bytes = await image.readAsBytes();
//   //   final codec = await ui.instantiateImageCodec(bytes, targetWidth: inputSize, targetHeight: inputSize);
//   //   final frame = await codec.getNextFrame();
//   //   final img = frame.image;

//   //   final byteData = await img.toByteData(format: ui.ImageByteFormat.rawRgba);
//   //   final buffer = byteData!.buffer;

//   //   // Normalize to [0,1] or [0,255] depending on model. Here we assume 0-255
//   //   final List<double> normalized = [];

//   //   for (int i = 0; i < buffer.lengthInBytes; i += 4) {
//   //     final r = buffer.asInt8List(i+0);
//   //     final g = buffer.asInt8List(i + 1);
//   //     final b = buffer.asInt8List(i + 2);
//   //     normalized.addAll([r, g, b]);
//   //   }

//   //   return Float32List.fromList(normalized).buffer.asUint8List();
//   // }

//   Future<Uint8List> imageToByteList(File image, int inputSize) async {
//     final bytes = await image.readAsBytes();
//     final codec = await ui.instantiateImageCodec(bytes,
//         targetWidth: inputSize, targetHeight: inputSize);
//     final frame = await codec.getNextFrame();
//     final img = frame.image;

//     final byteData = await img.toByteData(format: ui.ImageByteFormat.rawRgba);
//     if (byteData == null) throw Exception('Failed to convert image to bytes');

//     final pixels = byteData.buffer.asUint8List();
//     final List<double> normalized = [];

//     // Process pixels in groups of 4 (RGBA)
//     for (int i = 0; i < pixels.length; i += 4) {
//       // Convert to float and normalize to [-1, 1]
//       normalized.addAll([
//         (pixels[i] - 127.5) / 127.5, // R
//         (pixels[i + 1] - 127.5) / 127.5, // G
//         (pixels[i + 2] - 127.5) / 127.5, // B
//       ]);
//     }

//     return Float32List.fromList(normalized).buffer.asUint8List();
//   }

//   Future<void> runInference(File image) async {
//     if (interpreter == null) {
//       print("Interpreter is not initialized");
//       return;
//     }

//     const inputSize = 224;
//     final input = await imageToByteList(image, inputSize);
//     final inputArray = input.buffer.asFloat32List();

//     // Create input tensor
//     final inputTensor = [
//       List.generate(
//         inputSize,
//         (y) => List.generate(
//           inputSize,
//           (x) => List.generate(
//             3,
//             (c) => inputArray[(y * inputSize + x) * 3 + c],
//           ),
//         ),
//       ),
//     ];

//     var output = List.filled(1, List.filled(labels.length, 0.0));

//     try {
//       interpreter!.allocateTensors();
//       interpreter!.run(inputTensor, output);

//       final predictions = output[0];

//       // Store all predictions above threshold
//       List<MapEntry<int, double>> allPredictions = [];
//       for (int i = 0; i < predictions.length; i++) {
//         final confidence = predictions[i];
//         if (confidence > 0.1) {
//           // Lower threshold to catch more faces
//           allPredictions.add(MapEntry(i, confidence));
//         }
//       }

//       // Sort by confidence
//       allPredictions.sort((a, b) => b.value.compareTo(a.value));

//       // Take top N predictions where N is expected number of faces (6 in this case)
//       final topN = allPredictions.take(6);

//       List<String> detected = [];
//       Set<String> usedNames = {};

//       for (var pred in topN) {
//         final name = labels[pred.key].replaceAll('pins_', '');
//         if (!usedNames.contains(name)) {
//           usedNames.add(name);
//           detected.add('$name (${(pred.value * 100).toStringAsFixed(1)}%)');
//         }
//       }

//       // Debug output
//       print("\nAll predictions above 10%:");
//       allPredictions.take(10).forEach((pred) {
//         final name = labels[pred.key].replaceAll('pins_', '');
//         print("$name: ${(pred.value * 100).toStringAsFixed(1)}%");
//       });

//       setState(() {
//         results = detected;
//       });

//       print("\nNumber of faces detected: ${detected.length}");
//       print("Final predictions: $detected");
//     } catch (e) {
//       print("Error running inference: $e");
//       print("Stack trace: ${StackTrace.current}");
//     }
//   }

//   @override
//   void dispose() {
//     interpreter?.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Face Detection")),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ElevatedButton(
//                 onPressed: pickImage,
//                 child: const Text('Upload Image'),
//               ),
//               const SizedBox(height: 16),
//               if (imageFile != null) ...[
//                 Image.file(imageFile!, height: 300),
//                 const SizedBox(height: 16),
//                 Text(
//                   "Detected People (${results.length}):",
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 ...results
//                     .map((person) => Card(
//                           margin: const EdgeInsets.only(bottom: 8),
//                           child: ListTile(
//                             leading: const Icon(Icons.person),
//                             title: Text(
//                               person,
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                           ),
//                         ))
//                     .toList(),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
