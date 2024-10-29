import 'package:flutter/material.dart';
import 'package:tomnenh/style/colors.dart';

class TextFormFieldCustom extends StatelessWidget {
  const TextFormFieldCustom({
    super.key,
    this.titleTextField,
    this.hinText,
    this.textEditingController,
    this.keyboardType,
    this.obscureText = false,
    this.isShowRequired = false,
    this.readOnly = false,
    this.suffixIcon,
    this.maxLine = 1,
    this.onTap,
  });
  final String? titleTextField;
  final String? hinText;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final int maxLine;
  final bool isShowRequired;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              titleTextField ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: greenColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isShowRequired ? "required" : "",
              style: const TextStyle(
                color: redColor,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        TextFormField(
          onTap: readOnly ? onTap : null,
          readOnly: readOnly,
          maxLines: maxLine,
          obscureText: obscureText,
          keyboardType: keyboardType,
          controller: textEditingController,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            fillColor: green50Color.withOpacity(.1),
            filled: true,
            contentPadding: const EdgeInsets.all(8),
            hintText: hinText,
            hintStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: green50Color,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: green50Color, width: 0.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: green50Color, width: 0.5),
            ),
          ),
        )
      ],
    );
  }
}
