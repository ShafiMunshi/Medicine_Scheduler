import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_assets.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/core/utils/schedule_calculator.dart';
import 'package:medicine_app/screens/my_medicine/widget/medicine_widget.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodel.dart';
import 'package:medicine_app/viewmodels/profile_viewmodel.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeView extends ConsumerWidget {
  static const String routeName = '/home_view';
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayMedicines = ref.watch(todayMedicinesProvider);
    final allMedicinesAsync = ref.watch(allMedicinesProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topProfileSection(ref),
          29.verticalSpace,
          topHorizontalProgressBar(todayMedicines.length, allMedicinesAsync.value?.length ?? 0),
          29.verticalSpace,
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              color: const Color(0xFFF3F3F7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Next Medication',
                        style: boldTextStyle(),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  allMedicinesAsync.when(
                    data: (_) {
                      if (todayMedicines.isEmpty) {
                        return const Expanded(
                          child: Center(
                            child: Text(
                              "No Medicine Scheduled for Today",
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        );
                      }

                      return Expanded(
                        child: ListView.builder(
                          itemCount: todayMedicines.length,
                          shrinkWrap: true,
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
                            );
                          },
                        ),
                      );
                    },
                    loading: () => const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Expanded(
                      child: Center(child: Text("Error: $e")),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ).paddingOnly(top: 20),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data,
                style: boldTextStyle(size: 14),
              ),
              Text(
                subTitle,
                style: secondaryTextStyle(size: 13),
              ),
            ],
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
