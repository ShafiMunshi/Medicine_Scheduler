import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_assets.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeView extends StatelessWidget {
  static const String routeName = '/home_view';
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topProfileSections(),
          29.verticalSpace,
          topHorizontalProgressBar(),
          29.verticalSpace,
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              color: Color(0xFFF3F3F7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Next Medication',
                          style: boldTextStyle(),
                        ),
                        Text(
                          'See All',
                          style: secondaryTextStyle(),
                        ),
                      ]),
                  10.verticalSpace,
                  Expanded(
                    child: ListView.builder(
                      itemCount: 3,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return medicineWidget();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: double.maxFinite,
                    child: Image.asset(
                      'assets/images/ads.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ).paddingOnly(top: 20),
    );
  }

  Container medicineWidget() {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 8),
      decoration: boxDecoration(bgColor: white, radius: 16.r),
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

  Widget topHorizontalProgressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _topCardWidget(
              asset: AppAssets.clockk,
              data: '06',
              subTitle: 'Remaining today',
              color: AppColors.mistiColor),
        ),
        15.horizontalSpace,
        Flexible(
          child: _topCardWidget(
              asset: AppAssets.tablet,
              data: '13',
              subTitle: 'Total Medicine',
              color: AppColors.purpleLow),
        ),
      ],
    ).paddingSymmetric(horizontal: 20);
  }

  Container _topCardWidget({
    required String asset,
    required String data,
    required String subTitle,
    required Color color,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10.r),
      decoration: boxDecoration(bgColor: color, radius: 16.r),
      child: Row(children: [
        SvgPicture.asset(asset),
        10.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data,
              style: boldTextStyle(size: 14),
            ),
            Text(
              subTitle,
              style: secondaryTextStyle(size: 14),
            ),
          ],
        )
      ]),
    );
  }

  Widget topProfileSections() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(
        children: [
          SizedBox(
              height: 50.w,
              width: 50.w,
              child: Image.asset('assets/images/avatar.png')),
          15.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Zahidul',
                    style: boldTextStyle(),
                  ),
                  Text(
                    ' Hossain',
                    style: primaryTextStyle(),
                  ),
                ],
              ),
              Text(
                '24 years old',
                style: secondaryTextStyle(),
              ),
            ],
          )
        ],
      ),
      Container(
        padding: EdgeInsets.all(15),
        decoration: boxDecoration(
            bgColor: white, radius: 12.r, color: AppColors.greyColor),
        child: SvgPicture.asset(
          AppAssets.notifications,
        ),
      )
    ]).paddingSymmetric(horizontal: 20);
  }
}
