import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/app_bar_custom_simple.dart'
    show AppbarCustomSimple;
import 'package:tomnenh/widget/elevated_btn_cus.dart';
import 'package:tomnenh/widget/hr.dart';
import 'package:tomnenh/widget/rectangle_btn.dart';
import 'package:tomnenh/widget/text_widget.dart';
import 'package:tomnenh/widget/upload_image.dart';

class UploadSourceFileLabel extends StatefulWidget {
  const UploadSourceFileLabel({super.key});
  static const String routeName = "source_lable";

  @override
  State<UploadSourceFileLabel> createState() => _UploadSourceFileLabelState();
}

class _UploadSourceFileLabelState extends State<UploadSourceFileLabel> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarCustomSimple(
        title: "Upload Source File && Label",
      ),
      persistentFooterButtons: [
        RectangleBtnZin(
          onTap: () {},
          isFullWidth: true,
          child: const TextWidget(
            text: "Upload Now",
            color: whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: TextWidget(
                text: "Note: Upload Your source file below with .tlife",
                color: mainColor,
              ),
            ),
            UploadImage(
              imgFile: _image,
              onTap: () {},
            ),
            const ElevatedBtnCus(
              // onTap: () => _pickImage(ImageSource.camera),
              icon: Icons.cloud_upload,
              btnName: "Select File ",
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Hr(
                width: double.infinity,
                color: secondaryColor,
              ),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: TextWidget(
                text: "Note: Upload Your source file below with .labels",
                color: mainColor,
              ),
            ),
            const ElevatedBtnCus(
              // onTap: () => _pickImage(ImageSource.camera),
              icon: Icons.cloud_upload,
              btnName: "Select File ",
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOptionSelectPicture() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 0,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          const ListTile(
            title: TextWidget(
              text: "Let's pick image from option below.",
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            leading: Icon(
              Icons.info,
              color: mainColor,
            ),
          ),
          Image.asset(
            getImagePng,
            height: 200,
          ),
          const ElevatedBtnCus(
            // onTap: () => _pickImage(ImageSource.camera),
            icon: Icons.camera_alt,
            btnName: "Pick form Camera",
          ),
          const ElevatedBtnCus(
            // onTap: () => _pickImage(ImageSource.gallery),
            icon: Icons.photo,
            btnName: "Pick form Image",
          ),
        ],
      ),
    );
  }
}
