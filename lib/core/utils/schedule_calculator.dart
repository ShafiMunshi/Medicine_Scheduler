import 'package:medicine_app/models/domain_models.dart';

class ScheduleCalculator {
  static const Map<String, int> weekdayMap = {
    'Mon': DateTime.monday,
    'Tue': DateTime.tuesday,
    'Wed': DateTime.wednesday,
    'Thu': DateTime.thursday,
    'Fri': DateTime.friday,
    'Sat': DateTime.saturday,
    'Sun': DateTime.sunday,
  };

  /// Generates all calendar dates (normalized to 00:00:00) when a medicine should be taken.
  static List<DateTime> calculateScheduledDates({
    required DateTime startDate,
    required DateTime endDate,
    required RepeatVariation repeatVariation,
    int? repeatDays,
    List<String>? weekDays,
    List<int>? monthDays,
  }) {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    if (end.isBefore(start)) return [];

    final result = <DateTime>[];

    switch (repeatVariation) {
      case RepeatVariation.day:
      case RepeatVariation.timely:
        final interval = (repeatDays == null || repeatDays < 1) ? 1 : repeatDays;
        DateTime current = start;
        while (!current.isAfter(end)) {
          result.add(current);
          current = current.add(Duration(days: interval));
        }
        break;

      case RepeatVariation.weekly:
        final desiredDays = (weekDays ?? [])
            .map((w) => weekdayMap[w.trim()])
            .whereType<int>()
            .toSet();

        if (desiredDays.isEmpty) return [];

        DateTime current = start;
        while (!current.isAfter(end)) {
          if (desiredDays.contains(current.weekday)) {
            result.add(current);
          }
          current = current.add(const Duration(days: 1));
        }
        break;

      case RepeatVariation.monthly:
        final validDays = (monthDays ?? [])
            .toSet()
            .where((d) => d >= 1 && d <= 31);

        if (validDays.isEmpty) return [];

        for (int y = start.year; y <= end.year; y++) {
          final startMonth = (y == start.year) ? start.month : 1;
          final endMonth = (y == end.year) ? end.month : 12;

          for (int m = startMonth; m <= endMonth; m++) {
            final daysInMonth = DateTime(y, m + 1, 0).day;
            for (final d in validDays) {
              if (d <= daysInMonth) {
                final date = DateTime(y, m, d);
                if (!date.isBefore(start) && !date.isAfter(end)) {
                  result.add(date);
                }
              }
            }
          }
        }
        result.sort();
        break;
    }

    return result;
  }

  /// Checks if a specific date (year, month, day) is scheduled for this medicine.
  static bool isDateScheduled({
    required DateTime date,
    required DateTime startDate,
    required DateTime endDate,
    required RepeatVariation repeatVariation,
    int? repeatDays,
    List<String>? weekDays,
    List<int>? monthDays,
  }) {
    final target = DateTime(date.year, date.month, date.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    if (target.isBefore(start) || target.isAfter(end)) {
      return false;
    }

    switch (repeatVariation) {
      case RepeatVariation.day:
      case RepeatVariation.timely:
        final interval = (repeatDays == null || repeatDays < 1) ? 1 : repeatDays;
        final differenceInDays = target.difference(start).inDays;
        return differenceInDays >= 0 && (differenceInDays % interval == 0);

      case RepeatVariation.weekly:
        final desiredDays = (weekDays ?? [])
            .map((w) => weekdayMap[w.trim()])
            .whereType<int>()
            .toSet();
        return desiredDays.contains(target.weekday);

      case RepeatVariation.monthly:
        final validDays = (monthDays ?? []).toSet();
        return validDays.contains(target.day);
    }
  }

  /// Calculates the duration until the next upcoming scheduled dose for today.
  /// Returns null if all scheduled doses for today have already passed or list is empty.
  static Duration? getTimeUntilNextDose(
    List<MedicineScheduleItem> schedules,
    DateTime now,
  ) {
    if (schedules.isEmpty) return null;

    final upcoming = schedules
        .map((s) => DateTime(now.year, now.month, now.day, s.hour, s.minute))
        .where((dt) => dt.isAfter(now))
        .toList();

    if (upcoming.isEmpty) return null;

    upcoming.sort();
    return upcoming.first.difference(now);
  }

  /// Generates a deterministic, positive 31-bit integer for notification ID.
  /// Android notification IDs MUST fit in a signed 32-bit int (0 to 2,147,483,647).
  static int generateNotificationId(int medicineId, int scheduleId, DateTime date) {
    final dateKey = date.year * 10000 + date.month * 100 + date.day;
    final hash = Object.hash(medicineId, scheduleId, dateKey);
    return hash & 0x7FFFFFFF;
  }

  /// Calculates an integer 0-5 indicating pill stock progress.
  static int getStockProgressIndex({
    required num availableQuantity,
    required num medicineTakenCount,
  }) {
    if (availableQuantity <= 0) return 0;
    if (medicineTakenCount <= 0) return 5;

    final percentage = (availableQuantity / (availableQuantity + medicineTakenCount)) * 100;
    if (percentage >= 80) return 5;
    if (percentage >= 60) return 4;
    if (percentage >= 40) return 3;
    if (percentage >= 20) return 2;
    if (percentage >= 1) return 1;
    return 0;
  }

  /// Formats a dosage number nicely (e.g. 1 -> '1', 2.5 -> '2.5') with its unit.
  static String formatDosage(double dosage, DosageUnit unit) {
    final dosageStr = (dosage == dosage.truncateToDouble())
        ? dosage.toInt().toString()
        : dosage.toStringAsFixed(1);
    return '$dosageStr ${unit.displayName}';
  }

  /// Formats a number without unnecessary decimal places.
  static String formatNumber(num value) {
    return (value == value.truncateToDouble())
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }

  /// Calculates overall course progress (0.0 to 1.0).
  static double getCourseProgress({
    required int totalEstimatedDoses,
    required int takenCount,
  }) {
    if (totalEstimatedDoses <= 0) return 0.0;
    final progress = (takenCount / totalEstimatedDoses).clamp(0.0, 1.0);
    return double.parse(progress.toStringAsFixed(2));
  }

  /// Calculates estimated additional pills needed (or excess pills if negative).
  static int getEstimatedPillDifference({
    required int totalDosesPerDay,
    required num dosagePerTime,
    required int totalScheduledDays,
    required num availableQuantity,
  }) {
    final totalPillsNeeded = totalDosesPerDay * dosagePerTime * totalScheduledDays;
    return (totalPillsNeeded - availableQuantity).ceil();
  }
}
