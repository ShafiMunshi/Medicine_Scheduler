import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_color.dart';
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

  const MedicineWidget({
    super.key,
    required this.medicineName,
    required this.timeLeft,
    required this.lengthNeedToBeColored,
    required this.index,
    required this.medicine,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
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
                        children: medicine.schedules
                            .map((e) => _timeOfDay(
                                  title: e.dayTimeName,
                                  isDone: true,
                                ))
                            .toList(),
                      ),
                    ),
                    6.verticalSpace,
                    timeLeft == null
                        ? Text(
                            "Time over...",
                            style: primaryTextStyle(size: 10),
                          )
                        : CountdownWithValueNotifier(initialDuration: timeLeft!),
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
                          '${medicine.medicine.medicineTakenCount} / ${medicine.medicine.availableQuantity}',
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

  Widget _timeOfDay({
    required String title,
    required bool isDone,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDone ? AppColors.primaryColor.withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.done,
            size: 14,
            color: isDone ? AppColors.primaryColor : const Color(0xFF002D6F).withOpacity(0.2),
          ),
          SizedBox(width: 4.w),
          Text(
            title,
            style: primaryTextStyle(
              size: 10,
              color: isDone ? AppColors.primaryColor : const Color(0xFF002D6F),
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
