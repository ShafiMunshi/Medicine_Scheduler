import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/core/utils/schedule_calculator.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/models/domain_models.dart';
import 'package:medicine_app/screens/add_medicine/view/add_new_medicine_view.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
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

    final diff = ScheduleCalculator.getEstimatedPillDifference(
      totalDosesPerDay: currentMed.schedules.length,
      dosagePerTime: currentMed.medicine.dosage,
      totalScheduledDays: scheduledDates.length,
      availableQuantity: currentMed.medicine.availableQuantity,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: commonAppBarWidget(
        context,
        title: 'Medicine Details',
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
          icon: const Icon(Iconsax.edit_2, color: AppColors.primaryColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroBanner(currentMed),
            16.verticalSpace,
            _buildStatsGrid(currentMed, scheduledDates.length),
            16.verticalSpace,
            _buildScheduleTimesCard(context, currentMed),
            16.verticalSpace,
            _buildInventoryCard(context, ref, currentMed, diff),
            16.verticalSpace,
            _buildCourseProgressCard(currentMed, progressValue, totalDoses),
            24.verticalSpace,
            _buildActionButtons(context, ref, currentMed),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner(MedicineWithSchedules med) {
    final imagePath = med.medicine.imagePath;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryColor.withOpacity(0.2), width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 56.r,
              backgroundColor: const Color(0xFFF1F5F9),
              backgroundImage: imagePath != null && File(imagePath).existsSync()
                  ? FileImage(File(imagePath)) as ImageProvider
                  : const AssetImage('assets/images/medicine_1.png'),
            ),
          ),
          14.verticalSpace,
          Text(
            med.medicine.medicineName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          10.verticalSpace,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildBadge(
                icon: Iconsax.coffee,
                label: med.mealTimingEnum.displayName,
                color: AppColors.secondaryColor,
              ),
              _buildBadge(
                icon: med.dosageUnitEnum == DosageUnit.cup ? Iconsax.drop : Iconsax.box,
                label: med.dosageUnitEnum == DosageUnit.cup ? 'Liquid / Syrup' : 'Tablet / Pill',
                color: AppColors.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          6.horizontalSpace,
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(MedicineWithSchedules med, int totalDays) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _buildStatCard(
          icon: med.dosageUnitEnum == DosageUnit.cup ? Iconsax.drop : Iconsax.weight,
          iconColor: const Color(0xFF0284C7),
          label: 'Dosage',
          value: ScheduleCalculator.formatDosage(med.medicine.dosage, med.dosageUnitEnum),
        ),
        _buildStatCard(
          icon: Iconsax.clock,
          iconColor: const Color(0xFF10B981),
          label: 'Frequency',
          value: '${med.schedules.length}x daily',
        ),
        _buildStatCard(
          icon: Iconsax.calendar_1,
          iconColor: const Color(0xFF8B5CF6),
          label: 'Duration',
          value: countTotalDays(totalDays),
        ),
        _buildStatCard(
          icon: Iconsax.repeat,
          iconColor: const Color(0xFFF59E0B),
          label: 'Repeat Cycle',
          value: med.repeatVariationEnum.displayName,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: secondaryTextStyle(size: 12),
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: boldTextStyle(size: 15, color: const Color(0xFF0F172A)),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTimesCard(BuildContext context, MedicineWithSchedules med) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Iconsax.clock, size: 16, color: AppColors.primaryColor),
              ),
              8.horizontalSpace,
              Text('Daily Schedule Times', style: boldTextStyle(size: 15)),
            ],
          ),
          12.verticalSpace,
          if (med.schedules.isEmpty)
            Text('No scheduled times set.', style: secondaryTextStyle())
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: med.schedules.map((s) {
                final tod = TimeOfDay(hour: s.hour, minute: s.minute);
                final timeFormatted = formatTimeOfDayTo12Hour(tod, context);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_getDayTimeIcon(s.dayTimeName), size: 14, color: AppColors.primaryColor),
                      6.horizontalSpace,
                      Text(
                        '${s.dayTimeName}: $timeFormatted',
                        style: primaryTextStyle(size: 13, color: const Color(0xFF334155)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  IconData _getDayTimeIcon(String dayTime) {
    switch (dayTime.toLowerCase()) {
      case 'morning':
        return Iconsax.sun_1;
      case 'afternoon':
        return Iconsax.sun_fog;
      case 'evening':
        return Iconsax.cloud_sunny;
      case 'night':
        return Iconsax.moon;
      default:
        return Iconsax.clock;
    }
  }

  Widget _buildInventoryCard(
    BuildContext context,
    WidgetRef ref,
    MedicineWithSchedules med,
    num diff,
  ) {
    final available = med.medicine.availableQuantity;
    final isLowStock = diff > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: (isLowStock ? Colors.orange : Colors.green).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isLowStock ? Iconsax.warning_2 : Iconsax.box_tick,
                      size: 16,
                      color: isLowStock ? Colors.orange : Colors.green,
                    ),
                  ),
                  8.horizontalSpace,
                  Text('Inventory & Stock', style: boldTextStyle(size: 15)),
                ],
              ),
              InkWell(
                onTap: () => _showRefillBottomSheet(context, ref, med),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.add, size: 14, color: AppColors.primaryColor),
                      4.horizontalSpace,
                      Text('Refill', style: boldTextStyle(size: 12, color: AppColors.primaryColor)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          12.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Available in Stock:', style: secondaryTextStyle(size: 13)),
              Text(
                '${ScheduleCalculator.formatNumber(available)} ${med.dosageUnitEnum.displayName}',
                style: boldTextStyle(size: 14, color: const Color(0xFF0F172A)),
              ),
            ],
          ),
          6.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isLowStock ? 'Estimated Need:' : 'Stock Status:', style: secondaryTextStyle(size: 13)),
              Text(
                isLowStock
                    ? '+${ScheduleCalculator.formatNumber(diff.abs())} ${med.dosageUnitEnum.displayName} needed'
                    : 'Stock is Sufficient',
                style: boldTextStyle(
                  size: 13,
                  color: isLowStock ? Colors.orange.shade800 : Colors.green.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourseProgressCard(
    MedicineWithSchedules med,
    double progressValue,
    int totalDoses,
  ) {
    final percent = (progressValue * 100).clamp(0, 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Iconsax.chart_2, size: 16, color: AppColors.secondaryColor),
                  ),
                  8.horizontalSpace,
                  Text('Course Progress', style: boldTextStyle(size: 15)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$percent% Completed',
                  style: boldTextStyle(size: 12, color: AppColors.secondaryColor),
                ),
              ),
            ],
          ),
          14.verticalSpace,
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progressValue.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: const Color(0xFFF1F5F9),
              color: AppColors.secondaryColor,
            ),
          ),
          12.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Taken: ${med.medicine.medicineTakenCount} / $totalDoses doses',
                style: secondaryTextStyle(size: 12),
              ),
              Text(
                '${med.medicine.startDate.toFormattedDate()} → ${med.medicine.endDate.toFormattedDate()}',
                style: secondaryTextStyle(size: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    MedicineWithSchedules med,
  ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddNewMedicineScreen(existingMedicine: med),
                ),
              );
            },
            icon: const Icon(Iconsax.edit, size: 18, color: AppColors.primaryColor),
            label: const Text('Edit Details', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppColors.primaryColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _confirmDelete(context, ref, med.medicine.id),
            icon: const Icon(Iconsax.trash, size: 18, color: Colors.white),
            label: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  void _showRefillBottomSheet(
    BuildContext context,
    WidgetRef ref,
    MedicineWithSchedules med,
  ) {
    double refillAmount = med.dosageUnitEnum == DosageUnit.cup ? 50.0 : 10.0;
    final step = med.dosageUnitEnum == DosageUnit.cup ? 10.0 : 5.0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              16.verticalSpace,
              Row(
                children: [
                  const Icon(Iconsax.add_circle, color: AppColors.primaryColor, size: 24),
                  8.horizontalSpace,
                  Text('Refill Stock', style: boldTextStyle(size: 18)),
                ],
              ),
              8.verticalSpace,
              Text(
                'Add more ${med.dosageUnitEnum.displayName} to your existing inventory of ${ScheduleCalculator.formatNumber(med.medicine.availableQuantity)} ${med.dosageUnitEnum.displayName}.',
                style: secondaryTextStyle(size: 13),
              ),
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (refillAmount > step) {
                        setModalState(() => refillAmount -= step);
                      }
                    },
                    icon: const Icon(Iconsax.minus_cirlce, size: 30, color: AppColors.primaryColor),
                  ),
                  16.horizontalSpace,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      '+${ScheduleCalculator.formatNumber(refillAmount)} ${med.dosageUnitEnum.displayName}',
                      style: boldTextStyle(size: 20, color: AppColors.primaryColor),
                    ),
                  ),
                  16.horizontalSpace,
                  IconButton(
                    onPressed: () {
                      setModalState(() => refillAmount += step);
                    },
                    icon: const Icon(Iconsax.add_circle, size: 30, color: AppColors.primaryColor),
                  ),
                ],
              ),
              24.verticalSpace,
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await ref.read(medicineControllerProvider.notifier).addStock(med.medicine.id, refillAmount);
                    if (context.mounted) {
                      toast('Added ${ScheduleCalculator.formatNumber(refillAmount)} ${med.dosageUnitEnum.displayName} to stock!');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Confirm Refill', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
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
