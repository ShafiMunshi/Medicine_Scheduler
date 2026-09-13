import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/core/utils/schedule_calculator.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/models/domain_models.dart';
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
  double quantityToAdd = 0.0;
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
    final selectedDate = ref.watch(scheduleSelectedDateProvider);
    final scheduledMedicines = ref.watch(medicinesForScheduleDateProvider);
    final logsAsync = ref.watch(logsForScheduleDateProvider);
    final logs = logsAsync.value ?? [];

    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        title: 'Medicine Schedule',
        changeIcon: true,
      ),
      body: Column(
        children: [
          _buildDateSelector(context, selectedDate),
          Expanded(
            child: scheduledMedicines.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.event_available, size: 54, color: Colors.grey),
                          16.verticalSpace,
                          Text(
                            "No Medicine Scheduled for ${DateFormat('d MMM, yyyy').format(selectedDate)}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                : PageView.builder(
                    controller: pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                        quantityToAdd = 0.0;
                      });
                    },
                    itemCount: scheduledMedicines.length,
                    itemBuilder: (context, index) {
                      final medicine = scheduledMedicines[index];

                      return _buildEachMedicineView(
                        medicine: medicine,
                        index: index,
                        totalCount: scheduledMedicines.length,
                        logs: logs,
                        selectedDate: selectedDate,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, DateTime selectedDate) {
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
    final isYesterday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day - 1;

    String dateLabel;
    if (isToday) {
      dateLabel = 'Today, ${DateFormat('d MMM').format(selectedDate)}';
    } else if (isYesterday) {
      dateLabel = 'Yesterday, ${DateFormat('d MMM').format(selectedDate)}';
    } else {
      dateLabel = DateFormat('EEE, d MMM yyyy').format(selectedDate);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.primaryColor),
            onPressed: () {
              ref.read(scheduleSelectedDateProvider.notifier).state =
                  selectedDate.subtract(const Duration(days: 1));
            },
          ),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2050),
              );
              if (picked != null) {
                ref.read(scheduleSelectedDateProvider.notifier).state = picked;
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_month, size: 18, color: AppColors.primaryColor),
                6.horizontalSpace,
                Text(
                  dateLabel,
                  style: boldTextStyle(size: 14, color: AppColors.primaryColor),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isToday)
                GestureDetector(
                  onTap: () {
                    ref.read(scheduleSelectedDateProvider.notifier).state =
                        DateTime(now.year, now.month, now.day);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Today',
                      style: primaryTextStyle(size: 11, color: AppColors.primaryColor),
                    ),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: AppColors.primaryColor),
                onPressed: () {
                  ref.read(scheduleSelectedDateProvider.notifier).state =
                      selectedDate.add(const Duration(days: 1));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEachMedicineView({
    required MedicineWithSchedules medicine,
    required int index,
    required int totalCount,
    required List<MedicineLog> logs,
    required DateTime selectedDate,
  }) {
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
    final isYesterday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day - 1;
    final isTomorrow = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day + 1;

    String dateSectionHeader = isToday
        ? 'Today'
        : isYesterday
            ? 'Yesterday'
            : isTomorrow
                ? 'Tomorrow'
                : DateFormat('d MMM').format(selectedDate);

    final step = medicine.dosageUnitEnum == DosageUnit.cup ? 5.0 : 1.0;

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
                        dateSectionHeader,
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
            _buildScheduleTimesList(medicine, logs, selectedDate),
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
                      '${ScheduleCalculator.formatNumber(medicine.medicine.availableQuantity)} ${medicine.dosageUnitEnum.displayName}',
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
                              if (quantityToAdd >= step) {
                                quantityToAdd -= step;
                              } else {
                                quantityToAdd = 0.0;
                              }
                            });
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        Text(
                          '${ScheduleCalculator.formatNumber(quantityToAdd)} ${medicine.dosageUnitEnum.displayName}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantityToAdd += step;
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
                          quantityToAdd = 0.0;
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
                      .markAllDosesForDateAsTaken(selectedDate, medicine);
                  if (context.mounted) {
                    toast("Marked doses for $dateSectionHeader as taken!");
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
    List<MedicineLog> logs,
    DateTime selectedDate,
  ) {
    final now = DateTime.now();
    final isSelectedDateToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    return Column(
      children: medicine.schedules.map((schedule) {
        final scheduledDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          schedule.hour,
          schedule.minute,
        );

        final matchingLog = logs.where((log) {
          return log.medicineId == medicine.medicine.id &&
              log.scheduledDateTime.year == scheduledDateTime.year &&
              log.scheduledDateTime.month == scheduledDateTime.month &&
              log.scheduledDateTime.day == scheduledDateTime.day &&
              log.scheduledDateTime.hour == scheduledDateTime.hour &&
              log.scheduledDateTime.minute == scheduledDateTime.minute;
        }).firstOrNull;

        final isTaken = matchingLog?.status == 'taken';
        final isNextUpcoming = isSelectedDateToday &&
            !isTaken &&
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
          '${ScheduleCalculator.formatNumber(diff.abs())} ${medicine.dosageUnitEnum.displayName}',
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
