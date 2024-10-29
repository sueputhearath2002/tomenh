import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/rectangle_btn.dart';

class CardItem extends StatelessWidget {
  const CardItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [greenColor, green50Color],
              ),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "12 Jun 2021",
                style: TextStyle(color: whiteColor),
              ),
              const SizedBox(height: 5),
              const Text(
                "User Name",
                style: TextStyle(
                    color: whiteColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: '30 items', style: TextStyle(color: whiteColor)),
                    TextSpan(
                      text: '  |',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: whiteColor),
                    ),
                    TextSpan(
                      text: '  30000 Riel',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: whiteColor),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  Row(
                    children: [
                      btnWidget(
                          title: "Delete",
                          icon: delete,
                          bgColor: redColor,
                          onTap: () {
                            print("object");
                          }),
                      const SizedBox(width: 16),
                      btnWidget(
                          title: "View", icon: delete, bgColor: greenColor),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: greenColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: const Text(
              "Paid",
              style: TextStyle(fontWeight: FontWeight.w600, color: whiteColor),
            ),
          ),
        )
      ],
    );
  }

  Widget btnWidget({
    String icon = "",
    title = "",
    VoidCallback? onTap,
    Color bgColor = redColor,
  }) {
    return RectangleBtnZin(
      bgColor: bgColor,
      onTap: onTap,
      horizontal: 16,
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 16,
            height: 16,
          ),
          const SizedBox(width: 5),
          Text(
            title,
            style: const TextStyle(color: whiteColor),
          ),
        ],
      ),
    );
  }
}
