import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_assets.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/models/medicine_model.dart';
import 'package:medicine_app/models/medicine_time_schedule.dart';
import 'package:medicine_app/screens/my_medicine/widget/medicine_widget.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodels.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  static const String routeName = '/home_view';
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final medicineVm = context.read<MedicineViewmodels>();
      medicineVm.get_all_medicine();
      medicineVm.get_todays_medicine();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topProfileSections(),
          29.verticalSpace,
          topHorizontalProgressBar(),
          29.verticalSpace,
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              color: Color(0xFFF3F3F7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text(
                      'Next Medication',
                      style: boldTextStyle(),
                    ),
                  ]),
                  10.verticalSpace,
                  Consumer<MedicineViewmodels>(builder: (_, vm, child) {
                    if (vm.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (vm.todaysMedicines.isEmpty) {
                      return Center(
                        child: Text("No Medicine for Today"),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: vm.todaysMedicines.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final nearestTimeLeft =
                              getHowMuchTimeLeftToTakeNearestMedicine(
                                  vm.todaysMedicines[index]);

                          return MedicineWidget(
                            medicineName:
                                vm.todaysMedicines[index].medicineName,
                            timeLeft: nearestTimeLeft,
                            lengthNeedToBeColored:
                                getTotalProgressIndexHowMuchMedicineLeft(
                                    vm.todaysMedicines[index]),
                            index: index,
                            medicine: vm.todaysMedicines[index],
                          );
                        },
                      ),
                    );
                  }),
                  // _bannerAdsWidget(),
                ],
              ),
            ),
          )
        ],
      ).paddingOnly(top: 20),
    );
  }

  SizedBox _bannerAdsWidget() {
    return SizedBox(
      height: 100,
      width: double.maxFinite,
      child: Image.asset(
        'assets/images/ads.png',
        fit: BoxFit.fill,
      ),
    );
  }

  // get how much time left to take the next medicine
  Duration? getHowMuchTimeLeftToTakeNearestMedicine(MedicineModel model) {
    if (model.finalScheduleDates == null) {
      return null;
    }

    if (_isTodayInList(model.finalScheduleDates!)) {
      if (model.medicineScheduleList != null) {
        log('1');
        final result = _getTimeUntilNextSchedule(model.medicineScheduleList!);
        log("value is $result");
        return result;
      }
    }
    log("model.medicineScheduleList is ${model.medicineScheduleList}");
    log("returning null from getHowMuchTimeLeftToTakeNearestMedicine");

    return null;
  }

  bool _isTodayInList(List<DateTime> dates) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return dates.any((date) {
      final d = DateTime(date.year, date.month, date.day);
      return d == today;
    });
  }

  Duration? _getTimeUntilNextSchedule(List<ScheduleDayTime> scheduleList) {
    final nowDateTime = DateTime.now();

    // Convert TimeOfDay to today's DateTime
    DateTime toTodayDateTime(TimeOfDay time) {
      return DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day,
          time.hour, time.minute);
    }

    // Filter and find upcoming times
    final upcomingTimes = scheduleList
        .where((s) => s.dayTime != null)
        .map((s) => toTodayDateTime(s.dayTime!))
        .where((dt) => dt.isAfter(nowDateTime))
        .toList();

    if (upcomingTimes.isEmpty) return null;

    upcomingTimes.sort(); // sort by soonest

    final nextTime = upcomingTimes.first;

    return nextTime.difference(nowDateTime);
  }

  // Calculate from how much days go and how much medicine user has taken...
  int getTotalProgressIndexHowMuchMedicineLeft(MedicineModel model) {
    double percentage =
        (model.availableQuantity / model.medicineTakenCount) * 100;

    int progressIndex = (percentage >= 80)
        ? 5
        : (percentage >= 60)
            ? 4
            : (percentage >= 40)
                ? 3
                : (percentage >= 20)
                    ? 2
                    : (percentage >= 1)
                        ? 1
                        : 0;

    return progressIndex;
  }

  Widget topHorizontalProgressBar() {
    return Consumer<MedicineViewmodels>(builder: (_, vm, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: _topCardWidget(
                asset: AppAssets.clockk,
                data: vm.todaysMedicines.length.toString(),
                subTitle: 'Remaining today',
                color: AppColors.mistiColor),
          ),
          15.horizontalSpace,
          Flexible(
            child: _topCardWidget(
                asset: AppAssets.tablet,
                data: vm.medicines.length.toString(),
                subTitle: 'Total Medicine',
                color: AppColors.purpleLow),
          ),
        ],
      ).paddingSymmetric(horizontal: 20);
    });
  }

  Container _topCardWidget({
    required String asset,
    required String data,
    required String subTitle,
    required Color color,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10.r),
      decoration: boxDecoration(bgColor: color, radius: 16.r),
      child: Row(children: [
        SvgPicture.asset(asset),
        10.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data,
              style: boldTextStyle(size: 14),
            ),
            Text(
              subTitle,
              style: secondaryTextStyle(size: 14),
            ),
          ],
        )
      ]),
    );
  }

  Widget topProfileSections() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(
        children: [
          SizedBox(
              height: 50.w,
              width: 50.w,
              child: Image.asset('assets/images/avatar.png')),
          15.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Zahidul',
                    style: boldTextStyle(),
                  ),
                  Text(
                    ' Hossain',
                    style: primaryTextStyle(),
                  ),
                ],
              ),
              Text(
                '24 years old',
                style: secondaryTextStyle(),
              ),
            ],
          )
        ],
      ),
      Container(
        padding: EdgeInsets.all(15),
        decoration: boxDecoration(
            bgColor: white, radius: 12.r, color: AppColors.greyColor),
        child: SvgPicture.asset(
          AppAssets.notifications,
        ),
      )
    ]).paddingSymmetric(horizontal: 20);
  }
}
