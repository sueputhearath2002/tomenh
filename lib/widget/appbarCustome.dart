import 'package:flutter/material.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/circle_btn.dart';

class AppbarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppbarCustom({super.key, this.title = ""});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: CirCleBtn(
            iconSvg: backSvg,
            paddingIconSvg: 12,
            width: 40,
            height: 40,
            onTap: () => Navigator.pop(context),
            colorContainer: green50Color.withOpacity(0.3),
          ),
        ));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
