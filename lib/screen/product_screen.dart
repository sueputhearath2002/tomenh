import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/style/constant.dart';
import 'package:tomnenh/widget/app_bar_custom.dart';
import 'package:tomnenh/widget/image_network.dart';
import 'package:tomnenh/widget/my_separator.dart';
import 'package:tomnenh/widget/text_style.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});
  static const String routeName = "/product";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: greenColor,
        shape: const CircleBorder(),
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
      appBar: const AppbarCustom(
        title: "Product",
        isShowSearch: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Slidable(
              enabled: true,
              dragStartBehavior: DragStartBehavior.start,
              useTextDirection: true,
              key: const ValueKey(0),
              endActionPane: ActionPane(
                motion: const BehindMotion(),
                extentRatio: 0.5,
                dragDismissible: true,
                children: [
                  gapW(8),
                  SlidableAction(
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: blueColor,
                    icon: Icons.edit,
                    onPressed: (context) {},
                    label: 'Edit',
                  ),
                  gapW(8),
                  SlidableAction(
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: redColor,
                    icon: Icons.delete,
                    onPressed: (context) {},
                    label: 'Delete',
                  ),
                ],
              ),
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: whiteColor,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      const ImageNetWorkWidget(
                          width: 100,
                          height: 100,
                          imageUrl:
                              "https://brainmatics.id/wp-content/uploads/2016/03/book-4.jpg"),
                      gapW(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Category 1",
                              style: TextStyles.bodyText(),
                            ),
                            Text(
                              "Category 1 of description",
                              style: TextStyles.baseStyle(color: textColor),
                            ),
                            const SizedBox(height: 8),
                            const MySeparator(color: Colors.grey, height: 0.2),
                            Chip(
                              label: Text(
                                "50 items",
                                style: TextStyles.caption(color: whiteColor),
                              ),
                              backgroundColor: Colors.green.withOpacity(0.8),
                              elevation: 0,
                              side: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.transparent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
