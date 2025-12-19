import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/models/medicine_model.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/screens/my_medicine/widget/circular_progress_widget.dart';
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
        title: 'Details',
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
                Row(
                  children: [
                    CircularProgressWidget(
                        dateString: medicineModel.startDate.toFormattedDate(),
                        title: 'Progress',
                        subTitle: 'Course Started',
                        progressValue: getUserTakenCountProgress(medicineModel),
                        centerText:
                            '${(getUserTakenCountProgress(medicineModel) * 100).toInt()}%',
                        centerSubText: 'Completed'),
                    CircularProgressWidget(
                        dateString: medicineModel.endDate.toFormattedDate(),
                        title: 'Amount Left',
                        subTitle: 'Will last until',
                        progressValue: getUserTakenCountProgress(medicineModel),
                        centerText:
                            '${medicineModel.medicineTakenCount}/${medicineModel.availableQuantity}',
                        centerSubText: 'pills left'),
                  ],
                )
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

  double getUserTakenCountProgress(MedicineModel medicineModel) {
    try {
      final estimatedCount = (medicineModel.medicineScheduleList?.length ?? 0) *
          (medicineModel.finalScheduleDates?.length ?? 0);

      final takenCount = medicineModel.medicineTakenCount;

      // Calculate actual progress percentage
      final progress = estimatedCount > 0
          ? (takenCount / estimatedCount).clamp(0.0, 1.0)
          : 0.0;

      final roundedProgress = double.parse(progress.toStringAsFixed(2));
      return roundedProgress;
    } catch (e) {
      log("error: $e");
      throw Exception('Failed to get user taken count $e');
    }
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
