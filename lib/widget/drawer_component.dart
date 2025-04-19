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
    this.titleColor = textColor,
    this.iconColor = textColor,
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
      child: ListTile(
        leading: SvgPicture.asset(icon,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn)),
        title: Text(
          title,
          style: TextStyle(color: titleColor),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: textSearchColor,
          size: 18,
        ),
      ),
    );
  }
}
