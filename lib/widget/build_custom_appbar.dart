import 'package:flutter/material.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/circle_btn.dart' show CirCleBtn;
import 'package:tomnenh/widget/image_network.dart';
import 'package:tomnenh/widget/text_widget.dart';

class BuildCustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const BuildCustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: whiteColor,
      centerTitle: false,
      titleSpacing: 16,
      automaticallyImplyLeading: false,
      title: const Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: "Hi, Kim dara. ",
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              TextWidget(
                text: "Student.",
                fontSize: 14,
              )
            ],
          ),
        ],
      ),
      actions: [
        InkWell(
          onTap: () => Navigator.pushNamed(context, '/login'),
          child: const ImageNetWorkWidget(
            width: 30,
            height: 30,
            imageUrl:
                "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D",
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: CirCleBtn(
            width: 30,
            height: 30,
            isRedNote: true,
            colorContainer: whiteColor,
            iconSvg: notificationSvg,
            paddingIconSvg: 8,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
