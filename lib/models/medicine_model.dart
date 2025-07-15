// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:medicine_app/models/medicine_time_schedule.dart';
import 'package:medicine_app/models/repeat_variation.dart';
import 'package:medicine_app/widgets/common/common_fn.dart';
import 'package:medicine_app/widgets/common_extension.dart';

part 'medicine_model.g.dart';

enum MealTiming {
  before,
  after,
}

enum DosageUnit { pcs, cup }

@collection
class MedicineModel {
  Id? id = Isar.autoIncrement;
  final String medicineName;

  /// Medicine Image picture path
  final String? imagePath;

  /// how dose user need to take per time
  final int dosage;

  /// Will he take that dose based on Pcs/Cup
  @enumerated
  final DosageUnit dosageUnit;

  /// For the first time, it assign the total available quantity the user have.
  final int availableQuantity;

  ///  before eat / after eat
  @enumerated
  final MealTiming mealTiming;

  /// how the medicine will repeated - Daily / Weekly / Monthly , returns enum
  @enumerated
  final RepeatVariation repeatVariation;

  /// ignore this to use any data from the map. This map is used to show data conditionally in [Add New Medicine Page] then add to ISAR
  @ignore
  final Map<String, dynamic> repeatMap;

  /// repeat every after [day] , if it's 1,that means it will be repeated everyday
  RepeatVariationDays? repeatVariationDays;

  /// only repeat on which weekdays [Saturday, Sunday, Monday, etc.. ]
  RepeatVariationWeek? repeatVariationWeek;

  /// only repeat on the date of that Month
  RepeatVariationMonth? repeatVariationMonth;

  ///This data is not using---
  RepeatVariationTimes? repeatVariationTime;

  /// This won't be used anywhere, it's just used to replicate the , Morning, Noon [ScheduleDayTime]  just for the Add New. Medicine Page to then save to ISAR
  @ignore
  final Map<String, String> scheduleTimes;

  /// On the dayTime when when this medicine will be taken by user [Morning , 8:00]
  List<ScheduleDayTime>? medicineScheduleList;

  /// This list store the List of all dates when user will take medicine..
  List<DateTime>? finalScheduleDates;

  /// when the medicine will be started
  final DateTime startDate;

  /// when the medicine will be end
  final DateTime endDate;

  final int medicineTakenCount;

  final DateTime createdAt;
  final DateTime modifiedAt;

  MedicineModel({
    this.id,
    required this.medicineName,
    required this.dosage,
    required this.dosageUnit,
    required this.availableQuantity,
    required this.mealTiming,
    required this.repeatVariation,
    required this.medicineTakenCount,
    this.repeatVariationDays,
    this.repeatVariationWeek,
    this.repeatVariationMonth,
    this.repeatVariationTime,
    this.medicineScheduleList,
    this.finalScheduleDates,
    Map<String, String>? scheduleTimes,
    required this.startDate,
    required this.endDate,
    this.imagePath,
    required this.createdAt,
    required this.modifiedAt,
    Map<String, dynamic>? repeatMap,
    bool isUpdating = false,
  })  : repeatMap = repeatMap ?? {},
        scheduleTimes = scheduleTimes ?? {} {
    // in case of update - clear the old remaining medicineScheduleList then insert the new
    medicineScheduleList = isUpdating ? [] : medicineScheduleList ?? [];
    this.scheduleTimes.forEach((key, value) {
      if (stringToTimeOfDay(value) == null && kDebugMode) {
        log("Warning: Invalid time format '$value' in scheduleTimes for key '$key'");
      }
      medicineScheduleList!
          .add(ScheduleDayTime(dayTimeName: key, timeString: value));
    });

    switch (repeatVariation) {
      case RepeatVariation.day:
        try {
          repeatVariationDays ??=
              RepeatVariationDays(day: repeatMap?['day']?.toString());

          // assign to Final Schedule Dates according repeated date
          finalScheduleDates = _getDatesByRepeatDays(
              startDate: startDate,
              endDate: endDate,
              repeatDays: repeatVariationDays!.day.toInt());
        } catch (e) {
          log("Error found to : case RepeatVariation.day in MedicineModel{} $e");
        }
        break;
      case RepeatVariation.weekly:
        try {
          if (isUpdating) {
            repeatVariationWeek = RepeatVariationWeek(
                weekDays: repeatMap?['days']?.cast<String>());
          } else {
            repeatVariationWeek ??= RepeatVariationWeek(
                weekDays: repeatMap?['days']?.cast<String>());
          }

          // assign to Final Schedule Dates according repeated date
          finalScheduleDates = _getDatesByWeekdays(
              startDate: startDate,
              endDate: endDate,
              weekdays: repeatVariationWeek!.weekDays!);
        } catch (e) {
          log("Error found to : case RepeatVariation.weekly in MedicineModel{} $e");
        }
        break;
      case RepeatVariation.timely:
        repeatVariationTime ??=
            RepeatVariationTimes(dayTime: repeatMap?['dayTime']?.toString());
        break;
      case RepeatVariation.monthly:
        try {
          repeatVariationMonth ??=
              RepeatVariationMonth(days: repeatMap?['days']?.cast<int>());

          // assign to Final Schedule Dates according repeated date
          finalScheduleDates = _getMonthlyRepeatedDates(
              startDate: startDate,
              endDate: endDate,
              dayNumbers: repeatVariationMonth!.days!);
        } catch (e) {
          log("Error found to : case RepeatVariation.monthly in MedicineModel{} $e");
        }
        break;
    }
  }

  List<DateTime> _getDatesByWeekdays({
    required DateTime startDate,
    required DateTime endDate,
    required List<String> weekdays,
  }) {
    // Mapping short weekday names to DateTime weekday integers
    const weekdayMap = {
      'Mon': DateTime.monday,
      'Tue': DateTime.tuesday,
      'Wed': DateTime.wednesday,
      'Thu': DateTime.thursday,
      'Fri': DateTime.friday,
      'Sat': DateTime.saturday,
      'Sun': DateTime.sunday,
    };

    // Convert provided weekday names to int
    final desiredWeekdayInts = weekdays
        .map((day) => weekdayMap[day.trim()])
        .where((w) => w != null)
        .cast<int>()
        .toSet();

    final result = <DateTime>[];
    DateTime current = startDate;

    while (!current.isAfter(endDate)) {
      if (desiredWeekdayInts.contains(current.weekday)) {
        result.add(current);
      }
      current = current.add(const Duration(days: 1));
    }

    return result;
  }

  List<DateTime> _getDatesByRepeatDays({
    required DateTime startDate,
    required DateTime endDate,
    required int repeatDays,
  }) {
    repeatDays = repeatDays < 1 ? 1 : repeatDays;
    final result = <DateTime>[];
    for (var i = startDate;
        i.isBefore(endDate);
        i = i.add(Duration(days: repeatDays))) {
      result.add(i);
    }
    return result;
  }

  List<DateTime> _getMonthlyRepeatedDates({
    required DateTime startDate,
    required DateTime endDate,
    required List<int> dayNumbers,
  }) {
    final result = <DateTime>[];

    // Normalize and remove duplicates
    final validDays = dayNumbers.toSet().where((d) => d >= 1 && d <= 31);

    for (int year = startDate.year; year <= endDate.year; year++) {
      for (int month = 1; month <= 12; month++) {
        for (final day in validDays) {
          try {
            final date = DateTime(year, month, day);
            if (!date.isBefore(startDate) && !date.isAfter(endDate)) {
              result.add(date);
            }
          } catch (_) {
            // Invalid day in month (e.g., 30 Feb), ignore
          }
        }
      }
    }

    return result..sort();
  }

  @override
  String toString() {
    return 'MedicineModel(id: $id, medicineName: $medicineName, imagePath: $imagePath, dosage: $dosage, dosageUnit: $dosageUnit, availableQuantity: $availableQuantity, mealTiming: $mealTiming, repeatVariation: $repeatVariation, repeatMap: $repeatMap, repeatVariationDays: $repeatVariationDays, repeatVariationWeek: $repeatVariationWeek, repeatVariationMonth: $repeatVariationMonth, repeatVariationTime: $repeatVariationTime, scheduleTimes: $scheduleTimes, medicineScheduleList: $medicineScheduleList, finalScheduleDates: ${finalScheduleDates?.map((e) => e.day).toList().join(', ')}, startDate: ${startDate.toFormattedDate()}, endDate: ${endDate?.toFormattedDate()}, createdAt: ${createdAt.toFormattedDate()}, modifiedAt: $modifiedAt)';
  }

  MedicineModel copyWith({
    Id? id,
    String? medicineName,
    String? imagePath,
    int? dosage,
    DosageUnit? dosageUnit,
    int? availableQuantity,
    MealTiming? mealTiming,
    RepeatVariation? repeatVariation,
    Map<String, dynamic>? repeatMap,
    RepeatVariationDays? repeatVariationDays,
    RepeatVariationWeek? repeatVariationWeek,
    RepeatVariationMonth? repeatVariationMonth,
    RepeatVariationTimes? repeatVariationTime,
    Map<String, String>? scheduleTimes,
    List<ScheduleDayTime>? medicineScheduleList,
    List<DateTime>? finalScheduleDates,
    DateTime? startDate,
    DateTime? endDate,
    int? medicineTakenCount,
    DateTime? createdAt,
    DateTime? modifiedAt,
    bool? isUpdating,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      imagePath: imagePath ?? this.imagePath,
      dosage: dosage ?? this.dosage,
      dosageUnit: dosageUnit ?? this.dosageUnit,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      mealTiming: mealTiming ?? this.mealTiming,
      repeatVariation: repeatVariation ?? this.repeatVariation,
      repeatMap: repeatMap ?? this.repeatMap,
      repeatVariationDays: repeatVariationDays ?? this.repeatVariationDays,
      repeatVariationWeek: repeatVariationWeek ?? this.repeatVariationWeek,
      repeatVariationMonth: repeatVariationMonth ?? this.repeatVariationMonth,
      repeatVariationTime: repeatVariationTime ?? this.repeatVariationTime,
      scheduleTimes: scheduleTimes ?? this.scheduleTimes,
      medicineScheduleList: medicineScheduleList ?? this.medicineScheduleList,
      finalScheduleDates: finalScheduleDates ?? this.finalScheduleDates,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      medicineTakenCount: medicineTakenCount ?? this.medicineTakenCount,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      isUpdating: isUpdating ?? false,
    );
  }
}



// TODO: when user will take a medicine : 
// 1. decrease availableQuantity and medicineTakenCount
// 2. add the data in MedicineConsumedModel 


