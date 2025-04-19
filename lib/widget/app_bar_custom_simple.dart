import 'package:flutter/material.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/circle_btn.dart';
import 'package:tomnenh/widget/text_form_field_custom.dart';
import 'package:tomnenh/widget/text_widget.dart';

class AppbarCustomSimple extends StatelessWidget
    implements PreferredSizeWidget {
  const AppbarCustomSimple({
    super.key,
    this.title = "",
    this.isShowSearch = false,
  });
  final String title;
  final bool isShowSearch;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: whiteColor,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 16,
            children: [
              CirCleBtn(
                onTap: () => Navigator.pop(context),
                iconSvg: arrowBackSvg,
                paddingIconSvg: 8,
                colorIconSvg: textSearchColor,
              ),
              TextWidget(
                text: title,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
      bottom: isShowSearch
          ? PreferredSize(preferredSize: preferredSize, child: searchWidget())
          : null,
    );
  }

  Widget searchWidget() {
    return const Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: TextFormFieldCustom(
        titleTextField: "",
        hinText: "Search",
        prefixIcon: Icon(
          Icons.search,
          color: textColor,
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>
      Size.fromHeight(isShowSearch ? kToolbarHeight + 60 : kToolbarHeight);
}
