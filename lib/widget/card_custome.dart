import 'package:flutter/material.dart';
import 'package:tomnenh/style/colors.dart';

class CardCustom extends StatelessWidget {
  const CardCustom({
    super.key,
    this.colorCard = greyColor,
    this.borderColor = greyColor,
    this.child,
    this.radius = 8,
    this.shadowColor = whiteColor,
    this.margin,
    this.horizontal = 8,
    this.vertical = 8,
  });
  final Color colorCard;
  final Color shadowColor;
  final Color borderColor;
  final Widget? child;
  final double radius;
  final EdgeInsetsGeometry? margin;
  final double horizontal;
  final double vertical;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(radius),
      ),
      margin: margin,
      color: colorCard,
      semanticContainer: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: () {},
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: child,
        ),
      ),
    );
  }
}
