import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Needed for TimeOfDay
import 'package:isar/isar.dart';
import 'package:medicine_app/widgets/common/common_fn.dart';

part 'medicine_model.g.dart';

enum RepeatVariation { timely, day, weekly, monthly }

enum MealTiming {
  before,
  after,
}

enum DosageUnit { pcs, cup }

@embedded
// Stores the day count which will be repeated every after that day.
class RepeatVariationDays {
  String? day; // Changed to nullable
  RepeatVariationDays({this.day}); // Optional parameter
}

@embedded
class RepeatVariationTimes {
  String? dayTime; // Changed to nullable
  RepeatVariationTimes({this.dayTime}); // Optional parameter
}

@embedded
class RepeatVariationWeek {
  List<String>? weekDays; // Changed to nullable
  RepeatVariationWeek({this.weekDays}); // Optional parameter
}

@embedded
class RepeatVariationMonth {
  List<String>? days; // Changed to nullable
  RepeatVariationMonth({this.days}); // Optional parameter
}

@embedded
class MedicineSchedule {
  String? dayTimeName; // Changed to nullable -- Morning , AfterNoon, Noon
  String? timeString; // Changed to nullable -- 8:00 , 1:00, 6:00

  MedicineSchedule({this.dayTimeName, this.timeString}); // Optional parameters

  @ignore
  TimeOfDay? get dayTime {
    return stringToTimeOfDay(timeString);
  }

  factory MedicineSchedule.fromTimeOfDay(String? name, TimeOfDay time) {
    return MedicineSchedule(
      dayTimeName: name,
      timeString: timeOfDayToString(time),
    );
  }
}

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

  /// This won't be used anywhere, it's just used to replicate the , Morning, Noon [MedicineSchedule]  just for the Add New. Medicine Page to then save to ISAR
  @ignore
  final Map<String, String> scheduleTimes;

  /// On the dayTime when when this medicine will be taken by user [Morning , 8:00]
  List<MedicineSchedule>? medicineScheduleList;

  /// when the medicine will be started
  final DateTime startDate;

  /// when the medicine will be end
  final DateTime? endDate;

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
    this.repeatVariationDays,
    this.repeatVariationWeek,
    this.repeatVariationMonth,
    this.repeatVariationTime,
    this.medicineScheduleList,
    Map<String, String>? scheduleTimes,
    required this.startDate,
    this.endDate,
    this.imagePath,
    required this.createdAt,
    required this.modifiedAt,
    Map<String, dynamic>? repeatMap,
  })  : repeatMap = repeatMap ?? {},
        scheduleTimes = scheduleTimes ?? {} {
    medicineScheduleList = medicineScheduleList ?? [];
    this.scheduleTimes.forEach((key, value) {
      if (stringToTimeOfDay(value) == null && kDebugMode) {
        log("Warning: Invalid time format '$value' in scheduleTimes for key '$key'");
      }
      medicineScheduleList!
          .add(MedicineSchedule(dayTimeName: key, timeString: value));
    });

    switch (repeatVariation) {
      case RepeatVariation.day:
        repeatVariationDays =
            RepeatVariationDays(day: repeatMap?['day']?.toString());
        break;
      case RepeatVariation.weekly:
        repeatVariationWeek =
            RepeatVariationWeek(weekDays: repeatMap?['days']?.cast<String>());
        break;
      case RepeatVariation.timely:
        repeatVariationTime =
            RepeatVariationTimes(dayTime: repeatMap?['dayTime']?.toString());
        break;
      case RepeatVariation.monthly:
        repeatVariationMonth =
            RepeatVariationMonth(days: repeatMap?['days']?.cast<String>());
        break;
    }
  }
}
