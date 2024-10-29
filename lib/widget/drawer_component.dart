import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomnenh/style/colors.dart';

class DrawerComponent extends StatelessWidget {
  const DrawerComponent({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.isShowDivider = true,
    this.titleColor = whiteColor,
    this.iconColor = whiteColor,
  });

  final String icon;
  final String title;
  final VoidCallback? onTap;
  final bool isShowDivider;
  final Color titleColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(icon,
                        colorFilter:
                            ColorFilter.mode(iconColor, BlendMode.srcIn)),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(color: titleColor),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: whiteColor,
                  size: 18,
                ),
              ],
            ),
          ),
          if (isShowDivider)
            const Divider(
              thickness: 0.5,
              color: whiteColor,
            ),
        ],
      ),
    );
  }
}
