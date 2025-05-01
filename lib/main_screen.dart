import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tomnenh/dashboard/dashboard_screen.dart';
import 'package:tomnenh/datas/models/user_model.dart';
import 'package:tomnenh/helper/database_helper.dart';
import 'package:tomnenh/helper/helper.dart';
import 'package:tomnenh/screen/global_cubit.dart';
import 'package:tomnenh/screen/list_attendance_screen.dart';
import 'package:tomnenh/screen/uploads/face_scan_page_v2.dart';
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

  SpeedDial buildOptionForAdmin() {
    return Helper.buildSpeedDial(
      speedDialChild: [
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

  SpeedDial buildOptionForStudent() {
    return Helper.buildSpeedDial(
      speedDialChild: [
        SpeedDialChild(
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.photo_camera_front_rounded, color: mainColor),
          backgroundColor: secondaryColor,
          onTap: () =>
              Navigator.pushNamed(context, FaceScannerPageV2.routeName),
          label: 'Upload Image',
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: mainColor,
        ),
        SpeedDialChild(
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.edit_calendar, color: mainColor),
          backgroundColor: secondaryColor,
          onTap: () =>
              Navigator.pushNamed(context, UploadFaceDetectionScreen.routeName),
          label: 'Leave Request',
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: mainColor,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = context.read<GlobalCubit>().state.user?.role;
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        return Scaffold(
          body: pageViewCustom(),
          floatingActionButtonLocation: role?.first == "student"
              ? FloatingActionButtonLocation.endFloat
              : FloatingActionButtonLocation.centerDocked,
          floatingActionButton: BlocBuilder<GlobalCubit, GlobalState>(
            builder: (context, state) {
              if (role?.first == "student") {
                return buildOptionForStudent();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: buildOptionForAdmin(),
                ),
              );
            },
          ),
          bottomNavigationBar: role?.first == "student"
              ? null
              : NavigationBar(
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
                  ],
                ),
        );
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
