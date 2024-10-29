import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomnenh/dashboard/dashboard_screen.dart';
import 'package:tomnenh/items/items_screen.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> listOfIcons = [
    dashboardSvg,
    listItems,
  ];
  List<String> listLabel = [
    "Dashboard",
    "Items",
  ];
  List<Widget> listOfWidget = [
    DashboardScreen(),
    ItemsScreen(),
  ];
  PageController pageController =
      PageController(viewportFraction: 1, keepPage: true);
  int selectIndex = 0;
  // final screenCubit = HomeCubit();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageViewCustome(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SizedBox(
          width: 50,
          height: 50,
          child: FloatingActionButton(
            shape: const CircleBorder(side: BorderSide(color: green50Color)),
            backgroundColor: greenColor,
            child: const Icon(
              Icons.add,
              color: whiteColor,
            ),
            onPressed: () {
              setState(() {
                // print(listOfIcons[0]);
                //selectIndex = index;
                // pageController.jumpToPage(2);
              });
              //Navigator.pushNamed(context, CartScreen.routeName);
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectIndex,
        elevation: 2,
        onTap: (value) {
          setState(() {
            selectIndex = value;
          });
          pageController.jumpToPage(selectIndex);
        },
        selectedItemColor: whiteColor,
        unselectedItemColor: green50Color,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedLabelStyle:
            const TextStyle(color: green50Color, fontSize: 14),
        enableFeedback: true,
        backgroundColor: greenColor,
        items: List.generate(
          listOfIcons.length,
          (index) => BottomNavigationBarItem(
            backgroundColor: greenColor,
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                listOfIcons[index].toString(),
                colorFilter: ColorFilter.mode(
                    selectIndex == index ? whiteColor : green50Color,
                    BlendMode.srcIn),
                width: 26,
                height: 26,
              ),
            ),
            label: listLabel[index],
          ),
        ),
      ),
    );
  }

  Widget pageViewCustome() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      children:
          List.generate(listOfWidget.length, (index) => listOfWidget[index]),
    );
  }
}
