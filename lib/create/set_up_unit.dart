import 'package:flutter/material.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/style/constant.dart';
import 'package:tomnenh/widget/appbarCustome.dart';
import 'package:tomnenh/widget/rectangle_btn.dart';
import 'package:tomnenh/widget/text_form_field_custom.dart';

class SetUpUnit extends StatelessWidget {
  const SetUpUnit({super.key});

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
            child: const Text(
              "Save Unit",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: whiteColor,
                fontSize: 14,
              ),
            ))
      ],
      appBar: const AppbarCustom(
        title: "Set up Unit",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextFormFieldCustom(
                titleTextField: "Unit code",
                hinText: "Unit code",
              ),
              gapH(16),
              const TextFormFieldCustom(
                titleTextField: "Unit Name",
                hinText: "Unit Name",
              ),
              gapH(16),
              const TextFormFieldCustom(
                titleTextField: "Description Unit",
                hinText: "Description Unit",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
