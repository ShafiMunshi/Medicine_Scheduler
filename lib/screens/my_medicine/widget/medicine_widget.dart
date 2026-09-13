import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/core/utils/schedule_calculator.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/screens/my_medicine/widget/timer_countdown_widget.dart';
import 'package:medicine_app/widgets/common/app_slideablde_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class MedicineWidget extends StatelessWidget {
  final MedicineWithSchedules medicine;
  final String medicineName;
  final Duration? timeLeft;
  final int lengthNeedToBeColored;
  final int index;
  final String? imagePath;
  final DateTime? targetDate;
  final List<MedicineLog> logs;

  const MedicineWidget({
    super.key,
    required this.medicineName,
    required this.timeLeft,
    required this.lengthNeedToBeColored,
    required this.index,
    required this.medicine,
    this.imagePath,
    this.targetDate,
    this.logs = const [],
  });

  @override
  Widget build(BuildContext context) {
    final date = targetDate ?? DateTime.now();
    final now = DateTime.now();

    final allTaken = medicine.schedules.isNotEmpty &&
        medicine.schedules.every((s) {
          return logs.any((log) =>
              log.medicineId == medicine.medicine.id &&
              log.status == 'taken' &&
              (log.scheduleId == s.id ||
                  (log.scheduledDateTime.year == date.year &&
                      log.scheduledDateTime.month == date.month &&
                      log.scheduledDateTime.day == date.day &&
                      log.scheduledDateTime.hour == s.hour &&
                      log.scheduledDateTime.minute == s.minute)));
        });

    return AppSlidableWidget(
      medicine: medicine,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: boxDecoration(bgColor: white, radius: 16.r, showShadow: true),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 84.w,
                  width: 84.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: _buildMedicineImage(),
                  ),
                ),
                12.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicineName,
                      style: boldTextStyle(size: 16),
                    ),
                    6.verticalSpace,
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.57,
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 5.w,
                        runSpacing: 5.h,
                        alignment: WrapAlignment.start,
                        children: medicine.schedules.map((s) {
                          final scheduledDateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            s.hour,
                            s.minute,
                          );
                          final isTaken = logs.any((log) =>
                              log.medicineId == medicine.medicine.id &&
                              log.status == 'taken' &&
                              (log.scheduleId == s.id ||
                                  (log.scheduledDateTime.year == date.year &&
                                      log.scheduledDateTime.month == date.month &&
                                      log.scheduledDateTime.day == date.day &&
                                      log.scheduledDateTime.hour == s.hour &&
                                      log.scheduledDateTime.minute == s.minute)));
                          final isPastDue = scheduledDateTime.isBefore(now);

                          return _scheduleStatusChip(
                            title: s.dayTimeName,
                            isTaken: isTaken,
                            isPastDue: isPastDue,
                          );
                        }).toList(),
                      ),
                    ),
                    6.verticalSpace,
                    if (allTaken)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Iconsax.tick_circle,
                            color: Color(0xFF2E7D32),
                            size: 13,
                          ),
                          4.horizontalSpace,
                          Text(
                            "All taken",
                            style: boldTextStyle(
                              size: 11,
                              color: const Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      )
                    else if (timeLeft != null)
                      CountdownWithValueNotifier(initialDuration: timeLeft!)
                    else
                      Text(
                        "Time over...",
                        style: primaryTextStyle(size: 10, color: Colors.grey),
                      ),
                    10.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Stock left',
                          style: secondaryTextStyle(size: 10),
                        ),
                        12.horizontalSpace,
                        SizedBox(
                          width: 110.w,
                          height: 8,
                          child: ListView.builder(
                            itemCount: 5,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int i) {
                              return _littleTablet(
                                  isColored: i < lengthNeedToBeColored);
                            },
                          ),
                        ),
                        Text(
                          '${medicine.medicine.medicineTakenCount} / ${ScheduleCalculator.formatNumber(medicine.medicine.availableQuantity)}',
                          style: secondaryTextStyle(size: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset('assets/icons/clock_blue.svg'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineImage() {
    if (imagePath != null && File(imagePath!).existsSync()) {
      return Image.file(File(imagePath!), fit: BoxFit.cover);
    }
    return Image.asset(getRandomMedicineImage(index), fit: BoxFit.cover);
  }

  String getRandomMedicineImage(int index) {
    final rand = index % 3 + 1;
    return 'assets/images/medicine_$rand.png';
  }

  Widget _scheduleStatusChip({
    required String title,
    required bool isTaken,
    required bool isPastDue,
  }) {
    final IconData icon;
    final Color bgColor;
    final Color textColor;
    final String label;

    if (isTaken) {
      icon = Iconsax.tick_circle;
      bgColor = const Color(0xFFE8F5E9);
      textColor = const Color(0xFF2E7D32);
      label = '$title [Done]';
    } else if (isPastDue) {
      icon = Iconsax.close_circle;
      bgColor = const Color(0xFFFFEBEE);
      textColor = const Color(0xFFC62828);
      label = '$title [Missed]';
    } else {
      icon = Iconsax.clock;
      bgColor = const Color(0xFFE3F2FD);
      textColor = const Color(0xFF1565C0);
      label = title;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: textColor,
          ),
          4.horizontalSpace,
          Text(
            label,
            style: primaryTextStyle(
              size: 10,
              color: textColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Container _littleTablet({bool isColored = false}) {
    return Container(
      height: 7.h,
      width: 18.w,
      margin: const EdgeInsets.only(right: 4),
      decoration: boxDecoration(
        radius: 10,
        bgColor: isColored ? AppColors.secondaryColor : AppColors.greyColor,
      ),
    );
  }
}
