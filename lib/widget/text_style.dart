import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  static TextStyle baseStyle({Color color = Colors.black, double size = 14, FontWeight fontWeight = FontWeight.normal}) {
    return GoogleFonts.dmSans(
      fontSize: size,
      color: color,
      fontWeight: fontWeight,
    );
  }

  // Specific text styles
  static TextStyle headline({Color color = Colors.black}) => baseStyle(size: 24, fontWeight: FontWeight.bold, color: color);
  static TextStyle subheadline({Color color = Colors.black}) => baseStyle(size: 20, fontWeight: FontWeight.w600, color: color);
  static TextStyle bodyText({Color color = Colors.black}) => baseStyle(size: 16, color: color);
  static TextStyle caption({Color color = Colors.grey}) => baseStyle(size: 12, color: color);
}
