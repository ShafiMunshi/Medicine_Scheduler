import 'package:flutter/material.dart';
import 'package:medicine_app/constant/app_color.dart';

ThemeData lightTheme = ThemeData(
    iconTheme: const IconThemeData(color: AppColors.primaryColor),
    fontFamily: 'Ins',
    textTheme: TextTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(AppColors.white),
            backgroundColor:
                MaterialStateProperty.all<Color>(AppColors.primaryColor))),
    appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.white)),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: AppColors.primaryColor),
    splashColor: Colors.transparent,
    primaryColor: AppColors.primaryColor,
    dividerColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
    drawerTheme: const DrawerThemeData(backgroundColor: AppColors.primaryColor));
