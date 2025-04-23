import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  List<Map<String, dynamic>> studentImageFaces = [
    {
      "name": "Student 1",
      "image": "assets/images/student1.jpg",
    },
    {
      "name": "Student 2",
      "image": "assets/images/student2.jpg",
    },
    {
      "name": "Student 1",
      "image": "assets/images/student1.jpg",
    },
    {
      "name": "Student 2",
      "image": "assets/images/student2.jpg",
    }
  ];
  @override
  void initState() {
    pickedImages = List.filled(studentImageFaces.length, null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarCustomSimple(
        title: "Upload Student Face Image",
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
                  final student = studentImageFaces[index];
                  return UploadFaceScreen(
                    name: student["name"],
                    imagePath: student["image"],
                    pickedImage: pickedImages[index],
                    onPickImage: () => _pickImage(ImageSource.camera, index),
                  );
                },
              ),
            ),
            SafeArea(
                child: ElevatedBtnCus(onTap: () {}, btnName: "Submit All")),
          ],
        ),
      ),
    );
  }
}
