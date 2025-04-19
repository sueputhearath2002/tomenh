import 'package:flutter/material.dart';
import 'package:tomnenh/style/colors.dart';

class RectangleBtn extends StatelessWidget {
  const RectangleBtn({
    super.key,
    this.bgColor = greenColor,
    this.child,
    this.horizontal = 8,
    this.vertical = 8,
    required this.onTap,
  });
  final Color bgColor;
  final Widget? child;
  final double horizontal;
  final double vertical;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: bgColor),
      child: child,
    );
  }
}

class RectangleBtnZin extends StatelessWidget {
  const RectangleBtnZin({
    super.key,
    this.bgColor = mainColor,
    this.child,
    this.horizontal = 8,
    this.vertical = 8,
    this.width = double.infinity,
    this.isFullWidth = false,
    required this.onTap,
  });
  final Color bgColor;
  final Widget? child;
  final double horizontal;
  final double vertical;
  final double width;
  final VoidCallback? onTap;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? width : null,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(bgColor),
          enableFeedback: true,
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          elevation: WidgetStateProperty.all<double>(0),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          ),
        ),
        onPressed: onTap,
        child: child,
      ),
    );
  }
}
