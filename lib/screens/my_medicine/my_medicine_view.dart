import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/core/utils/schedule_calculator.dart';
import 'package:medicine_app/screens/add_medicine/view/add_new_medicine_view.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/screens/my_medicine/specific_medicine_view.dart';
import 'package:medicine_app/screens/my_medicine/widget/medicine_widget.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodel.dart';
import 'package:medicine_app/viewmodels/schedule_viewmodel.dart';
import 'package:nb_utils/nb_utils.dart';

class MyMedicineView extends ConsumerWidget {
  static const String routeName = '/my_medicine_view';
  const MyMedicineView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allMedsAsync = ref.watch(allMedicinesProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final specificDaysMedicines = ref.watch(medicinesForSelectedDateProvider);
    final logsForDate = ref.watch(logsForSpecificDateProvider(selectedDate)).value ?? [];

    return Scaffold(
      appBar: commonAppBarWidget(context, title: 'My Medicine', changeIcon: true),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: AppColors.secondaryColor,
        child: const Icon(
          Icons.add,
          color: white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNewMedicineScreen()),
          );
        },
      ),
      body: allMedsAsync.when(
        data: (allMeds) {
          if (allMeds.isEmpty) {
            return const Center(
              child: Text(
                "No Medicine Found. Tap + to add one!",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return Column(
            children: [
              _dateChoose(ref, selectedDate),
              if (specificDaysMedicines.isEmpty)
                const Center(
                  heightFactor: 8,
                  child: Text(
                    "No Medicine Scheduled for this date",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: specificDaysMedicines.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final medicine = specificDaysMedicines[index];
                    final nearestTimeLeft = ScheduleCalculator.getTimeUntilNextDose(
                      medicine.scheduleItems,
                      DateTime.now(),
                    );

                    final stockIndex = ScheduleCalculator.getStockProgressIndex(
                      availableQuantity: medicine.medicine.availableQuantity,
                      medicineTakenCount: medicine.medicine.medicineTakenCount,
                    );

                    return Bounceable(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SpecificMedicineView(
                              medicineModel: medicine,
                            ),
                          ),
                        );
                      },
                      child: MedicineWidget(
                        medicineName: medicine.medicine.medicineName,
                        timeLeft: nearestTimeLeft,
                        lengthNeedToBeColored: stockIndex,
                        index: index,
                        medicine: medicine,
                        imagePath: medicine.medicine.imagePath,
                        targetDate: selectedDate,
                        logs: logsForDate,
                      ),
                    );
                  },
                ).paddingAll(12),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }

  EasyDateTimeLine _dateChoose(WidgetRef ref, DateTime selectedDate) {
    return EasyDateTimeLine(
      initialDate: selectedDate,
      onDateChange: (date) {
        ref.read(selectedDateProvider.notifier).state = date;
      },
      headerProps: const EasyHeaderProps(
        monthPickerType: MonthPickerType.dropDown,
        showMonthPicker: true,
        showSelectedDate: true,
        selectedDateFormat: SelectedDateFormat.fullDateDMonthAsStrY,
      ),
      dayProps: const EasyDayProps(
        dayStructure: DayStructure.dayStrDayNum,
        activeDayStyle: DayStyle(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.secondaryColor,
                Color(0xff8426D6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
