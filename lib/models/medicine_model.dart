import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Needed for TimeOfDay
import 'package:isar/isar.dart';

part 'medicine_model.g.dart';

enum RepeatVariation { timely, day, weekly, monthly }

enum MealTiming {
  before,
  after,
}

enum DosageUnit { pcs, cup }

@embedded
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
  String? dayTimeName; // Changed to nullable
  String? timeString; // Changed to nullable

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

  static String timeOfDayToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static TimeOfDay? stringToTimeOfDay(String? timeString) {
    if (timeString == null) return null;
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return null;
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null ||
          minute == null ||
          hour < 0 ||
          hour > 23 ||
          minute < 0 ||
          minute > 59) {
        return null;
      }
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      print("Error parsing time string '$timeString': $e");
      return null;
    }
  }
}

@collection
class MedicineModel {
  Id? id = Isar.autoIncrement;
  final String medicineName;
  final int dosage;
  @enumerated
  final DosageUnit dosageUnit;
  final int availableQuantity;
  @enumerated
  final MealTiming mealTiming;

  @enumerated
  final RepeatVariation repeatVariation;
  @ignore
  final Map<String, dynamic> repeatMap;
  RepeatVariationDays? repeatVariationDays;
  RepeatVariationWeek? repeatVariationWeek;
  RepeatVariationMonth? repeatVariationMonth;
  RepeatVariationTimes? repeatVariationTime;

  @ignore
  final Map<String, String> scheduleTimes;

  List<MedicineSchedule>? medicineScheduleList;
  final DateTime startDate;
  final DateTime? endDate;
  final String? imagePath;
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
      if (MedicineSchedule.stringToTimeOfDay(value) == null && kDebugMode) {
        print(
            "Warning: Invalid time format '$value' in scheduleTimes for key '$key'");
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

  String timeOfDayToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  TimeOfDay? stringToTimeOfDay(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return null;
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null ||
          minute == null ||
          hour < 0 ||
          hour > 23 ||
          minute < 0 ||
          minute > 59) {
        return null;
      }
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      print("Error parsing time string '$timeString': $e");
      return null;
    }
  }
}
