import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tomnenh/screen/category_screen.dart';
import 'package:tomnenh/screen/product_screen.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/drawer_component.dart';

class DrawerPath extends StatelessWidget {
  const DrawerPath({super.key});

  @override
  Widget build(BuildContext context) {
    return buildDrawer(context);
  }

  Widget buildDrawer(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [greenColor, green50Color],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profile(),
            DrawerComponent(
                icon: product,
                title: "Category",
                onTap: () => Navigator.pushNamed(context, CategoryScreen.routeName)),
            DrawerComponent(
                icon: product,
                title: "Product",
                onTap: () => Navigator.pushNamed(context, ProductScreen.routeName)),
            DrawerComponent(
                icon: unit,
                title: "Set up Unit",
                onTap: () => Navigator.pushNamed(context, "/set_up_unit")),
            DrawerComponent(
              icon: customer,
              title: "Set up Customer",
              onTap: () => Navigator.pushNamed(context, "/set_up_customer"),
            ),
            const DrawerComponent(icon: place, title: "Store or sell place"),
            const DrawerComponent(icon: status, title: "Set up status"),
            const Spacer(),
            const DrawerComponent(
                icon: logoutSvg,
                title: "Logout Account",
                isShowDivider: true,
                titleColor: redColor,
                iconColor: redColor),
            nameCompany(),
          ],
        ),
      ),
    );
  }

  Widget nameCompany() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: "Power by : ",
                style: TextStyle(fontSize: 14, color: whiteColor)),
            TextSpan(
              text: "Sue puthearath",
              style: TextStyle(fontSize: 12, color: whiteColor),
            ),
          ],
        ),
      ),
    );
  }

  Container profile() {
    return Container(
      color: greenColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.fill,
                      imageUrl:
                          "https://htmlstream.com/preview/unify-v2.6/assets/img-temp/400x450/img5.jpg",
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "User Name",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: whiteColor),
                    ),
                    Text(
                      "Admin",
                      style: TextStyle(fontSize: 16, color: whiteColor),
                    )
                  ],
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: whiteColor,
            )
          ],
        ),
      ),
    );
  }
}
