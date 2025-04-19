import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomnenh/style/colors.dart';

class CirCleBtn extends StatelessWidget {
  const CirCleBtn({
    super.key,
    required this.iconSvg,
    this.onTap,
    this.width = 30,
    this.height = 30,
    this.colorContainer = greyColor,
    this.colorIconSvg = textColor,
    this.paddingIconSvg = 8,
    this.isShadow = false,
    this.isRedNote = false,
  });
  final String iconSvg;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color colorContainer;
  final Color colorIconSvg;
  final double? paddingIconSvg;
  final bool? isShadow;
  final bool isRedNote;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                boxShadow: isShadow == true
                    ? [
                        const BoxShadow(
                          color: green50Color,
                          spreadRadius: 0,
                          blurRadius: 24,
                          offset: Offset(0, 8), // changes position of shadow
                        ),
                      ]
                    : null,
                color: colorContainer,
                shape: BoxShape.circle),
            child: Padding(
              padding: EdgeInsets.all(paddingIconSvg!),
              child: SvgPicture.asset(
                iconSvg,
                width: width,
                height: height,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(colorIconSvg, BlendMode.srcIn),
              ),
            ),
          ),
        ),
        if (isRedNote)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration:
                  const BoxDecoration(color: redColor, shape: BoxShape.circle),
            ),
          )
      ],
    );
  }
}
