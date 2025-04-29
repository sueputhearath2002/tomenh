import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomnenh/screen/uploads/upload_cubit.dart';
import 'package:tomnenh/widget/elevated_btn_cus.dart';

class CapturedImagesPage extends StatelessWidget {
  final List<XFile> images;

  CapturedImagesPage({super.key, required this.images});

  final screenCubit = UploadCubit();

  void uploadStudents(BuildContext context) async {
    final result = await screenCubit.uploadImageStudent({"images": images});
    if (result) {
      if (!context.mounted) return;
      Navigator.pop(context); // first pop
      Navigator.pop(context);
    }
    print("=========================ok${result}");
  }

  @override
  Widget build(BuildContext context) {
    print("========list======${images}");
    return Scaffold(
      appBar: AppBar(title: const Text("Captured Images")),
      persistentFooterButtons: [
        BlocBuilder<UploadCubit, UploadState>(
          bloc: screenCubit,
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedBtnCus(
                  isLoading: state.isLoadingUpload,
                  onTap: () => uploadStudents(context),
                  icon: Icons.send,
                  btnName: "Submit All",
                ),
              ),
            );
          },
        ),
      ],
      body: ListView(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Image.file(
                File(images[index].path),
                fit: BoxFit.cover,
              );
            },
          ),
        ],
      ),
    );
  }
}
