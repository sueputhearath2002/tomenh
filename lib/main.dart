import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tomnenh/navigators/navigator.dart';
import 'package:tomnenh/style/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: greyColor,surfaceTintColor: Colors.transparent),
        fontFamily: GoogleFonts.dmSans().fontFamily,
        scaffoldBackgroundColor: greyColor,

        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => AppNavigator.appRoute(settings: settings),
      navigatorKey: NavKeys.main,
    );
  }
}

class NavKeys {
  static final GlobalKey<NavigatorState> main = GlobalKey();
}
