import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/dash_border_container.dart';
import 'package:tomnenh/widget/text_widget.dart';

class UploadFile extends StatelessWidget {
  const UploadFile({super.key, this.onTap, this.file});
  final VoidCallback? onTap;
  final FilePickerResult? file;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: SizedBox(
          width: double.infinity,
          child: DashedBorderContainer(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.file_present_rounded,
                    color: file == null
                        ? mainColor.withValues(alpha: 0.5)
                        : mainColor,
                    size: 30,
                  ),
                  Expanded(
                    child: TextWidget(
                      text: file == null
                          ? "No file uploaded."
                          : file!.files[0].name,
                      fontSize: 16,
                      maxLines: 2,
                      fontWeight: FontWeight.bold,
                      color: file == null
                          ? mainColor.withValues(alpha: 0.5)
                          : mainColor,
                    ),
                  )
                ],
              ),
            ),
          )),

      // Container(
      //   width: double.infinity,
      //   height: 200,
      //   alignment: Alignment.center,
      //   decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(8),
      //       color: secondaryColor.withValues(alpha: 0.3)),
      //   child: imgFile == null
      //       ? const Column(
      //           spacing: 8,
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Icon(
      //               Icons.image,
      //               color: mainColor,
      //               size: 60,
      //             ),
      //             TextWidget(
      //               text: "Tap to upload image",
      //               fontSize: 16,
      //               fontWeight: FontWeight.bold,
      //               color: mainColor,
      //             )
      //           ],
      //         )
      //       : Image.file(
      //           imgFile!,
      //           width: 200,
      //           height: 200,
      //           fit: BoxFit.cover,
      //         ),
      // ),
    );
  }
}
