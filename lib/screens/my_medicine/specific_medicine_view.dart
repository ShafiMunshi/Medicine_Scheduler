import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/models/medicine_model.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodels.dart';
import 'package:medicine_app/viewmodels/schedule_viewmodels.dart';
import 'package:medicine_app/widgets/common/common_fn.dart';
import 'package:medicine_app/widgets/common_extension.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SpecificMedicineView extends StatelessWidget {
  const SpecificMedicineView({super.key, required this.medicineModel});

  final MedicineModel medicineModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        title: 'Medicine Details',
        changeIcon: true,
      ),
      body: Consumer<MedicineViewmodels>(builder: (_, vmMedicine, __) {
        if (vmMedicine.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vmMedicine.todaysMedicines.isEmpty) {
          return const Center(child: Text("No Medicine Found For Today"));
        }

        return Consumer<ScheduleViewmodels>(builder: (_, vmSchedule, __) {
          if (vmSchedule.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _medicineImgWidgt(),
                nameWidget(),
                10.verticalSpace,
                doseAndTypeWidget(),
                8.verticalSpace,
                scheduleAndDurationWidget(context),
                10.verticalSpace,
                Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // color: AppColors.greyColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.greyColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Progress", style: boldTextStyle()),
                        Text('Course Started', style: secondaryTextStyle()),
                        Text(medicineModel.startDate.toFormattedDate(),
                            style: secondaryTextStyle()),
                        6.verticalSpace,
                        FutureBuilder(
                          future: vmSchedule
                              .getUserTakenCountProgress(medicineModel.id!),
                          // initialData: InitialData,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasData) {
                              return SizedBox(
                                width: 120,
                                height: 120,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(
                                        value: snapshot.data,
                                        backgroundColor: AppColors.greyColor,
                                        color: AppColors.primaryColor,
                                        strokeWidth: 10,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            '${(snapshot.data * 100).toInt()}%',
                                            textAlign: TextAlign.center,
                                            style: boldTextStyle()),
                                        Text('Completed',
                                            textAlign: TextAlign.center,
                                            style:
                                                secondaryTextStyle(size: 10)),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }

                            return SizedBox.shrink();
                          },
                        ),
                      ],
                    ))
              ],
            ),
          );
        });
      }),
    );
  }

  Align nameWidget() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        medicineModel.medicineName,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Row scheduleAndDurationWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.alarm_add, size: 20),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Schedule", style: secondaryTextStyle()),
                3.verticalSpace,
                ...getScheduleString(context).map((time) => Text(time))
              ],
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.alarm_sharp, size: 20),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Duration", style: secondaryTextStyle()),
                3.verticalSpace,
                Text(countTotalDays()),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Row doseAndTypeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.category, size: 20),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Medicine Type", style: secondaryTextStyle()),
                3.verticalSpace,
                Text(getMedicineTypeString(medicineModel.dosageUnit)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.donut_small_sharp, size: 20),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Dose    ", style: secondaryTextStyle()),
                3.verticalSpace,
                Text(getDoseString()),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Align _medicineImgWidgt() {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CircleAvatar(
            radius: 70.r,
            backgroundColor: AppColors.secondaryColor,
            child: CircleAvatar(
              radius: 68.r,
              backgroundImage: AssetImage(
                getRandomMedicineImage(0),
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              medicineModel.mealTiming == MealTiming.before
                  ? 'Before meal'
                  : 'After meal',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String getRandomMedicineImage(int index) {
    final rand = index % 3 + 1;
    return 'assets/images/medicine_$rand.png';
  }

  String getMedicineTypeString(DosageUnit type) {
    switch (type) {
      case DosageUnit.pcs:
        return 'Tablet';
      case DosageUnit.cup:
        return 'Syrup';
      // case MedicineType.syrup:
      //   return 'Syrup';
      // case MedicineType.injection:
      //   return 'Injection';
      // case MedicineType.ointment:
      //   return 'Ointment';
      default:
        return 'Unknown';
    }
  }

  String getDoseString() {
    final dosage = medicineModel.dosage;
    final unit = getMedicineTypeString(medicineModel.dosageUnit);
    final durationStrLen = countTotalDays().length;

    final doseString = '$dosage $unit';

    if (doseString.length < durationStrLen) {
      return doseString + ' ' * (durationStrLen - doseString.length + 7);
    }
    return doseString;
  }

  List<String> getScheduleString(BuildContext context) {
    final scheduleList = medicineModel.medicineScheduleList;
    if (scheduleList == null || scheduleList.isEmpty) return ['No Schedule'];

    return scheduleList
        .map((time) =>
            formatTimeOfDayTo12Hour(time.dayTime ?? TimeOfDay.now(), context))
        .toList();
  }

  String countTotalDays() {
    final totalDays = medicineModel.finalScheduleDates?.length ?? 0;

    if (totalDays > 30) {
      final months = totalDays ~/ 30;
      final remainingDays = totalDays % 30;

      if (remainingDays == 0) {
        return months == 1 ? '1 month' : '$months months';
      } else {
        return months == 1
            ? '1 month $remainingDays days'
            : '$months months $remainingDays days';
      }
    }

    return '$totalDays days';
  }
}
