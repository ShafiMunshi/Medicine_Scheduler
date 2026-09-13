import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/core/utils/schedule_calculator.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/screens/schedule/widget/schedule_time_widget.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodel.dart';
import 'package:medicine_app/viewmodels/schedule_viewmodel.dart';
import 'package:medicine_app/widgets/common/common_fn.dart';
import 'package:nb_utils/nb_utils.dart';

class ScheduleView extends ConsumerStatefulWidget {
  static const String routeName = '/schedule_screen';
  const ScheduleView({super.key});

  @override
  ConsumerState<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends ConsumerState<ScheduleView> {
  late final PageController pageController;
  int quantityToAdd = 0;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todayMedicines = ref.watch(todayMedicinesProvider);
    final todayLogsAsync = ref.watch(todayLogsProvider);

    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        title: 'Medicine Schedule',
        changeIcon: true,
      ),
      body: todayMedicines.isEmpty
          ? const Center(
              child: Text(
                "No Medicine Scheduled for Today",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : PageView.builder(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                  quantityToAdd = 0;
                });
              },
              itemCount: todayMedicines.length,
              itemBuilder: (context, index) {
                final medicine = todayMedicines[index];
                final todayLogs = todayLogsAsync.value ?? [];

                return _buildEachMedicineView(
                  medicine: medicine,
                  index: index,
                  totalCount: todayMedicines.length,
                  todayLogs: todayLogs,
                );
              },
            ),
    );
  }

  Widget _buildEachMedicineView({
    required MedicineWithSchedules medicine,
    required int index,
    required int totalCount,
    required List<MedicineLog> todayLogs,
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (currentPage == 0) {
                            snackBar(context, title: "This is the first medicine");
                            return;
                          }
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_outlined),
                      ),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          CircleAvatar(
                            radius: 70.r,
                            backgroundColor: AppColors.secondaryColor,
                            child: CircleAvatar(
                              radius: 68.r,
                              backgroundImage: AssetImage(
                                getRandomMedicineImage(index),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 7.0),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              medicine.mealTimingEnum.displayName,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          if (currentPage == totalCount - 1) {
                            snackBar(context, title: "This is the last medicine");
                            return;
                          }
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ],
                  ),
                  15.verticalSpace,
                  Text(
                    medicine.medicine.medicineName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  15.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today',
                        style: boldTextStyle(size: 18),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${medicine.schedules.length} times',
                          style: boldTextStyle(color: white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            _buildScheduleTimesList(medicine, todayLogs),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add more medicines',
                  style: secondaryTextStyle(),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.primaryColor,
                      size: 15,
                    ),
                    8.horizontalSpace,
                    Text(
                      'Available',
                      style: secondaryTextStyle(size: 11),
                    ),
                    5.horizontalSpace,
                    Text(
                      '${medicine.medicine.availableQuantity} ${medicine.dosageUnitEnum.displayName}',
                      style: primaryTextStyle(
                        size: 11,
                        color: AppColors.primaryColor,
                      ),
                    )
                  ],
                )
              ],
            ),
            10.verticalSpace,
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    decoration: boxDecoration(radius: 10, color: AppColors.greyColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (quantityToAdd > 0) quantityToAdd--;
                            });
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        Text(
                          '$quantityToAdd ${medicine.dosageUnitEnum.displayName}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantityToAdd++;
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ),
                20.horizontalSpace,
                Flexible(
                  flex: 1,
                  child: InkWell(
                    onTap: () async {
                      if (quantityToAdd > 0) {
                        await ref
                            .read(medicineControllerProvider.notifier)
                            .addStock(medicine.medicine.id, quantityToAdd);
                        setState(() {
                          quantityToAdd = 0;
                        });
                        if (context.mounted) {
                          toast("Stock updated!");
                        }
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Add',
                        style: boldTextStyle(color: white, size: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _remainingMedicineCountWidget(medicine),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await ref
                      .read(scheduleControllerProvider.notifier)
                      .markAllDosesForTodayAsTaken(medicine);
                  if (context.mounted) {
                    toast("Marked today's doses as taken!");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'I have taken medicine',
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleTimesList(
    MedicineWithSchedules medicine,
    List<MedicineLog> todayLogs,
  ) {
    final now = DateTime.now();

    return Column(
      children: medicine.schedules.map((schedule) {
        final scheduledDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          schedule.hour,
          schedule.minute,
        );

        final matchingLog = todayLogs.where((log) {
          return log.medicineId == medicine.medicine.id &&
              log.scheduledDateTime.year == scheduledDateTime.year &&
              log.scheduledDateTime.month == scheduledDateTime.month &&
              log.scheduledDateTime.day == scheduledDateTime.day &&
              log.scheduledDateTime.hour == scheduledDateTime.hour &&
              log.scheduledDateTime.minute == scheduledDateTime.minute;
        }).firstOrNull;

        final isTaken = matchingLog?.status == 'taken';
        final isNextUpcoming = !isTaken &&
            scheduledDateTime.isAfter(now) &&
            medicine.schedules.where((s) {
                  final dt = DateTime(now.year, now.month, now.day, s.hour, s.minute);
                  return dt.isAfter(now);
                }).firstOrNull?.id ==
                schedule.id;

        final tod = TimeOfDay(hour: schedule.hour, minute: schedule.minute);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ScheduleTimeWidget(
            timeOfDay: schedule.dayTimeName,
            time: formatTimeOfDayTo12Hour(tod, context),
            isChecked: isTaken,
            showWaterWave: isNextUpcoming,
            onChanged: (checked) async {
              final scheduleController = ref.read(scheduleControllerProvider.notifier);
              if (checked) {
                await scheduleController.markDoseAsTaken(
                  medicineId: medicine.medicine.id,
                  scheduleId: schedule.id,
                  scheduledDateTime: scheduledDateTime,
                  dosageTaken: medicine.medicine.dosage,
                );
              } else {
                await scheduleController.revertDose(
                  medicineId: medicine.medicine.id,
                  scheduledDateTime: scheduledDateTime,
                );
              }
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _remainingMedicineCountWidget(MedicineWithSchedules medicine) {
    final scheduledDates = ScheduleCalculator.calculateScheduledDates(
      startDate: medicine.medicine.startDate,
      endDate: medicine.medicine.endDate,
      repeatVariation: medicine.repeatVariationEnum,
      repeatDays: medicine.medicine.repeatDays,
      weekDays: medicine.weekDaysList,
      monthDays: medicine.monthDaysList,
    );

    final diff = ScheduleCalculator.getEstimatedPillDifference(
      totalDosesPerDay: medicine.schedules.length,
      dosagePerTime: medicine.medicine.dosage,
      totalScheduledDays: scheduledDates.length,
      availableQuantity: medicine.medicine.availableQuantity,
    );

    return Row(
      children: [
        const Icon(
          Icons.info_outline_rounded,
          color: AppColors.primaryColor,
          size: 15,
        ),
        8.horizontalSpace,
        Text(
          diff > 0 ? 'Estimated Need' : 'Extra Remaining Medicine',
          style: secondaryTextStyle(size: 11),
        ),
        5.horizontalSpace,
        Text(
          '${diff.abs()} ${medicine.dosageUnitEnum.displayName}',
          style: primaryTextStyle(size: 11, color: AppColors.primaryColor),
        )
      ],
    );
  }

  String getRandomMedicineImage(int index) {
    final rand = index % 3 + 1;
    return 'assets/images/medicine_$rand.png';
  }
}
