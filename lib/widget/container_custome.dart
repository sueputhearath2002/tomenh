import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomnenh/style/colors.dart';

class ContainerCustom extends StatelessWidget {
  const ContainerCustom({
    super.key,
    this.title = "",
    this.value = "",
    this.icon = "",
  });
  final String title;
  final String value;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
              color: green50Color, borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    icon,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                        svgColor.withOpacity(0.5), BlendMode.srcIn),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                  color: greenColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: whiteColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
        Positioned(
          bottom: 0,
          left: 10,
          right: 0,
          top: 8,
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              color: greenColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            decoration: const BoxDecoration(
                color: greenColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8))),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: const Icon(
              Icons.compare_arrows_rounded,
              size: 20,
              color: whiteColor,
            ),
          ),
        )
      ],
    );
  }
}
