import 'package:flutter/material.dart';
import 'package:medicine_app/constant/app_color.dart';

AppBar commonAppbar(String title,
    [List<Widget>? actions, bool showBack = true]) {
  return AppBar(
    backgroundColor: AppColors.primaryColor,
    centerTitle: true,
    // leading: showBack
    //     ? IconButton(
    //         onPressed: () {
    //           Get.back();
    //         },
    //         icon: const Icon(
    //           Icons.reply,
    //           color: Colors.white,
    //         ),
    //       )
    //     : SizedBox(),
    title: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
    actions: actions,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20.0), // Adjust as needed
        bottomRight: Radius.circular(20.0),
      ),
    ),
  );
}
