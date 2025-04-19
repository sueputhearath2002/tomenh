import 'package:flutter/material.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/my_elevate_btn.dart';
import 'package:tomnenh/widget/text_widget.dart';

class BuildBtnTextIcon extends StatelessWidget {
  const BuildBtnTextIcon({
    super.key,
    required this.onTap,
    this.isLoadingIcon = false,
    this.textIcon = "Sign Up",
    this.icon = Icons.arrow_forward,
  });
  final VoidCallback onTap;
  final bool isLoadingIcon;
  final String textIcon;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return MyElevatedButton(
      onPressed: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextWidget(
            text: textIcon,
            color: whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          isLoadingIcon
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    year2023: true,
                    color: whiteColor,
                    strokeWidth: 1,
                  ))
              : Icon(
                  icon,
                  color: whiteColor,
                )
        ],
      ),
    );
  }
}
