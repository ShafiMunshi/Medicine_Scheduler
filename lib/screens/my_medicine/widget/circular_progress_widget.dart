import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:nb_utils/nb_utils.dart';

class CircularProgressWidget extends StatelessWidget {
  const CircularProgressWidget(
      {super.key,
      required this.dateString,
      required this.title,
      required this.subTitle,
      required this.progressValue,
      required this.centerText,
      required this.centerSubText});

  final String dateString;
  final String title;
  final String subTitle;
  final double progressValue;
  final String centerText;
  final String centerSubText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.greyColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: boldTextStyle()),
              Text(subTitle, style: secondaryTextStyle()),
              Text(dateString, style: secondaryTextStyle()),
              10.verticalSpace,
              Center(child: medicineProgressIndicatorWidget()),
            ],
          )),
    );
  }

  SizedBox medicineProgressIndicatorWidget() {
    return SizedBox(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              value: progressValue,
              backgroundColor: AppColors.greyColor,
              color: AppColors.primaryColor,
              strokeWidth: 10,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(centerText,
                  textAlign: TextAlign.center, style: boldTextStyle()),
              Text(centerSubText,
                  textAlign: TextAlign.center,
                  style: secondaryTextStyle(size: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
