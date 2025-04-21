// import 'dart:io';
//
// import 'package:google_ml_kit/google_ml_kit.dart';
//
// class FaceDetectionService {
//   final FaceDetector faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableLandmarks: true,
//       enableClassification: true,
//       enableTracking: true, // Enables face tracking
//     ),
//   );
//
//   Future<void> detectFaces(File imageFile) async {
//     try {
//       // Prepare input image
//       final inputImage = InputImage.fromFile(imageFile);
//
//       // Process the image
//       final faces = await faceDetector.processImage(inputImage);
//
//       if (faces.isEmpty) {
//         print('No face detected');
//         return;
//       }
//
//       for (Face face in faces) {
//         print('Face detected: ${face.boundingBox}');
//
//         // Extract head rotation angles
//         print('Head tilt (X): ${face.headEulerAngleX}');
//         print('Head rotation (Y): ${face.headEulerAngleY}');
//         print('Head tilt (Z): ${face.headEulerAngleZ}');
//
//         // Access landmarks
//         for (var entry in face.landmarks.entries) {
//           final type = entry.key;
//           final landmark = entry.value;
//           if (landmark != null) {
//             print(
//                 '$type position: (${landmark.position.x}, ${landmark.position.y})');
//           } else {
//             print('$type not detected');
//           }
//         }
//
//         // Access facial contours
//         for (var entry in face.contours.entries) {
//           final contourType = entry.key;
//           final contour = entry.value;
//           if (contour != null && contour.points.isNotEmpty) {
//             print('Contour: $contourType');
//             for (var point in contour.points) {
//               print('Point: (${point.x}, ${point.y})');
//             }
//           } else {
//             print('No points for contour: $contourType');
//           }
//         }
//
//         // Check smiling probability
//         if (face.smilingProbability != null) {
//           print('Smiling probability: ${face.smilingProbability}');
//         }
//
//         // Check face tracking ID
//         if (face.trackingId != null) {
//           print('Tracking ID: ${face.trackingId}');
//         }
//       }
//     } catch (e) {
//       print('Error during face detection: $e');
//     } finally {
//       // Close detector
//       faceDetector.close();
//     }
//   }
// }
