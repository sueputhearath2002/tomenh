import 'package:flutter/material.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/style/constant.dart';
import 'package:tomnenh/widget/appbarCustome.dart';
import 'package:tomnenh/widget/dropdown.dart';
import 'package:tomnenh/widget/rectangle_btn.dart';
import 'package:tomnenh/widget/text_form_field_custom.dart';

class SetUpCustomer extends StatelessWidget {
  const SetUpCustomer({super.key});

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
              "Save Customer",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: whiteColor,
                fontSize: 14,
              ),
            ))
      ],
      appBar: const AppbarCustom(
        title: "Set up Customer",
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormFieldCustom(
                titleTextField: "Customer code",
                hinText: "Customer code",
              ),
              gapH16,
              TextFormFieldCustom(
                titleTextField: "Customer Name",
                hinText: "Customer Name",
              ),
              gapH16,
              DropDownWidget(
                label: "Gender",
                hinText: "Male",
              ),
              gapH16,
              TextFormFieldCustom(
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
