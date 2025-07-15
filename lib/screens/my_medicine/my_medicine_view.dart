import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/screens/my_medicine/timer_countdown_widget.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodels.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/screens/add_medicine/view/add_new_medicine_view.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/models/medicine_model.dart';
import 'package:medicine_app/models/medicine_time_schedule.dart';
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
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => AddNewMedicineScreen()));
          }),
      body: Consumer<MedicineViewmodels>(builder: (_, vm, child) {
        if (vm.isLoading) return Center(child: CircularProgressIndicator());
        // if (vm.errorMessage != null) {
        //   return Center(child: Text("Error: ${vm.errorMessage}"));
        // }
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

            final nearestTimeLeft =
                getHowMuchTimeLeftToTakeNearestMedicine(medicine);

            return medicineWidget(
                medicineName: medicine.medicineName,
                timeLeft: nearestTimeLeft,
                lengthNeedToBeColored:
                    getTotalProgressIndexHowMuchMedicineLeft(medicine),
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
    required Duration? timeLeft,
    required int lengthNeedToBeColored,
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
                  timeLeft == null
                      ? Text(
                          "No medicine today",
                          style: primaryTextStyle(size: 10),
                        )
                      :
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

                      CountdownWithValueNotifier(initialDuration: timeLeft),
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
  int getTotalProgressIndexHowMuchMedicineLeft(MedicineModel model) {
    double percentage =
        (model.availableQuantity / model.medicineTakenCount) * 100;

    int progressIndex = (percentage >= 80)
        ? 5
        : (percentage >= 60)
            ? 4
            : (percentage >= 40)
                ? 3
                : (percentage >= 20)
                    ? 2
                    : (percentage >= 1)
                        ? 1
                        : 0;

    return progressIndex;
  }

  // get how much time left to take the next medicine
  Duration? getHowMuchTimeLeftToTakeNearestMedicine(MedicineModel model) {
    if (model.finalScheduleDates == null) {
      return null;
    }

    if (_isTodayInList(model.finalScheduleDates!)) {
      if (model.medicineScheduleList != null) {
        log('1');
        final result = _getTimeUntilNextSchedule(model.medicineScheduleList!);
        log("value is $result");
        return result;
      }
    }
    log("model.medicineScheduleList is ${model.medicineScheduleList}");
    log("returning null from getHowMuchTimeLeftToTakeNearestMedicine");

    return null;
  }

  // get total estimated medicine will take by the user.
  int getTotalEstimatedMedicine(MedicineModel model) {
    return model.scheduleTimes.length *
        model.dosage *
        (model.finalScheduleDates?.length ?? 1);
  }

  bool _isTodayInList(List<DateTime> dates) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return dates.any((date) {
      final d = DateTime(date.year, date.month, date.day);
      return d == today;
    });
  }

  Duration? _getTimeUntilNextSchedule(List<ScheduleDayTime> scheduleList) {
    final now = TimeOfDay.now();
    final nowDateTime = DateTime.now();

    // Convert TimeOfDay to today's DateTime
    DateTime toTodayDateTime(TimeOfDay time) {
      return DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day,
          time.hour, time.minute);
    }

    // Filter and find upcoming times
    final upcomingTimes = scheduleList
        .where((s) => s.dayTime != null)
        .map((s) => toTodayDateTime(s.dayTime!))
        .where((dt) => dt.isAfter(nowDateTime))
        .toList();

    if (upcomingTimes.isEmpty) return null;

    upcomingTimes.sort(); // sort by soonest

    final nextTime = upcomingTimes.first;

    return nextTime.difference(nowDateTime);
  }
}
