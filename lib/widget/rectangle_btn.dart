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
    this.bgColor = greenColor,
    this.child,
    this.horizontal = 8,
    this.vertical = 8,
    this.width = double.infinity,
    required this.onTap,
  });
  final Color bgColor;
  final Widget? child;
  final double horizontal;
  final double vertical;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.isNaN ? width : 100,
      child: ElevatedButton(
        style: ButtonStyle(
          // foregroundColor: MaterialStateProperty.all<Color>(whiteColor),
          // overlayColor: MaterialStateProperty.all<Color>(whiteColor),
          backgroundColor: MaterialStateProperty.all<Color>(bgColor),
          enableFeedback: true,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          elevation: MaterialStateProperty.all<double>(0),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          ),
        ),
        onPressed: onTap,
        child: child,
      ),
    );
  }
}
