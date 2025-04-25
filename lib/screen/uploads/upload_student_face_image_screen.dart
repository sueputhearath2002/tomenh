import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomnenh/screen/uploads/face_scan_page.dart';
import 'package:tomnenh/screen/uploads/upload_face_screen.dart';
import 'package:tomnenh/widget/app_bar_custom_simple.dart';
import 'package:tomnenh/widget/elevated_btn_cus.dart';

class UploadStudentFaceImageScreen extends StatefulWidget {
  const UploadStudentFaceImageScreen({super.key});
  static const String routeName = "/upload_student_face_image";

  @override
  State<UploadStudentFaceImageScreen> createState() =>
      _UploadStudentFaceImageScreenState();
}

class _UploadStudentFaceImageScreenState
    extends State<UploadStudentFaceImageScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  List<File?> pickedImages = [];

  Future<void> _pickImage(ImageSource source, int index) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        pickedImages[index] = imageFile;
      });
    }
  }

  List<Map<String, dynamic>> studentImageFaces = List.generate(10, (index) {
    return {
      "action": "face",
    };
  });

  Future<bool> isFaceInsideGuideAndAligned(Face face, Size screenSize) {
    final boundingBox = face.boundingBox;

    // You define your guide box manually based on screen size
    const double guideWidth = 250;
    const double guideHeight = 300;
    final double centerX = screenSize.width / 2;
    final double centerY = screenSize.height / 2;

    final Rect guideRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: guideWidth,
      height: guideHeight,
    );

    final bool isInside = guideRect.contains(boundingBox.center);

    final double? yaw = face.headEulerAngleY;
    final double? roll = face.headEulerAngleZ;
    final bool isAligned = (yaw ?? 0).abs() < 10 && (roll ?? 0).abs() < 10;

    return Future.value(isInside && isAligned);
  }

  @override
  void initState() {
    pickedImages = List<File?>.generate(studentImageFaces.length, (_) => null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarCustomSimple(
        title: "Upload Student Face Images",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                padding: const EdgeInsets.all(8.0),
                itemCount: studentImageFaces.length,
                itemBuilder: (context, index) {
                  return UploadFaceScreen(
                      pickedImage: pickedImages[index],
                      onPickImage: () => Navigator.pushNamed(
                          context, FaceScannerPage.routeName)

                      // _pickImage(ImageSource.camera, index),
                      );
                },
              ),
            ),
            SafeArea(
              child: ElevatedBtnCus(
                onTap: () {},
                btnName: "Submit All",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
