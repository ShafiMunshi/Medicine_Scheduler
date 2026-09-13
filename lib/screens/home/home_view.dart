import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_assets.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/core/utils/schedule_calculator.dart';
import 'package:medicine_app/screens/home/widget/monthly_adherence_chart.dart';
import 'package:medicine_app/screens/my_medicine/widget/medicine_widget.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodel.dart';
import 'package:medicine_app/viewmodels/profile_viewmodel.dart';
import 'package:medicine_app/viewmodels/schedule_viewmodel.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeView extends ConsumerWidget {
  static const String routeName = '/home_view';
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayMedicines = ref.watch(todayMedicinesProvider);
    final allMedicinesAsync = ref.watch(allMedicinesProvider);
    final todayLogs = ref.watch(todayLogsProvider).value ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topProfileSection(ref),
            18.verticalSpace,
            topHorizontalProgressBar(todayMedicines.length, allMedicinesAsync.value?.length ?? 0),
            16.verticalSpace,
            const MonthlyAdherenceChart(),
            16.verticalSpace,
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today\'s Medication',
                        style: boldTextStyle(size: 16),
                      ),
                      Text(
                        '${todayMedicines.length} scheduled',
                        style: secondaryTextStyle(size: 12),
                      ),
                    ],
                  ),
                  12.verticalSpace,
                  allMedicinesAsync.when(
                    data: (_) {
                      if (todayMedicines.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
                                10.verticalSpace,
                                const Text(
                                  "No Medicine Scheduled for Today",
                                  style: TextStyle(color: Colors.grey, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: todayMedicines.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final medicine = todayMedicines[index];
                          final nearestTimeLeft = ScheduleCalculator.getTimeUntilNextDose(
                            medicine.scheduleItems,
                            DateTime.now(),
                          );

                          final stockIndex = ScheduleCalculator.getStockProgressIndex(
                            availableQuantity: medicine.medicine.availableQuantity,
                            medicineTakenCount: medicine.medicine.medicineTakenCount,
                          );

                          return MedicineWidget(
                            medicineName: medicine.medicine.medicineName,
                            timeLeft: nearestTimeLeft,
                            lengthNeedToBeColored: stockIndex,
                            index: index,
                            medicine: medicine,
                            imagePath: medicine.medicine.imagePath,
                            targetDate: DateTime.now(),
                            logs: todayLogs,
                          );
                        },
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Center(child: Text("Error: $e")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topHorizontalProgressBar(int remainingToday, int totalCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _topCardWidget(
            asset: AppAssets.clockk,
            data: remainingToday.toString(),
            subTitle: 'Remaining today',
            color: AppColors.mistiColor,
          ),
        ),
        15.horizontalSpace,
        Flexible(
          child: _topCardWidget(
            asset: AppAssets.tablet,
            data: totalCount.toString(),
            subTitle: 'Total Medicine',
            color: AppColors.purpleLow,
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 20);
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
      child: Row(
        children: [
          SvgPicture.asset(asset),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data,
                  style: boldTextStyle(size: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subTitle,
                  style: secondaryTextStyle(size: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget topProfileSection(WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (user) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 50.w,
                  width: 50.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.r),
                    child: user?.imagePath != null && File(user!.imagePath!).existsSync()
                        ? Image.file(File(user.imagePath!), fit: BoxFit.cover)
                        : Image.asset('assets/images/avatar.png', fit: BoxFit.cover),
                  ),
                ),
                15.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Shafi Munshi',
                      style: boldTextStyle(),
                    ),
                    Text(
                      '${user?.age ?? 24} years old',
                      style: secondaryTextStyle(),
                    ),
                  ],
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: boxDecoration(
                bgColor: white,
                radius: 12.r,
                color: AppColors.greyColor,
              ),
              child: SvgPicture.asset(
                AppAssets.notifications,
              ),
            )
          ],
        ).paddingSymmetric(horizontal: 20);
      },
      loading: () => const SizedBox(height: 50),
      error: (_, __) => const SizedBox(height: 50),
    );
  }
}
