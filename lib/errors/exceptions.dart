import 'package:flutter/material.dart';
import 'package:tomnenh/constant/constants.dart';
import 'package:tomnenh/widget/text_widget.dart';

class ServerException implements Exception {}

class CacheException implements Exception {}

class NetworkException implements Exception {}

///can be used for throwing [NoInternetException]
class NoInternetException implements Exception {
  late String _message;

  NoInternetException([String message = errorInternetMessage]) {
    if (scaffoldMessengerKey.currentState != null) {
      scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        backgroundColor: Colors.amber.shade300,
        content: TextWidget(text: message),
      ));
    }

    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}
