import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/core/utils/schedule_calculator.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/models/domain_models.dart';
import 'package:medicine_app/screens/add_medicine/view/add_new_medicine_view.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/screens/my_medicine/widget/circular_progress_widget.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodel.dart';
import 'package:medicine_app/widgets/common/common_fn.dart';
import 'package:medicine_app/widgets/common_extension.dart';
import 'package:nb_utils/nb_utils.dart';

class SpecificMedicineView extends ConsumerWidget {
  const SpecificMedicineView({super.key, required this.medicineModel});

  final MedicineWithSchedules medicineModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch current medicine list to get live updates if updated
    final allMeds = ref.watch(allMedicinesProvider).value ?? [];
    final currentMed = allMeds.firstWhere(
      (m) => m.medicine.id == medicineModel.medicine.id,
      orElse: () => medicineModel,
    );

    final scheduledDates = ScheduleCalculator.calculateScheduledDates(
      startDate: currentMed.medicine.startDate,
      endDate: currentMed.medicine.endDate,
      repeatVariation: currentMed.repeatVariationEnum,
      repeatDays: currentMed.medicine.repeatDays,
      weekDays: currentMed.weekDaysList,
      monthDays: currentMed.monthDaysList,
    );

    final totalDoses = scheduledDates.length * currentMed.schedules.length;
    final progressValue = ScheduleCalculator.getCourseProgress(
      totalEstimatedDoses: totalDoses,
      takenCount: currentMed.medicine.medicineTakenCount,
    );

    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        title: 'Details',
        changeIcon: true,
        iconWidget1: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddNewMedicineScreen(existingMedicine: currentMed),
              ),
            );
          },
          icon: const Icon(Icons.edit),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _medicineImgWidget(currentMed),
            15.verticalSpace,
            nameWidget(currentMed),
            15.verticalSpace,
            doseAndTypeWidget(currentMed, scheduledDates.length),
            12.verticalSpace,
            scheduleAndDurationWidget(context, currentMed, scheduledDates.length),
            20.verticalSpace,
            Row(
              children: [
                CircularProgressWidget(
                  dateString: currentMed.medicine.startDate.toFormattedDate(),
                  title: 'Progress',
                  subTitle: 'Course Started',
                  progressValue: progressValue,
                  centerText: '${(progressValue * 100).toInt()}%',
                  centerSubText: 'Completed',
                ),
                10.horizontalSpace,
                CircularProgressWidget(
                  dateString: currentMed.medicine.endDate.toFormattedDate(),
                  title: 'Amount Left',
                  subTitle: 'Will last until',
                  progressValue: progressValue,
                  centerText:
                      '${currentMed.medicine.medicineTakenCount}/${currentMed.medicine.availableQuantity}',
                  centerSubText: '${currentMed.dosageUnitEnum.displayName} left',
                ),
              ],
            ),
            40.verticalSpace,
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _confirmDelete(context, ref, currentMed.medicine.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Delete Medicine",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Medicine'),
        content: const Text('Are you sure you want to delete this medicine and cancel all its scheduled reminders?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(medicineControllerProvider.notifier).deleteMedicine(id);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Align nameWidget(MedicineWithSchedules med) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        med.medicine.medicineName,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Row scheduleAndDurationWidget(
      BuildContext context, MedicineWithSchedules med, int totalDays) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.alarm_add, size: 20),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Schedule", style: secondaryTextStyle()),
                3.verticalSpace,
                ...getScheduleString(context, med).map((time) => Text(time)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.alarm_sharp, size: 20),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Duration", style: secondaryTextStyle()),
                3.verticalSpace,
                Text(countTotalDays(totalDays)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Row doseAndTypeWidget(MedicineWithSchedules med, int totalDays) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.category, size: 20),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Medicine Type", style: secondaryTextStyle()),
                3.verticalSpace,
                Text(med.dosageUnitEnum == DosageUnit.pcs ? 'Tablet' : 'Syrup'),
              ],
            ),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.donut_small_sharp, size: 20),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Dose", style: secondaryTextStyle()),
                3.verticalSpace,
                Text('${med.medicine.dosage} ${med.dosageUnitEnum.displayName}'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Align _medicineImgWidget(MedicineWithSchedules med) {
    final imagePath = med.medicine.imagePath;

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
              backgroundImage: imagePath != null && File(imagePath).existsSync()
                  ? FileImage(File(imagePath)) as ImageProvider
                  : const AssetImage('assets/images/medicine_1.png'),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              med.mealTimingEnum.displayName,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  List<String> getScheduleString(BuildContext context, MedicineWithSchedules med) {
    if (med.schedules.isEmpty) return ['No Schedule'];
    return med.schedules.map((s) {
      final tod = TimeOfDay(hour: s.hour, minute: s.minute);
      return formatTimeOfDayTo12Hour(tod, context);
    }).toList();
  }

  String countTotalDays(int totalDays) {
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
