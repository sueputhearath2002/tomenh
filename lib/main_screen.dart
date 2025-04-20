import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tomnenh/dashboard/dashboard_screen.dart';
import 'package:tomnenh/datas/models/user_model.dart';
import 'package:tomnenh/helper/database_helper.dart';
import 'package:tomnenh/screen/global_cubit.dart';
import 'package:tomnenh/screen/list_attendance_screen.dart';
import 'package:tomnenh/screen/uploads/upload_face_detection_screen.dart';
import 'package:tomnenh/screen/uploads/upload_soure_file_label.dart';
import 'package:tomnenh/style/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  UserModel? user;
  List<IconData> listOfIcons = [
    Icons.dashboard,
    Icons.featured_play_list_rounded,
  ];
  List<String> listLabel = [
    "Today",
    "Month",
  ];
  List<Widget> listOfWidget = [
    const DashboardScreen(),
    ListAttendanceScreen(),
  ];
  PageController pageController =
      PageController(viewportFraction: 1, keepPage: true);
  int selectIndex = 0;

  @override
  void initState() {
    context.read<GlobalCubit>().getInfo();
    super.initState();
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      elevation: 0,
      animatedIcon: AnimatedIcons.add_event,
      animatedIconTheme: const IconThemeData(size: 28.0),
      backgroundColor: mainColor,
      foregroundColor: Colors.white,
      visible: true,
      activeIcon: Icons.close,
      curve: Curves.bounceInOut,
      children: [
        SpeedDialChild(
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.upload_file_rounded, color: mainColor),
          backgroundColor: secondaryColor,
          onTap: () =>
              Navigator.pushNamed(context, UploadSourceFileLabel.routeName),
          label: 'Upload file',
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: mainColor,
        ),
        SpeedDialChild(
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.group, color: mainColor),
          backgroundColor: secondaryColor,
          onTap: () =>
              Navigator.pushNamed(context, UploadFaceDetectionScreen.routeName),
          label: 'Take Photo',
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: mainColor,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pageViewCustom(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: BlocBuilder<GlobalCubit, GlobalState>(
          builder: (context, state) {
            final role = context.read<GlobalCubit>().state.user?.role;
            return Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                width: 50,
                height: 50,
                child: role?.first == "student"
                    ? addButtonWidget(role, context)
                    : buildSpeedDial(),
              ),
            );
          },
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
            ]));
  }

  FloatingActionButton addButtonWidget(
      List<String>? role, BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      shape: const CircleBorder(side: BorderSide(color: mainColor)),
      backgroundColor: mainColor,
      child: const Icon(
        Icons.add,
        color: whiteColor,
      ),
      onPressed: () {
        // role?.first != "student"
        //     ? Navigator.pushNamed(context, UploadFaceDetectionScreen.routeName)
        //     : null;
      },
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
