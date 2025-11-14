import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/constant/app_assets.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/models/medicine_consumption_model.dart';
import 'package:medicine_app/screens/home/home_view.dart';
import 'package:medicine_app/screens/my_medicine/my_medicine_view.dart';
import 'package:medicine_app/screens/settings/settings_view.dart';
import 'package:medicine_app/screens/schedule/schedule_view.dart';
import 'package:medicine_app/service/draft_file_service.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodels.dart';
import 'package:medicine_app/viewmodels/schedule_viewmodels.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class TopScreenView extends StatefulWidget {
  static String routeName = '/top_screen_view';

  const TopScreenView({super.key});

  @override
  State<TopScreenView> createState() => _TopScreenViewState();
}

class _TopScreenViewState extends State<TopScreenView> {
  int _selectedIndex = 0;
  final allPages = [
    HomeView(),
    MyMedicineView(),
    ScheduleView(),
    SettingsView(),
  ];

  @override
  void initState() {
    processAllTakenMedicineDraftLogs();
    super.initState();
  }

  Future<void> processAllTakenMedicineDraftLogs() async {
    final vmSchedule = context.read<ScheduleViewmodels>();
    final vmMedicine = context.read<MedicineViewmodels>();
    final allTakenLogs = await DraftFileService.getAllTakenLogs();

    for (var i in allTakenLogs) {
      final medicineModel = await vmMedicine.get_medicine_by_id(i.medicineId);

      if (medicineModel != null) {
        await vmSchedule.update_medicine_consume_data(
            i.medicineId,
            MedicineConsumeLogModel(
                medicineId: i.medicineId,
                scheduledDateTime: i.scheduledDateTime,
                actualTakenTime: i.actualTakenTime,
                status: ConsumptionStatus.taken,
                dosageTaken: i.dosage),
            medicineModel);
      }
    }
  }

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
                index: 3, label: 'Settings', assetSvg: AppAssets.profile),
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
