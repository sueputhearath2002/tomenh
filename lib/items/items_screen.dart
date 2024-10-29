import 'package:flutter/material.dart';
import 'package:tomnenh/drawer/drawer.dart';
import 'package:tomnenh/items/card_item.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/circle_btn.dart';

class ItemsScreen extends StatelessWidget {
  ItemsScreen({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const Drawer(
        child: DrawerPath(),
      ),
      appBar: AppBar(
        centerTitle: false,
        leading: InkWell(
          onTap: () => _key.currentState!.openDrawer(),
          child: const Icon(
            Icons.filter_list_outlined,
            color: greenColor,
          ),
        ),
        title: Image.asset("assets/images/tomnenh.png"),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: CirCleBtn(
              width: 36,
              height: 40,
              isRedNote: true,
              iconSvg: bellSvg,
              paddingIconSvg: 8,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: CardItem(),
          );
        },
      ),
    );
  }
}
