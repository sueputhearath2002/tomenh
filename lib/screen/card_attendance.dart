import 'package:flutter/material.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/card_custome.dart';
import 'package:tomnenh/widget/text_widget.dart';

class CardAttendance extends StatelessWidget {
  const CardAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return CardCustom(
      horizontal: 0,
      vertical: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 6,
                height: 80,
                decoration: const BoxDecoration(
                  color: redColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    TextWidget(
                      text: "Sue Puthearath",
                      fontWeight: FontWeight.bold,
                    ),
                    Row(
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
                    Text.rich(TextSpan(children: [
                      TextSpan(text: "Reason: "),
                      TextSpan(
                        text: "Today i'm sick. ",
                      )
                    ]))
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: TextWidget(
              text: "12-04-2025",
              color: redColor,
            ),
          ),
        ],
      ),
    );
  }
}
