import 'package:flutter/material.dart';
import 'package:medicine_app/screens/home/home_view.dart';
import 'package:medicine_app/screens/medicine/add_medicine_view.dart';
import 'package:medicine_app/screens/auth/sign_in_page.dart';
import 'package:medicine_app/screens/profile/profile_view.dart';
import 'package:medicine_app/screens/schedule/view/schedule_view.dart';
import 'package:medicine_app/screens/top_screen_view.dart';

Map<String, WidgetBuilder> app_routes = {
  SignWithEmailInScreen.routeName: (context) => SignWithEmailInScreen(),
  AddMedicineScreen.routeName: (context) => AddMedicineScreen(),
  ProfileView.routeName: (context) => ProfileView(),
  ScheduleView.routeName: (context) => ScheduleView(),
  HomeView.routeName: (context) => HomeView(),
  TopScreenView.routeName: (context) => TopScreenView(),
};
