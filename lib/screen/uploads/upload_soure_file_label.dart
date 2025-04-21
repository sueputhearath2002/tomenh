import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomnenh/screen/uploads/upload_cubit.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/app_bar_custom_simple.dart'
    show AppbarCustomSimple;
import 'package:tomnenh/widget/elevated_btn_cus.dart';
import 'package:tomnenh/widget/hr.dart';
import 'package:tomnenh/widget/rectangle_btn.dart';
import 'package:tomnenh/widget/text_widget.dart';
import 'package:tomnenh/widget/upload_file.dart';

class UploadSourceFileLabel extends StatefulWidget {
  const UploadSourceFileLabel({super.key});

  static const String routeName = "source_lable";

  @override
  State<UploadSourceFileLabel> createState() => _UploadSourceFileLabelState();
}

class _UploadSourceFileLabelState extends State<UploadSourceFileLabel> {
  FilePickerResult? tLifeFile;
  FilePickerResult? labelFile;
  final screenCubit = UploadCubit();

  void uploadFile() async {
    Map<String, dynamic> data = {
      "file": tLifeFile,
      "label": labelFile,
    };
    final result = await screenCubit.uploadFile(data);
    if (result) {
      if (!mounted) return;
      Navigator.pop(context);
    }
    print("==============result =======${result}");
  }

  Future<void> pickFile(String fileType) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      setState(() {
        if (fileType == 'tlife') {
          tLifeFile = result;
        } else if (fileType == 'label') {
          labelFile = result;
        }
      });

      for (var element in result.files) {
        print("Picked $fileType file: ${element.name}");
      }
    } else {
      print("No $fileType file selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarCustomSimple(
        title: "Upload Source File && Label",
      ),
      persistentFooterButtons: [
        BlocBuilder<UploadCubit, UploadState>(
          bloc: screenCubit,
          builder: (context, state) {
            return RectangleBtnZin(
              onTap: () => uploadFile(),
              isFullWidth: true,
              child: const TextWidget(
                text: "Upload Now",
                color: whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            );
          },
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
                color: textColor,
              ),
            ),
            UploadFile(file: tLifeFile),
            ElevatedBtnCus(
              onTap: () => pickFile('tlife'),
              icon: Icons.cloud_upload,
              btnName: "Select .tlife file ",
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
                text: "Note: Upload Your source file below with .txt",
                color: textColor,
              ),
            ),
            UploadFile(file: labelFile),
            ElevatedBtnCus(
              onTap: () => pickFile('label'),
              icon: Icons.cloud_upload,
              btnName: "Select .txt file ",
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
