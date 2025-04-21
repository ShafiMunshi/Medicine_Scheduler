import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:medicine_app/constant/app_color.dart';

BoxDecoration boxDecorations(
    {double radius = 8,
    Color color = Colors.transparent,
    Color bgColor = Colors.white,
    var showShadow = true}) {
  return BoxDecoration(
      color: bgColor,
      //gradient: LinearGradient(colors: [bgColor, whiteColor]),
      boxShadow: showShadow
          ? [
              BoxShadow(
                  color: Color(0x95E9EBF0), blurRadius: 10, spreadRadius: 2)
            ]
          : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

BoxDecoration boxDecoration(
    {double radius = 2,
    Color color = Colors.transparent,
    Color? bgColor,
    var showShadow = false}) {
  return BoxDecoration(
    color: bgColor ?? AppColors.white,
    boxShadow: showShadow
        ? defaultBoxShadow(shadowColor: shadowColorGlobal)
        : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

/// default box shadow
List<BoxShadow> defaultBoxShadow({
  Color? shadowColor,
  double? blurRadius,
  double? spreadRadius,
  Offset offset = const Offset(0.0, 0.0),
}) {
  return [
    BoxShadow(
      color: shadowColor ?? shadowColorGlobal,
      blurRadius: blurRadius ?? defaultBlurRadius,
      spreadRadius: spreadRadius ?? defaultSpreadRadius,
      offset: offset,
    )
  ];
}

Color shadowColorGlobal = Colors.grey.withOpacity(0.2);
double defaultBlurRadius = 4.0;
double defaultSpreadRadius = 1.0;

BoxDecoration lowerOpacityBoxDecoration() {
  return BoxDecoration(color: AppColors.primaryColor.withOpacity(.1));
}
