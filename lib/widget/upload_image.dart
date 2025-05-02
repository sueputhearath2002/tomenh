import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/dash_border_container.dart';
import 'package:tomnenh/widget/text_widget.dart';

class UploadImage extends StatelessWidget {
  const UploadImage(
      {super.key, this.onTap, this.imgFile, this.description = ""});
  final VoidCallback? onTap;
  final File? imgFile;
  final String description;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: imgFile == null
            ? DashedBorderContainer(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          color: mainColor.withValues(alpha: 0.7),
                          size: 60,
                        ),
                        const TextWidget(
                          text: "Tap to upload ",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                        if (description.isNotEmpty)
                          TextWidget(
                            text: description ?? "",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: mainColor,
                          )
                      ],
                    )),
              )
            : Image.file(
                imgFile!,
                fit: BoxFit.fitHeight,
              ),
      ),

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
