import 'package:flutter/material.dart';
import 'package:tomnenh/create/set_up_category.dart';
import 'package:tomnenh/create/set_up_customer.dart';
import 'package:tomnenh/create/set_up_product.dart';
import 'package:tomnenh/create/set_up_unit.dart';
import 'package:tomnenh/dashboard/dashboard_screen.dart';
import 'package:tomnenh/datas/models/user_model.dart';
import 'package:tomnenh/main_screen.dart';
import 'package:tomnenh/screen/auth_screen/login_screen.dart';
import 'package:tomnenh/screen/auth_screen/sign_up_screen.dart';
import 'package:tomnenh/screen/category_screen.dart';
import 'package:tomnenh/screen/product_screen.dart';
import 'package:tomnenh/screen/uploads/upload_face_detection_screen.dart';
import 'package:tomnenh/screen/uploads/upload_soure_file_label.dart';
import 'package:tomnenh/upload_image_with_ml_kit/upload_image_screen.dart';

class AppNavigator {
  static Route<dynamic>? appRoute({
    required RouteSettings settings,
    UserModel? user,
  }) {
    switch (settings.name) {
      case '/':
        if (user == null) {
          return MaterialPageRoute(builder: (_) => LoginScreen());
        } else {
          return MaterialPageRoute(builder: (_) => const MainScreen());
        }
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case '/set_up_product':
        return MaterialPageRoute(builder: (_) => const SetupProduct());
      case '/set_up_unit':
        return MaterialPageRoute(builder: (_) => const SetUpUnit());
      case '/set_up_customer':
        return MaterialPageRoute(builder: (_) => const SetUpCustomer());
      case '/upload_image':
        return MaterialPageRoute(builder: (_) => const UploadImageScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case SetUpCategory.routeName:
        return MaterialPageRoute(builder: (_) => const SetUpCategory());
      case CategoryScreen.routeName:
        return MaterialPageRoute(builder: (_) => const CategoryScreen());
      case ProductScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ProductScreen());
      case UploadFaceDetectionScreen.routeName:
        return MaterialPageRoute(
            builder: (_) => const UploadFaceDetectionScreen());
      case UploadSourceFileLabel.routeName:
        return MaterialPageRoute(builder: (_) => const UploadSourceFileLabel());
      // case '/details':
      //   final args = settings.arguments as DetailsArguments;
      //   return MaterialPageRoute(builder: (_) => DetailsScreen(args: args));
      // Add more routes here as needed
      default:
        return MaterialPageRoute(builder: (_) => const MainScreen());
    }
  }
}
