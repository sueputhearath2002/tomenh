import 'package:flutter/material.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/style/constant.dart';
import 'package:tomnenh/widget/appbarCustome.dart';
import 'package:tomnenh/widget/rectangle_btn.dart';
import 'package:tomnenh/widget/text_form_field_custom.dart';
import 'package:tomnenh/widget/text_style.dart';
import 'package:tomnenh/widget/upload_image.dart';

class SetUpCategory extends StatelessWidget {
  const SetUpCategory({super.key});
  static const String routeName = "/set_up_category";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        RectangleBtnZin(
            onTap: () {
              print("Save");
            },
            isFullWidth: true,
            bgColor: greenColor,
            child: Text(
              "Save Category",
              style: TextStyles.baseStyle(
                  fontWeight: FontWeight.w600, color: whiteColor),
            ))
      ],
      appBar: const AppbarCustom(
        title: "Set up Category",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextFormFieldCustom(
                titleTextField: "Customer Name",
                hinText: "Customer Name",
              ),
              gapH(8),

              // const DropDownWidget(
              //   label: "Gender",
              //   hinText: "Male",
              // ),
              gapH(8),
              const TextFormFieldCustom(
                maxLine: 4,
                titleTextField: "Description",
                hinText: "Description",
              ),
              gapH(16),
              const UploadImage()
            ],
          ),
        ),
      ),
    );
  }
}
