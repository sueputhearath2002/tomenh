import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomnenh/datas/models/user_model.dart';
import 'package:tomnenh/helper/database_helper.dart';
import 'package:tomnenh/screen/auth_screen/auth_cubit.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/circle_btn.dart';
import 'package:tomnenh/widget/image_network.dart';
import 'package:tomnenh/widget/rectangle_btn.dart';
import 'package:tomnenh/widget/text_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String routeName = "profile";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final screenCubit = AuthCubit();
  final databaseHelper = DatabaseHelper();

  logoutUser(BuildContext context) async {
    final result = await screenCubit.logOutUser();
    if (result) {
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    }
  }

  @override
  void initState() {
    screenCubit.getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        persistentFooterButtons: [
          RectangleBtnZin(
            onTap: () => logoutUser(context),
            isFullWidth: true,
            child: const TextWidget(
              text: "Logout",
              color: whiteColor,
            ),
          )
        ],
        body: BlocBuilder<AuthCubit, AuthState>(
          bloc: screenCubit,
          builder: (context, state) {
            final user = state.user;
            print("=============asdfasd============$user");
            return Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(64),
                            // bottomRight: Radius.circular(100),
                          )),
                    ),
                    buildInfo(user),
                    Positioned(
                      left: 16,
                      child: SafeArea(
                        child: CirCleBtn(
                          onTap: () => Navigator.pop(context),
                          iconSvg: arrowBackSvg,
                          paddingIconSvg: 8,
                          colorIconSvg: textSearchColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const ListTile(
                  leading: Icon(
                    Icons.policy,
                    color: mainColor,
                  ),
                  minTileHeight: 20,
                  title: TextWidget(text: "Privacy Policy"),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.list_alt_outlined,
                    color: mainColor,
                  ),
                  minTileHeight: 20,
                  title: TextWidget(text: "View Leave request"),
                ),
              ],
            );
          },
        ));
  }

  Widget buildInfo(UserModel? data) {
    return Positioned(
      bottom: 16,
      left: 16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: const ImageNetWorkWidget(
              width: 100,
              height: 100,
              imageUrl:
                  "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D",
            ),
          ),
          SizedBox(
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: data?.student?.name ?? "",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                TextWidget(
                  text: data?.student?.email ?? "",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                TextWidget(
                  text: "${data?.role ?? ""}",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
