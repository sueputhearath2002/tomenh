import 'package:flutter/material.dart';
import 'package:tomnenh/dashboard/dashboard_screen.dart';
import 'package:tomnenh/screen/list_attendance_screen.dart';
import 'package:tomnenh/screen/upload_face_detection_screen.dart';
import 'package:tomnenh/style/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<IconData> listOfIcons = [
    Icons.dashboard,
    Icons.featured_play_list_rounded,
  ];
  List<String> listLabel = [
    "Today",
    "Month",
  ];
  List<Widget> listOfWidget = [
    DashboardScreen(),
    ListAttendanceScreen(),
  ];
  PageController pageController =
      PageController(viewportFraction: 1, keepPage: true);
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pageViewCustom(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              elevation: 0,
              shape: const CircleBorder(side: BorderSide(color: mainColor)),
              backgroundColor: mainColor,
              child: const Icon(
                Icons.add,
                color: whiteColor,
              ),
              onPressed: () {
                Navigator.pushNamed(
                    context, UploadFaceDetectionScreen.routeName);
              },
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
            selectedIndex: selectIndex,
            elevation: 2,
            indicatorColor: secondaryColor,
            surfaceTintColor: whiteColor,
            backgroundColor: whiteColor,
            height: 65,
            onDestinationSelected: (int index) {
              setState(() {
                selectIndex = index;
              });
              pageController.jumpToPage(selectIndex);
            },
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.dashboard,
                  color: selectIndex == 0 ? mainColor : textSearchColor,
                ),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.event_note,
                  color: selectIndex == 1 ? mainColor : textSearchColor,
                ),
                label: 'Report',
              ),
            ])
        // BottomNavigationBar(
        //   currentIndex: selectIndex,
        //   elevation: 2,
        //   onTap: (value) {
        //     setState(() {
        //       selectIndex = value;
        //     });
        //     pageController.jumpToPage(selectIndex);
        //   },
        //   selectedItemColor: greenColor,
        //   unselectedItemColor: green50Color,
        //   showSelectedLabels: true,
        //   showUnselectedLabels: true,
        //   unselectedLabelStyle:
        //       const TextStyle(color: green50Color, fontSize: 14),
        //   enableFeedback: true,
        //   backgroundColor: whiteColor,
        //   items: List.generate(
        //     listOfIcons.length,
        //     (index) => BottomNavigationBarItem(
        //       //backgroundColor: greenColor,
        //       icon: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Icon(
        //           listOfIcons[index],
        //           size: 20,
        //         ),
        //         // child: SvgPicture.asset(
        //         //   listOfIcons[index].toString(),
        //         //   colorFilter: ColorFilter.mode(
        //         //       selectIndex == index ? greenColor : green50Color,
        //         //       BlendMode.srcIn),
        //         //   width: 26,
        //         //   height: 26,
        //         // ),
        //       ),
        //       label: listLabel[index],
        //     ),
        //   ),
        // ),
        );
  }

  Widget pageViewCustom() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      children:
          List.generate(listOfWidget.length, (index) => listOfWidget[index]),
    );
  }
}
