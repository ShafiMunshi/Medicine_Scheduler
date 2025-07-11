import 'package:flutter/material.dart';
import 'package:medicine_app/app/screens/add_medicine/view/add_new_medicine_view.dart';
import 'package:medicine_app/app/screens/home/home_view.dart';
import 'package:medicine_app/app/screens/auth/sign_in_page.dart';
import 'package:medicine_app/app/screens/profile/profile_view.dart';
import 'package:medicine_app/app/screens/schedule/view/schedule_view.dart';
import 'package:medicine_app/app/screens/top_screen_view.dart';

Map<String, WidgetBuilder> app_routes = {
  SignWithEmailInScreen.routeName: (context) => SignWithEmailInScreen(),
  AddNewMedicineScreen.routeName: (context) => AddNewMedicineScreen(),
  ProfileView.routeName: (context) => ProfileView(),
  ScheduleView.routeName: (context) => ScheduleView(),
  HomeView.routeName: (context) => HomeView(),
  TopScreenView.routeName: (context) => TopScreenView(),
};
