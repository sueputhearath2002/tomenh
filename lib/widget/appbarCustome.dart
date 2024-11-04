import 'package:flutter/material.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/style/constant.dart';
import 'package:tomnenh/widget/circle_btn.dart';
import 'package:tomnenh/widget/text_form_field_custom.dart';

class AppbarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppbarCustom({super.key, this.title = "",  this.isShowSearch = false});
  final String title;
  final bool isShowSearch;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CirCleBtn(
                iconSvg: backSvg,
                paddingIconSvg: 12,
                width: 40,
                height: 40,
                onTap: () => Navigator.pop(context),
                colorContainer: whiteColor,
              ),
              gapW16,
              Text(title),
            ],
          ),
        ],
      ),

      bottom:isShowSearch? PreferredSize( preferredSize: preferredSize, child:searchWidget() ):null,
    );
  }
  Widget searchWidget(){
    return const Padding(
      padding: EdgeInsets.only(left: 16,right: 16),
      child: TextFormFieldCustom(
        titleTextField: "",
        hinText: "Search",
        prefixIcon: Icon(Icons.search,color: textColor,),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>  Size.fromHeight(isShowSearch?kToolbarHeight+60:kToolbarHeight);
}
