import 'package:fluttertoast/fluttertoast.dart';
import 'package:tomnenh/style/colors.dart';

class Helper {
  static showMessage({required String msg}) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: mainColor,
      textColor: whiteColor,
      fontSize: 14.0,
    );
  }
}

//
//
//
//
// Fluttertoast.showToast(
// msg: "Login successful!",
// toastLength: Toast.LENGTH_SHORT,
// gravity: ToastGravity.BOTTOM,
// backgroundColor: Colors.black87,
// textColor: Colors.white,
// fontSize: 16.0,
// );
