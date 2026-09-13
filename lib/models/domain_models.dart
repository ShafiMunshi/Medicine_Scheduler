import 'package:flutter/material.dart';

enum MealTiming {
  before,
  after;

  String get displayName => this == MealTiming.before ? 'Before meal' : 'After meal';
}

enum DosageUnit {
  pcs,
  cup;

  String get displayName => this == DosageUnit.pcs ? 'Pcs' : 'Cup';
}

enum RepeatVariation {
  day,
  weekly,
  monthly,
  timely;

  String get displayName {
    switch (this) {
      case RepeatVariation.day:
        return 'Day';
      case RepeatVariation.weekly:
        return 'Weekly';
      case RepeatVariation.monthly:
        return 'At Month';
      case RepeatVariation.timely:
        return 'Timely';
    }
  }
}

enum ConsumptionStatus {
  taken,
  skipped,
  missed;

  String get displayName {
    switch (this) {
      case ConsumptionStatus.taken:
        return 'Taken';
      case ConsumptionStatus.skipped:
        return 'Skipped';
      case ConsumptionStatus.missed:
        return 'Missed';
    }
  }
}

class MedicineScheduleItem {
  final int? id;
  final int? medicineId;
  final String dayTimeName; // e.g. 'Morning', 'Noon', 'Evening', 'Night'
  final String timeString; // e.g. '08:00'
  final int hour;
  final int minute;

  const MedicineScheduleItem({
    this.id,
    this.medicineId,
    required this.dayTimeName,
    required this.timeString,
    required this.hour,
    required this.minute,
  });

  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

  factory MedicineScheduleItem.fromTimeOfDay({
    int? id,
    int? medicineId,
    required String dayTimeName,
    required TimeOfDay time,
  }) {
    final hourStr = time.hour.toString().padLeft(2, '0');
    final minuteStr = time.minute.toString().padLeft(2, '0');
    return MedicineScheduleItem(
      id: id,
      medicineId: medicineId,
      dayTimeName: dayTimeName,
      timeString: '$hourStr:$minuteStr',
      hour: time.hour,
      minute: time.minute,
    );
  }

  MedicineScheduleItem copyWith({
    int? id,
    int? medicineId,
    String? dayTimeName,
    String? timeString,
    int? hour,
    int? minute,
  }) {
    return MedicineScheduleItem(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      dayTimeName: dayTimeName ?? this.dayTimeName,
      timeString: timeString ?? this.timeString,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }
}
