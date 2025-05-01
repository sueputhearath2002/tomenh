import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, ReadContext;
import 'package:tomnenh/main_screen.dart';
import 'package:tomnenh/screen/auth_screen/auth_cubit.dart';
import 'package:tomnenh/screen/global_cubit.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/my_elevate_btn.dart';
import 'package:tomnenh/widget/text_form_field_custom.dart';
import 'package:tomnenh/widget/text_widget.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "login";

  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final screenCubit = AuthCubit();

  Future<void> login(BuildContext context) async {
    final Map<String, dynamic> data = {
      "email": emailController.text,
      "password": passwordController.text,
    };
    final result = await screenCubit.login(data);
    print("=======dddd===========$result");
    if (result) {
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false);
      context.read<GlobalCubit>().getInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    emailController.text = "dara@gmail.com";
    passwordController.text = "123123";
    return Scaffold(
      body: Stack(
        children: [
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
          Positioned(
            top: 100,
            left: 16,
            right: 16,
            child: Column(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                const TextWidget(
                    text: "Login ", fontSize: 40, fontWeight: FontWeight.bold),
                const TextWidget(
                  text: "Please sign in to continue",
                  fontSize: 20,
                  color: textSearchColor,
                ),
                const SizedBox(height: 8),
                TextFormFieldCustom(
                  hinText: "Example@gmail.com",
                  textEditingController: emailController,
                  prefixIcon: const Icon(
                    Icons.email,
                    color: textSearchColor,
                  ),
                ),
                TextFormFieldCustom(
                  hinText: "Password",
                  textEditingController: passwordController,
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: textSearchColor,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    spacing: 16,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: const TextWidget(
                            text: "Forget Password?",
                            decoration: TextDecoration.underline,
                          )),
                      BlocBuilder<AuthCubit, AuthState>(
                        bloc: screenCubit,
                        builder: (context, state) {
                          return buildBtnLogin(context,
                              isLoading: state.isLoadingLogin);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextWidget(text: "Don't have an account?"),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, "/register"),
              child: const TextWidget(
                text: "Sign Up",
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget buildBtnLogin(BuildContext context, {bool isLoading = true}) {
    return IntrinsicWidth(
      child: MyElevatedButton(
        onPressed: () => login(context),
        borderRadius: BorderRadius.circular(32),
        child: Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextWidget(
              text: "Login",
              color: whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      color: whiteColor,
                      strokeWidth: 1,
                    ))
                : const Icon(
                    Icons.arrow_forward,
                    color: whiteColor,
                  )
          ],
        ),
      ),
    );
  }
}
