import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/models/medicine_model.dart';
import 'package:medicine_app/models/medicine_time_schedule.dart';
import 'package:medicine_app/models/repeat_variation.dart';
import 'package:medicine_app/screens/add_medicine/view/add_new_medicine_view.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/screens/my_medicine/widget/medicine_widget.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodels.dart';
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
      appBar:
          commonAppBarWidget(context, title: 'My Medicine', changeIcon: true),
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

            return MedicineWidget(
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

  bool _isTodayInList(List<DateTime> dates) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return dates.any((date) {
      final d = DateTime(date.year, date.month, date.day);
      return d == today;
    });
  }

  Duration? _getTimeUntilNextSchedule(List<ScheduleDayTime> scheduleList) {
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
