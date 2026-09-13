import 'package:medicine_app/data/database/app_database.dart';

/// Summarizes medication intake and adherence for a single day.
class DayAdherenceSummary {
  final DateTime date;
  final int totalScheduled;
  final int takenCount;
  final int missedCount;
  final List<MedicineWithSchedules> scheduledMedicines;
  final List<MedicineLog> logs;

  const DayAdherenceSummary({
    required this.date,
    required this.totalScheduled,
    required this.takenCount,
    required this.missedCount,
    this.scheduledMedicines = const [],
    this.logs = const [],
  });

  /// Whether all scheduled doses for this day were marked as taken.
  bool get isAllTaken => totalScheduled > 0 && takenCount >= totalScheduled;

  /// Whether at least one scheduled dose was missed on this day.
  bool get isMissed => missedCount > 0;

  /// Whether no medicines were scheduled for this day.
  bool get hasNoSchedule => totalScheduled == 0;

  /// Daily compliance percentage (0.0 to 100.0).
  double get complianceRate {
    if (totalScheduled == 0) return 100.0;
    return ((takenCount / totalScheduled) * 100).clamp(0.0, 100.0);
  }
}

/// Aggregates monthly medication compliance, perfect days, and missed doses.
class MonthAdherenceStats {
  final DateTime month;
  final int totalDaysInMonth;
  final int daysWithSchedule;
  final int perfectDaysCount;
  final int missedDaysCount;
  final int totalScheduledDoses;
  final int totalTakenDoses;
  final int totalMissedDoses;
  final double adherencePercentage;
  final List<DayAdherenceSummary> dailySummaries;

  const MonthAdherenceStats({
    required this.month,
    required this.totalDaysInMonth,
    required this.daysWithSchedule,
    required this.perfectDaysCount,
    required this.missedDaysCount,
    required this.totalScheduledDoses,
    required this.totalTakenDoses,
    required this.totalMissedDoses,
    required this.adherencePercentage,
    required this.dailySummaries,
  });

  factory MonthAdherenceStats.empty(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    return MonthAdherenceStats(
      month: month,
      totalDaysInMonth: daysInMonth,
      daysWithSchedule: 0,
      perfectDaysCount: 0,
      missedDaysCount: 0,
      totalScheduledDoses: 0,
      totalTakenDoses: 0,
      totalMissedDoses: 0,
      adherencePercentage: 100.0,
      dailySummaries: [],
    );
  }
}
