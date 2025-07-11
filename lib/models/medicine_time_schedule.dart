import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:medicine_app/widgets/common/common_fn.dart';

part 'medicine_time_schedule.g.dart';

@embedded
class ScheduleDayTime {
  String? dayTimeName; // Changed to nullable -- Morning , AfterNoon, Noon
  String? timeString; // Changed to nullable -- 8:00 , 1:00, 6:00

  ScheduleDayTime({this.dayTimeName, this.timeString}); // Optional parameters

  @ignore
  TimeOfDay? get dayTime {
    return stringToTimeOfDay(timeString);
  }

  factory ScheduleDayTime.fromTimeOfDay(String? name, TimeOfDay time) {
    return ScheduleDayTime(
      dayTimeName: name,
      timeString: timeOfDayToString(time),
    );
  }

  @override
  String toString() =>
      'ScheduleDayTime(dayTimeName: $dayTimeName, timeString: $timeString)';
}
