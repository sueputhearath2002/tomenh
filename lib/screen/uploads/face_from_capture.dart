import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomnenh/widget/elevated_btn_cus.dart';

class CapturedImagesPage extends StatelessWidget {
  final List<XFile> images;

  const CapturedImagesPage({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    print("========list======${images}");
    return Scaffold(
      appBar: AppBar(title: const Text("Captured Images")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Image.file(File(images[index].path));
              },
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
