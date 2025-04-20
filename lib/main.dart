import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tomnenh/datas/models/user_model.dart';
import 'package:tomnenh/helper/database_helper.dart';
import 'package:tomnenh/injection.dart';
import 'package:tomnenh/navigators/navigator.dart';
import 'package:tomnenh/screen/global_cubit.dart';
import 'package:tomnenh/style/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocator();
  UserModel? user = await DatabaseHelper.instance.getUser();
  runApp(FaceDetection(user: user));
}

class FaceDetection extends StatelessWidget {
  const FaceDetection({super.key, this.user});
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GlobalCubit()..getInfo()),
      ],
      child: BlocBuilder<GlobalCubit, GlobalState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                color: greyColor,
                surfaceTintColor: Colors.transparent,
              ),
              fontFamily: GoogleFonts.dmSans().fontFamily,
              scaffoldBackgroundColor: whiteColor,

              dividerTheme: const DividerThemeData(
                color: Colors.transparent,
              ),
              // colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
              useMaterial3: true,
            ),
            onGenerateRoute: (settings) =>
                AppNavigator.appRoute(settings: settings, user: user),
            navigatorKey: NavKeys.main,
          );
        },
      ),
    );
  }
}

class NavKeys {
  static final GlobalKey<NavigatorState> main = GlobalKey();
}
