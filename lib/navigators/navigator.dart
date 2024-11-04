import 'package:flutter/material.dart';
import 'package:tomnenh/create/set_up_category.dart';
import 'package:tomnenh/create/set_up_customer.dart';
import 'package:tomnenh/create/set_up_product.dart';
import 'package:tomnenh/create/set_up_unit.dart';
import 'package:tomnenh/dashboard/dashboard_screen.dart';
import 'package:tomnenh/main_screen.dart';
import 'package:tomnenh/screen/category_screen.dart';
import 'package:tomnenh/screen/product_screen.dart';

class AppNavigator {
  static Route<dynamic>? appRoute({required RouteSettings settings}) {
    switch (settings.name) {
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case '/set_up_product':
        return MaterialPageRoute(builder: (_) => const SetupProduct());
      case '/set_up_unit':
        return MaterialPageRoute(builder: (_) => const SetUpUnit());
      case '/set_up_customer':
        return MaterialPageRoute(builder: (_) => const SetUpCustomer());
      case SetUpCategory.routeName:
        return MaterialPageRoute(builder: (_) => const SetUpCategory());
      case CategoryScreen.routeName:
        return MaterialPageRoute(builder: (_) => const CategoryScreen());
        case ProductScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ProductScreen());
      // case '/details':
      //   final args = settings.arguments as DetailsArguments;
      //   return MaterialPageRoute(builder: (_) => DetailsScreen(args: args));
      // Add more routes here as needed
      default:
        return MaterialPageRoute(builder: (_) => const MainScreen());
    }
  }
}
