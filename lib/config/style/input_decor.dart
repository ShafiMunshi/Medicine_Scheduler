
import 'package:flutter/material.dart';
import 'package:medicine_app/constant/app_color.dart';

import 'package:nb_utils/nb_utils.dart';

InputDecoration inputDecoration(
    {Widget? suffixIcon,
    Widget? prefixIcon,
    String? labelText,
    double? borderRadius,
    bool isPhoneNumberField = false}) {
  return InputDecoration(
    contentPadding: EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    labelStyle: secondaryTextStyle(),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: isPhoneNumberField
          ? BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            )
          : radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: AppColors.primaryColor, width: 0.0),
    ),
    filled: true,
    fillColor: gray.withOpacity(0.1),
  );
}