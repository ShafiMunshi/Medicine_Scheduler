import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/constant/app_assets.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/screens/home/home_view.dart';
import 'package:medicine_app/screens/medicine_view.dart';
import 'package:medicine_app/screens/profile/profile_view.dart';
import 'package:medicine_app/screens/schedule/view/schedule_view.dart';
import 'package:nb_utils/nb_utils.dart';

class TopScreenView extends StatefulWidget {
  static String routeName ='/top_screen_view' ;

  const TopScreenView({super.key});

  @override
  State<TopScreenView> createState() => _TopScreenViewState();
}

class _TopScreenViewState extends State<TopScreenView> {
  int _selectedIndex = 0;
  final allPages = [
    HomeView(),
    MedicineView(),
    ScheduleView(),
    ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: allPages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            _bottomItem(index: 0, label: 'Home', assetSvg: AppAssets.homeSvg),
            _bottomItem(
                index: 1, label: 'Medicine', assetSvg: AppAssets.medicine),
            _bottomItem(
                index: 2, label: 'Schedule', assetSvg: AppAssets.schedule),
            _bottomItem(
                index: 3, label: 'Profile', assetSvg: AppAssets.profile),
          ]),
    );
  }

  BottomNavigationBarItem _bottomItem({
    required int index,
    required String label,
    required String assetSvg,
  }) {
    return BottomNavigationBarItem(
        icon: SvgPicture.asset(assetSvg,
                colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn))
            .paddingOnly(top: 5, bottom: 5),
        label: label,
        activeIcon: SvgPicture.asset(assetSvg,
                colorFilter:
                    ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn))
            .paddingOnly(top: 5, bottom: 5),
        backgroundColor: Colors.white);
  }
}
