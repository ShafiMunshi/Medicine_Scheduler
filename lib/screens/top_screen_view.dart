import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/constant/app_assets.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/screens/home/home_view.dart';
import 'package:medicine_app/screens/my_medicine/my_medicine_view.dart';
import 'package:medicine_app/screens/schedule/schedule_view.dart';
import 'package:medicine_app/screens/settings/settings_view.dart';
import 'package:medicine_app/service/notification_service.dart';
import 'package:medicine_app/viewmodels/database_providers.dart';
import 'package:medicine_app/viewmodels/profile_viewmodel.dart';
import 'package:nb_utils/nb_utils.dart';

class TopScreenView extends ConsumerStatefulWidget {
  static const String routeName = '/top_screen_view';

  const TopScreenView({super.key});

  @override
  ConsumerState<TopScreenView> createState() => _TopScreenViewState();
}

class _TopScreenViewState extends ConsumerState<TopScreenView> {
  int _selectedIndex = 0;

  final allPages = const [
    HomeView(),
    MyMedicineView(),
    ScheduleView(),
    SettingsView(),
  ];

  @override
  void initState() {
    super.initState();
    // Eagerly load user profile
    Future.microtask(() => ref.read(userProfileProvider));

    // Request runtime notification permission and ensure all active alarms are scheduled
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await NotificationService.requestPermissions();
      try {
        final repo = ref.read(medicineRepositoryProvider);
        final medicines = await repo.getAllMedicines();
        await NotificationService.rescheduleAllActiveMedicines(medicines);
      } catch (e) {
        log('Error rescheduling active medicines on launch: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: allPages,
      ),
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
          _bottomItem(index: 1, label: 'Medicine', assetSvg: AppAssets.medicine),
          _bottomItem(index: 2, label: 'Schedule', assetSvg: AppAssets.schedule),
          _bottomItem(index: 3, label: 'Settings', assetSvg: AppAssets.profile),
        ],
      ),
    );
  }

  BottomNavigationBarItem _bottomItem({
    required int index,
    required String label,
    required String assetSvg,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        assetSvg,
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
      ).paddingOnly(top: 5, bottom: 5),
      label: label,
      activeIcon: SvgPicture.asset(
        assetSvg,
        colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
      ).paddingOnly(top: 5, bottom: 5),
      backgroundColor: Colors.white,
    );
  }
}
