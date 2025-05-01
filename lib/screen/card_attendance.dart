import 'package:flutter/material.dart';
import 'package:tomnenh/datas/models/user_model.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/card_custome.dart';
import 'package:tomnenh/widget/image_network.dart';
import 'package:tomnenh/widget/text_widget.dart';

class CardAttendance extends StatelessWidget {
  const CardAttendance({super.key, required this.user});
  final Student user;

  @override
  Widget build(BuildContext context) {
    return CardCustom(
      horizontal: 0,
      colorCard: whiteColor,
      vertical: 2,
      borderColor: greyColor,
      shadowColor: greyColor,
      // colorCard: redColor.withValues(alpha: 0.1),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ImageNetWorkWidget(
                  width: 80,
                  height: 80,
                  bottomLeft: 8,
                  bottomRight: 8,
                  topLeft: 8,
                  topRight: 8,
                  imageUrl:
                      "https://images.icon-icons.com/2859/PNG/512/avatar_face_man_boy_male_profile_smiley_happy_people_icon_181657.png",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    TextWidget(
                      text: user.name ?? "",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    TextWidget(
                      text: user.email ?? "",
                    ),
                    const Row(
                      spacing: 4,
                      children: [
                        Icon(
                          Icons.check_box,
                          size: 16,
                          color: redColor,
                        ),
                        TextWidget(
                          text: "Absent",
                          color: redColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
