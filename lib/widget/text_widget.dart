import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tomnenh/style/colors.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    this.text = "",
    this.fontSize = 14,
    this.maxLines = 2,
    this.fontWeight = FontWeight.normal,
    this.color = textSearchColor,
    this.decoration = TextDecoration.none,
  });
  final String text;
  final double fontSize;
  final int maxLines;
  final FontWeight fontWeight;
  final Color color;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      softWrap: true,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
        fontFamily: GoogleFonts.dmSans().fontFamily,
      ),
    );
  }
}
