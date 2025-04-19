import 'package:flutter/material.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/text_style.dart';

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
    this.prefixIcon,
    this.maxLine = 1,
    this.onTap,
    this.fillColor = whiteColor,
  });
  final String? titleTextField;
  final String? hinText;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int maxLine;
  final bool isShowRequired;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titleTextField != null)
          Row(
            children: [
              Text(
                titleTextField ?? "",
                style: TextStyles.bodyText(),
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
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            fillColor: fillColor,
            filled: true,
            contentPadding: const EdgeInsets.all(8),
            hintText: hinText,
            hintStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: textSearchColor,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: cardColor, width: 0.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: cardColor, width: 0.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: cardColor, width: 0.3),
            ),
          ),
        )
      ],
    );
  }
}
