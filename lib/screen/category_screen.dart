import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tomnenh/create/set_up_category.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/style/constant.dart';
import 'package:tomnenh/widget/appbarCustome.dart';
import 'package:tomnenh/widget/image_network.dart';
import 'package:tomnenh/widget/text_style.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});
  static const String routeName = "/category";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: greenColor,
        shape: const CircleBorder(),
        onPressed: () =>Navigator.pushNamed(context,SetUpCategory.routeName),
        child: const Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
      appBar: const AppbarCustom(
        title: "Category",
        isShowSearch: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 10,
        itemBuilder: (context, index) {
          return  Padding(
            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
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
                  gapW8,
                  SlidableAction(
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: blueColor,
                    icon: Icons.edit,
                    onPressed: (context) {
                    },
                    label: 'Edit',

                  ),
                  gapW8,
                  SlidableAction(
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: redColor,
                    icon: Icons.delete,
                    onPressed: (context) {
                      
                    },
                    label: 'Delete',

                  ),
                ],
              ),
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: whiteColor,
                //margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    const ImageNetWorkWidget(width: 90, height: 90, imageUrl: ""),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Category 1",style: TextStyles.bodyText(),),
                        Text("Category 1 of description",style: TextStyles.baseStyle(color: textColor),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}