import 'package:flutter/material.dart';
import 'package:medicine_app/screens/add_medicine/view/add_new_medicine_view.dart';
import 'package:medicine_app/screens/auth/sign_in_page.dart';
import 'package:medicine_app/screens/auth/sign_up_page.dart';
import 'package:medicine_app/screens/caregiver/caregiver_dashboard_view.dart';
import 'package:medicine_app/screens/caregiver/parent_linking_view.dart';
import 'package:medicine_app/screens/home/home_view.dart';
import 'package:medicine_app/screens/profile/user_profile_setup_view.dart';
import 'package:medicine_app/screens/schedule/schedule_view.dart';
import 'package:medicine_app/screens/settings/settings_view.dart';
import 'package:medicine_app/screens/top_screen_view.dart';

Map<String, WidgetBuilder> app_routes = {
  SignWithEmailInScreen.routeName: (context) => const SignWithEmailInScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  UserProfileSetupView.routeName: (context) => const UserProfileSetupView(),
  ParentLinkingView.routeName: (context) => const ParentLinkingView(),
  CaregiverDashboardView.routeName: (context) => const CaregiverDashboardView(),
  AddNewMedicineScreen.routeName: (context) => const AddNewMedicineScreen(),
  SettingsView.routeName: (context) => const SettingsView(),
  ScheduleView.routeName: (context) => const ScheduleView(),
  HomeView.routeName: (context) => const HomeView(),
  TopScreenView.routeName: (context) => const TopScreenView(),
};
