import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder;
import 'package:tomnenh/screen/auth_screen/auth_cubit.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/build_btn_text_icon.dart';
import 'package:tomnenh/widget/circle_btn.dart';
import 'package:tomnenh/widget/text_form_field_custom.dart';
import 'package:tomnenh/widget/text_widget.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  static const String routeName = "register";

  final screenCubit = AuthCubit();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController confirmPassWordController =
      TextEditingController();

  Future<void> register(BuildContext context) async {
    final Map<String, dynamic> data = {
      "name": userNameController.text,
      "email": emailController.text,
      "photo": "",
      "password": passWordController.text,
      "password_confirmation": confirmPassWordController.text,
    };
    final result = await screenCubit.register(data);
    print("===================hello${result}");
    if (result) {
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              left: 16,
              top: 32,
              child: CirCleBtn(
                onTap: () => Navigator.pop(context),
                iconSvg: arrowBackSvg,
                colorIconSvg: textSearchColor,
              )),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 200.0,
              height: 150,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(componentsPng),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 100,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      100, // Ensure scrolling
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    const TextWidget(
                        text: "Create Account ",
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                    const TextWidget(
                      text: "Let's fill your information below.",
                      fontSize: 20,
                      color: textSearchColor,
                    ),
                    const SizedBox(height: 16),
                    TextFormFieldCustom(
                      hinText: "Your name",
                      textEditingController: userNameController,
                      prefixIcon: const Icon(
                        Icons.person,
                        color: textSearchColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormFieldCustom(
                      hinText: "Exampl@gmail.com",
                      textEditingController: emailController,
                      prefixIcon: const Icon(
                        Icons.email,
                        color: textSearchColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormFieldCustom(
                      hinText: "Password",
                      textEditingController: passWordController,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: textSearchColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormFieldCustom(
                      hinText: "Confirm Password",
                      textEditingController: confirmPassWordController,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: textSearchColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: BlocBuilder<AuthCubit, AuthState>(
                        bloc: screenCubit,
                        builder: (context, state) {
                          return buildBtnTextIcon(
                              context, state.isLoadingLogin);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextWidget(text: "Already have an account?"),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, "/login"),
              child: const TextWidget(
                text: "Sign In",
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            )
          ],
        )
      ],
    );
  }

  IntrinsicWidth buildBtnTextIcon(BuildContext context, bool isLoading) {
    return IntrinsicWidth(
      child: BuildBtnTextIcon(
        isLoadingIcon: isLoading,
        onTap: () => register(context),
      ),
    );
  }
}
