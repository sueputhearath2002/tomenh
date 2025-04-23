import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tomnenh/widget/upload_image.dart';

class UploadFaceScreen extends StatelessWidget {
  const UploadFaceScreen({
    super.key,
    required this.name,
    required this.imagePath,
    required this.pickedImage,
    required this.onPickImage,
  });

  final String name;
  final String imagePath;
  final File? pickedImage;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    return UploadImage(
      onTap: onPickImage,
      imgFile: pickedImage,
      description: name,
    );
    ;
  }
}
