import 'package:flutter/material.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/text_widget.dart';

class ElevatedBtnCus extends StatelessWidget {
  const ElevatedBtnCus({
    super.key,
    this.iconColor = Colors.white,
    this.isFullWidth = true,
    this.isLoading = false, // <-- added
    this.onTap,
    this.btnName = "",
    this.btnNameColor = Colors.white,
    this.gradientColors = const [mainColor, mainColor],
    this.icon,
  });

  final Color iconColor;
  final bool isFullWidth;
  final bool isLoading; // <-- added
  final VoidCallback? onTap;
  final String btnName;
  final Color btnNameColor;
  final List<Color> gradientColors;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors, // same gradient inside
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onTap, // disable when loading
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: iconColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                      ],
                      TextWidget(
                        text: btnName,
                        fontWeight: FontWeight.w600,
                        color: btnNameColor,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
