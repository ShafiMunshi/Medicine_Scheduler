import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomSnackBar {
  static showCustomSnackBar(
      {required String title,
      required String message,
      Duration? duration,
      required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: duration ?? const Duration(seconds: 2),
        backgroundColor: Colors.green,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        )));
  }

  static showCustomErrorSnackBar(
      {required String title,
      required String message,
      Color? color,
      required BuildContext context,
      Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: duration ?? const Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        )));
  }

  static showCustomToast(
      {required String message, Color? color, Duration? duration}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: color,
    );
  }

  static showCustomErrorToast(
      {required String message, Color? color, Duration? duration}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: color?? Colors.red,
    );
  }
}
