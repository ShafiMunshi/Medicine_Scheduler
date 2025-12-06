import 'package:isar/isar.dart';

part 'repeat_variation.g.dart';

enum RepeatVariation { timely, day, weekly, monthly }

@embedded
// Stores the day count which will be repeated every after that day.
class   RepeatVariationDays {
  String? day;
  RepeatVariationDays({this.day});

  @override
  String toString() => 'RepeatVariationDays(day: $day)';
}

@embedded
class RepeatVariationTimes {
  String? dayTime;
  RepeatVariationTimes({this.dayTime});

  @override
  String toString() => 'RepeatVariationTimes(dayTime: $dayTime)';
}

@embedded
class RepeatVariationWeek {
  List<String>? weekDays;
  RepeatVariationWeek({this.weekDays});

  @override
  String toString() => 'RepeatVariationWeek(weekDays: $weekDays)';
}

@embedded
class RepeatVariationMonth {
  List<int>? days;
  RepeatVariationMonth({this.days});

  @override
  String toString() => 'RepeatVariationMonth(days: $days)';
}
