// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:tomnenh/style/constant.dart';
// import 'package:tomnenh/widget/app_bar_custom.dart';
// import 'package:tomnenh/widget/upload_image.dart';
//
// class UploadImageScreen extends StatefulWidget {
//   const UploadImageScreen({super.key});
//
//   @override
//   State<UploadImageScreen> createState() => _UploadImageScreenState();
// }
//
// class _UploadImageScreenState extends State<UploadImageScreen> {
//   File? _imgFile;
//   bool _isPickingImage = false;
//   late FaceDetector faceDetector;
//
//   final FaceRecognitionService faceRecognitionService =
//       FaceRecognitionService();
//   final FaceDetectionService faceDetectionService = FaceDetectionService();
//
//   @override
//   void initState() {
//     super.initState();
//     final options = FaceDetectorOptions(
//       performanceMode: FaceDetectorMode.accurate,
//       enableLandmarks: true,
//       enableContours: true,
//     );
//     faceDetector = FaceDetector(options: options);
//     _initializeModel();
//   }
//
//   @override
//   void dispose() {
//     faceDetector.close();
//     super.dispose();
//   }
//
//   Future<void> _initializeModel() async {
//     try {
//       await faceRecognitionService.loadModel();
//       print('Model loaded successfully');
//     } catch (e) {
//       print('Error loading model: $e');
//     }
//   }
//
//   Future<void> takeSnapshot() async {
//     final faceRecognitionService = FaceRecognitionService();
//     if (_isPickingImage) return;
//     setState(() {
//       _isPickingImage = true;
//     });
//
//     try {
//       final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (xFile == null) {
//         print("No image selected");
//         return;
//       }
//
//       final originalImage = File(xFile.path);
//       setState(() {
//         _imgFile = originalImage;
//       });
//
//       // Load the model before processing the image
//       await faceRecognitionService.loadModel();
//
//       // Process the detected face after the model is loaded
//       await faceRecognitionService.generateEmbeddings(_imgFile!);
//       print("Embeddings generated successfully");
//     } catch (e) {
//       print("Error picking image or generating embeddings: $e");
//     } finally {
//       setState(() {
//         _isPickingImage = false;
//       });
//     }
//   }
//
//   Future<File> cropFace(File imageFile, Rect boundingBox) async {
//     // Decode the image file
//     final originalImage = img.decodeImage(imageFile.readAsBytesSync());
//     if (originalImage == null) throw Exception("Failed to decode image");
//
//     // Adjust bounding box if it exceeds image boundaries
//     final adjustedBoundingBox = Rect.fromLTWH(
//       boundingBox.left.clamp(0, originalImage.width.toDouble()),
//       boundingBox.top.clamp(0, originalImage.height.toDouble()),
//       boundingBox.width
//           .clamp(0, originalImage.width.toDouble() - boundingBox.left),
//       boundingBox.height
//           .clamp(0, originalImage.height.toDouble() - boundingBox.top),
//     );
//
//     // Crop the face region using the adjusted bounding box
//     final cropped = img.copyCrop(
//       originalImage,
//       x: boundingBox.left.toInt(),
//       y: boundingBox.top.toInt(),
//       width: boundingBox.width.toInt(),
//       height: boundingBox.height.toInt(),
//     );
//
//     // Save the cropped image to a new file
//     final tempDir = await getTemporaryDirectory();
//     final croppedFile = File(
//         '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg');
//     croppedFile.writeAsBytesSync(img.encodeJpg(cropped));
//
//     return croppedFile;
//   }
//
//   Future<void> processDetectedFace(File imageFile) async {
//     try {
//       final embeddings =
//           await faceRecognitionService.generateEmbeddings(imageFile);
//       print('Generated Embeddings: $embeddings');
//
//       // Save or compare embeddings (implement your own logic here)
//     } catch (e) {
//       print('Error processing face: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const AppbarCustom(
//         title: "Upload Image",
//         isShowSearch: false,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Image Upload",
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//             gapH(8),
//             const Text("Please upload image for training models"),
//             gapH(16),
//             UploadImage(
//               onTap: () => takeSnapshot(),
//               imgFile: _imgFile,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class FaceRecognitionService {
//   late Interpreter _interpreter;
//
//   // Load the face recognition model
//   Future<void> loadModel() async {
//     try {
//       print("Loading face recognition model...");
//       _interpreter = await Interpreter.fromAsset('assets/model_unquant.tflite');
//
//       print("o${_interpreter.getOutputTensor(0).shape}");
//       print("Model loaded successfully");
//     } catch (e) {
//       print("Error loading model: $e");
//       throw Exception("Failed to load model");
//     }
//   }
//
//   // Generate embeddings from the image
//   Future<List<double>> generateEmbeddings(File imageFile) async {
//     if (_interpreter == null) {
//       throw Exception('Interpreter is not initialized');
//     }
//
//     try {
//       // Step 1: Decode and preprocess the image
//       final originalImage = img.decodeImage(imageFile.readAsBytesSync());
//       if (originalImage == null) {
//         throw Exception("Failed to decode image");
//       }
//
//       // Resize image to match model input dimensions (e.g., 112x112)
//       final resizedImage =
//           img.copyResize(originalImage, width: 112, height: 112);
//
//       // Prepare the input tensor: Normalize pixel values to [0, 1] range
//       final input = List.generate(112, (y) {
//         return List.generate(112, (x) {
//           final pixel = resizedImage.getPixel(x, y);
//           return [
//             (pixel.r / 255.0).toDouble(), // Red
//             (pixel.g / 255.0).toDouble(), // Green
//             (pixel.b / 255.0).toDouble(), // Blue
//           ];
//         });
//       });
//
//       // Flatten and reshape input to match the model's input shape: [1, 112, 112, 3]
//       final inputTensor =
//           input.expand((row) => row).expand((color) => color).toList();
//       final reshapedInput = [inputTensor]; // Add batch dimension
//
//       // Step 2: Prepare the output tensor for embeddings
//       final output = List.filled(512, 0.0).reshape([1, 512]);
//
//       // Step 3: Run inference
//       _interpreter.run(reshapedInput, output);
//
//       // Step 4: Return the embeddings
//       return List<double>.from(output[0]);
//     } catch (e) {
//       print("Error generating embeddings: $e");
//       throw Exception("Failed to generate embeddings");
//     }
//   }
// }
//
// class FaceDetectionService {
//   Future<List<Rect>> detectFaces(File imageFile) async {
//     final inputImage = InputImage.fromFile(imageFile);
//     final faceDetector = FaceDetector(
//       options: FaceDetectorOptions(
//         performanceMode: FaceDetectorMode.accurate,
//         enableLandmarks: true,
//         enableContours: true,
//       ),
//     );
//
//     final faces = await faceDetector.processImage(inputImage);
//     await faceDetector.close();
//
//     return faces.map((face) => face.boundingBox).toList();
//   }
// }
