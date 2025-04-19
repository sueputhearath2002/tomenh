import 'package:flutter/material.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/style/constant.dart';
import 'package:tomnenh/widget/app_bar_custom.dart';
import 'package:tomnenh/widget/rectangle_btn.dart';
import 'package:tomnenh/widget/text_form_field_custom.dart';

class SetupProduct extends StatelessWidget {
  const SetupProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        persistentFooterButtons: [
          RectangleBtnZin(
              onTap: () {
                print("Save");
              },
              width: double.infinity,
              bgColor: greenColor,
              child: const Text(
                "Save Product",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: whiteColor,
                  fontSize: 14,
                ),
              ))
        ],
        appBar: const AppbarCustom(
          title: "Set up product",
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextFormFieldCustom(
                  titleTextField: "Product code",
                  hinText: "product code",
                ),
                gapH(16),
                const TextFormFieldCustom(
                  titleTextField: "Product Name",
                  hinText: "product Name",
                ),
                gapH(16),
                const TextFormFieldCustom(
                  titleTextField: "Description product",
                  hinText: "Description Name",
                ),
                gapH(16),
                const Text(
                  "Image product",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: greenColor,
                    fontSize: 14,
                  ),
                ),
                gapH(8),
                Container(
                  width: double.infinity,
                  height: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: green50Color.withOpacity(.3)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.image,
                        color: greenColor,
                        size: 40,
                      ),
                      gapH(8),
                      const Text("Upload image")
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
