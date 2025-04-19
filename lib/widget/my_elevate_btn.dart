import 'package:flutter/material.dart';
import 'package:tomnenh/style/colors.dart';

class MyElevatedButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double horizontal;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final Widget child;

  const MyElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.width,
    this.height = 45.0,
    this.gradient = const LinearGradient(colors: [secondaryColor, mainColor]),
    this.horizontal = 16,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
          enableFeedback: true,
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          elevation: WidgetStateProperty.all<double>(0),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: horizontal),
          ),
        ),
        child: child,
      ),
    );
  }
}
