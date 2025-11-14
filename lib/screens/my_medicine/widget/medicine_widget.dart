import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/models/medicine_model.dart';
import 'package:medicine_app/screens/my_medicine/widget/timer_countdown_widget.dart';
import 'package:medicine_app/widgets/common/app_slideablde_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class MedicineWidget extends StatelessWidget {
  final MedicineModel medicine;
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
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 2),
        decoration:
            boxDecoration(bgColor: white, radius: 16.r, showShadow: true),
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
                    child: Image.asset(
                        imagePath ?? getRandomMedicineImage(index),
                        fit: BoxFit.cover)),
                12.horizontalSpace,
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        runSpacing: 5.h, // optional: space between lines
                        alignment: WrapAlignment.start,
                        children: medicine.medicineScheduleList!
                            .map((e) => _timeOfDay(
                                title: e.dayTimeName ?? "Unknown",
                                isDone: true))
                            .toList()),
                  ),
                  6.verticalSpace,
                  timeLeft == null
                      ? Text(
                          "No medicine today",
                          style: primaryTextStyle(size: 10),
                        )
                      : CountdownWithValueNotifier(initialDuration: timeLeft!),
                  // Row(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(
                  //         'Time left',
                  //         style: primaryTextStyle(size: 10),
                  //       ),
                  //       12.horizontalSpace,
                  //       _buildProgressWithText(text: '5 hours', value: .5)
                  //     ],
                  //   ),

                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Medicine left',
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
                          itemBuilder: (BuildContext context, int index) {
                            return _littleTablet(
                                isColored: index < lengthNeedToBeColored);
                          },
                        ),
                      ),
                      Text(
                        '${medicine.medicineTakenCount} / ${medicine.availableQuantity}',
                        style: secondaryTextStyle(size: 10),
                      ),
                    ],
                  )
                ]),
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

  String getRandomMedicineImage(int index) {
    final rand = index % 3 + 1;
    return 'assets/images/medicine_$rand.png';
  }

// New widget to display progress with text
  Widget _buildProgressWithText({required double value, required String text}) {
    final leftVal = (value / 2) * 100;
    Color bgColor = Colors.blue;

    if (value <= .2) {
      bgColor = Colors.red;
    } else if (value <= .5) {
      bgColor = Colors.green;
    } else {
      bgColor = Colors.blue;
    }

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          width: 150.w,
          height: 12, // Match the minHeight of the LinearProgressIndicator
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(
                10)), // Match the LinearProgressIndicator's borderRadius
            border: Border.all(
              color: bgColor, // Your border color
              width: 1, // Your border width
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
              value: value,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              backgroundColor: Colors.white,
              color: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(bgColor),
              minHeight: 12,
            ),
          ),
        ),
        Positioned(
          left: leftVal,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: primaryTextStyle(size: 10, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _timeOfDay({
    required String title,
    required bool isDone,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color:
            isDone ? AppColors.primaryColor.withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.done,
            size: 14,
            color: isDone
                ? AppColors.primaryColor
                : Color(0xFF002D6F).withOpacity(0.2),
          ),
          SizedBox(width: 4.w),
          Text(
            title,
            style: primaryTextStyle(
              size: 10,
              color: isDone ? AppColors.primaryColor : Color(0xFF002D6F),
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
      margin: EdgeInsets.only(right: 4),
      decoration: boxDecoration(
        radius: 10,
        bgColor: isColored ? AppColors.secondaryColor : AppColors.greyColor,
      ),
    );
  }
}
