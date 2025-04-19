import 'package:flutter/material.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/text_widget.dart';

class ElevatedBtnCus extends StatelessWidget {
  const ElevatedBtnCus({
    super.key,
    this.iconColor = whiteColor,
    this.isFullWidth = true,
    this.onTap,
    this.btnName = "",
    this.btnNameColor = whiteColor,
    this.bgBtn = mainColor,
    this.icon,
  });
  final Color iconColor;
  final bool isFullWidth;
  final VoidCallback? onTap;
  final String btnName;
  final Color btnNameColor;
  final Color bgBtn;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: iconColor,
        ),
        label: TextWidget(
          text: btnName,
          fontWeight: FontWeight.bold,
          color: btnNameColor,
        ),
        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(bgBtn)),
        onPressed: onTap,
      ),
    );
  }
}
