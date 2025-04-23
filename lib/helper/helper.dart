import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
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

  static Future<File> downloadFile(String url, String filename) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Get the app's documents directory
      final dir = await getApplicationDocumentsDirectory();

      final file = File('${dir.path}/$filename');

      if (await file.exists()) {
        await file.delete();
      }

      await file.writeAsBytes(response.bodyBytes);

      return file;
    } else {
      throw Exception('Failed to download file');
    }
  }

  static Future<File?> getLocalModelFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$filename';
    final file = File(path);
    if (await file.exists()) {
      return file;
    } else {
      return null; // File not downloaded yet
    }
  }

  static buildSpeedDial({required List<SpeedDialChild> speedDialChild}) {
    return SpeedDial(
      elevation: 0,
      animatedIcon: AnimatedIcons.add_event,
      animatedIconTheme: const IconThemeData(size: 28.0),
      backgroundColor: mainColor,
      foregroundColor: Colors.white,
      visible: true,
      activeIcon: Icons.close,
      curve: Curves.bounceInOut,
      children: speedDialChild,
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
