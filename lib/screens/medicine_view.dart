import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/screens/add_medicine/view/add_medicine_view.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:nb_utils/nb_utils.dart';

class MedicineView extends StatelessWidget {
  static const String routeName = '/my_medicine_view';
  const MedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(context,
          title: 'My Medicine',
          changeIcon: true,
          iconWidget1: SvgPicture.asset('assets/icons/edit_square.svg')
              .paddingRight(20)),
      floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          backgroundColor: AppColors.secondaryColor,
          child: Icon(
            Icons.add,
            color: white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, AddMedicineScreen.routeName);
          }),
      body: ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return medicineWidget();
        },
      ).paddingAll(12),
    );
  }

  Container medicineWidget() {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 8),
      decoration: boxDecoration(bgColor: white, radius: 16.r, showShadow: true),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 84.w,
                  width: 84.w,
                  child:
                      Image.asset('assets/images/napa.png', fit: BoxFit.cover)),
              12.horizontalSpace,
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Napa (500mg)',
                  style: boldTextStyle(size: 15),
                ),
                Text(
                  'Beximco pharmaceuticals Ltd.',
                  style: secondaryTextStyle(size: 12),
                ),
                6.verticalSpace,
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _timeOfDay(title: 'Morning', isDone: true),
                    15.horizontalSpace,
                    _timeOfDay(title: 'Noon', isDone: false),
                    15.horizontalSpace,
                    _timeOfDay(title: 'Night', isDone: false),
                  ],
                ),
                6.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Time left',
                      style: primaryTextStyle(size: 10),
                    ),
                    12.horizontalSpace,
                    _buildProgressWithText(text: '5 hours', value: .5)
                  ],
                ),
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
                          return _littleTablet();
                        },
                      ),
                    ),
                    Text(
                      '100 / 50',
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
    );
  }

  Container _littleTablet() {
    return Container(
      height: 7.h,
      width: 18.w,
      margin: EdgeInsets.only(right: 4),
      decoration: boxDecoration(
        radius: 10,
        bgColor: AppColors.secondaryColor,
      ),
    );
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

  Row _timeOfDay({
    required String title,
    required bool isDone,
  }) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.done,
          size: 14,
          color: isDone
              ? AppColors.primaryColor
              : Color(0xFF002D6F).withValues(alpha: .2),
        ),
        Text(
          title,
          style: primaryTextStyle(
              size: 10,
              color: isDone ? AppColors.primaryColor : Color(0xFF002D6F)),
        ),
      ],
    );
  }
}
