import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/app/viewmodels/medicine_viewmodels.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/app/screens/add_medicine/view/add_new_medicine_view.dart';
import 'package:medicine_app/app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/models/medicine_model.dart';
import 'package:medicine_app/models/repeat_variation.dart';
import 'package:medicine_app/widgets/common/app_slideablde_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class MyMedicineView extends StatefulWidget {
  static const String routeName = '/my_medicine_view';
  const MyMedicineView({super.key});

  @override
  State<MyMedicineView> createState() => _MyMedicineViewState();
}

class _MyMedicineViewState extends State<MyMedicineView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicineViewmodels>().get_all_medicine();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
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
            Navigator.pushNamed(context, AddNewMedicineScreen.routeName);
          }),
      body: Consumer<MedicineViewmodels>(builder: (context, vm, child) {
        if (vm.isLoading) return Center(child: CircularProgressIndicator());
        if (vm.medicines.isEmpty) {
          return Center(
            child: Text("No Medicine Found"),
          );
        }
        return ListView.builder(
          itemCount: vm.medicines.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final medicine = vm.medicines[index];

            return medicineWidget(
                medicineName: medicine.medicineName,
                timeLeft: '5',
                availableMedicine: '2',
                index: index,
                medicine: medicine,
                imagePath: medicine.imagePath);
          },
        ).paddingAll(12);
      }),
    );
  }

  AppSlidableWidget medicineWidget({
    required String medicineName,
    required String timeLeft,
    required String availableMedicine,
    required int index,
    required MedicineModel medicine,
    String? imagePath,
  }) {
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

  String getRandomMedicineImage(int index) {
    final rand = index % 3 + 1;
    return 'assets/images/medicine_$rand.png';
  }

  // TODO: this function calculate the remaining time when user will take the pill / cups on nearest time..
  getRemainingTimeToTakeNearestMedicine(MedicineModel model) {
    switch (model.repeatVariation) {
      case RepeatVariation.day:
        break;
      default:
    }

    model.medicineScheduleList;
  }

  // Calculate from how much days go and how much medicine user has taken...
  getHowMuchMedicineLeft() {}
  // TODO: create a function which will return the nearest period when user will take medicine..
}
