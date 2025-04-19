import 'package:flutter/material.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/card_custome.dart';
import 'package:tomnenh/widget/circle_btn.dart';
import 'package:tomnenh/widget/text_widget.dart' show TextWidget;

class BuildCardDasboard extends StatelessWidget {
  const BuildCardDasboard({
    super.key,
    this.icon = "",
    this.bgColor = greenColor,
    this.iconColor = greenColor,
    this.label = "",
    this.value = "",
  });

  final String icon;
  final Color bgColor;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CardCustom(
        horizontal: 16,
        colorCard: bgColor,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            CirCleBtn(
              iconSvg: icon,
              width: 30,
              colorContainer: whiteColor,
              colorIconSvg: iconColor,
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: label,
                  fontSize: 16,
                  color: whiteColor,
                ),
                TextWidget(
                  text: value,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: whiteColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
