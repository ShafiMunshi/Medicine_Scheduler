import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:nb_utils/nb_utils.dart';

class ScheduleView extends StatefulWidget {
  static const String routeName = '/schedule_screen';
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(context,
          title: 'Medicine Details',
          changeIcon: true,
          iconWidget1: SvgPicture.asset('assets/icons/edit_square.svg')
              .paddingRight(20)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medication Info
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CircleAvatar(
                        radius: 70.r,
                        backgroundColor: AppColors.secondaryColor,
                        child: CircleAvatar(
                          radius: 68.r,
                          backgroundImage: AssetImage('assets/images/napa.png'),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 7.0),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Before meal',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  15.verticalSpace,
                  const Text(
                    'Napa (500mg)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Beximco Pharmaceuticals Ltd.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  15.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Every day',
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
                          '3 times',
                          style: boldTextStyle(color: white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            const SizedBox(height: 8),
            _buildScheduleRow('Morning', '8:00 AM', true),
            const SizedBox(height: 8),
            _buildScheduleRow('Noon', '8:00 AM', false),
            const SizedBox(height: 8),
            _buildScheduleRow('Night', '8:00 AM', false),
            const SizedBox(height: 16),

            // Add More Medicines Link
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add more medicines',
                  style: secondaryTextStyle(),
                ),
                Row(
                  children: [
                    Icon(
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
                      '50 Pcs',
                      style: primaryTextStyle(
                          size: 11, color: AppColors.primaryColor),
                    )
                  ],
                )
              ],
            ),
            10.verticalSpace,

            // Quantity Selector
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    decoration:
                        boxDecoration(radius: 10, color: AppColors.greyColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            // setState(() {
                            //   if (quantity > 0) quantity--;
                            // });
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        Text(
                          '0 Pcs',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          onPressed: () {
                            // setState(() {
                            //   if (quantity < 50) quantity++;
                            // });
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
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
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
              ],
            ),
            const SizedBox(height: 24),

            // I Have Taken Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'I have taken medicine',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build schedule rows
  Widget _buildScheduleRow(String timeOfDay, String time, bool isChecked) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Transform.scale(
              scale: 1.4,
              child: Checkbox(
                value: isChecked,
                onChanged: (value) {},
                activeColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Text(
              timeOfDay,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.alarm,
              color: Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              time,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
