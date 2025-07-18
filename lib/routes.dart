import 'package:flutter/material.dart';
import 'package:medicine_app/screens/add_medicine/view/add_new_medicine_view.dart';
import 'package:medicine_app/screens/home/home_view.dart';
import 'package:medicine_app/screens/auth/sign_in_page.dart';
import 'package:medicine_app/screens/settings/settings_view.dart';
import 'package:medicine_app/screens/schedule/schedule_view.dart';
import 'package:medicine_app/screens/top_screen_view.dart';

Map<String, WidgetBuilder> app_routes = {
  SignWithEmailInScreen.routeName: (context) => SignWithEmailInScreen(),
  AddNewMedicineScreen.routeName: (context) => AddNewMedicineScreen(),
  SettingsView.routeName: (context) => SettingsView(),
  ScheduleView.routeName: (context) => ScheduleView(),
  HomeView.routeName: (context) => HomeView(),
  TopScreenView.routeName: (context) => TopScreenView(),
};
