import 'package:medicine_app/core/utils/schedule_calculator.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/models/adherence_summary.dart';

class AdherenceCalculator {
  AdherenceCalculator._();

  /// Calculates monthly adherence statistics and per-day breakdown for [targetMonth].
  static MonthAdherenceStats calculateMonthAdherence({
    required DateTime targetMonth,
    required List<MedicineWithSchedules> allMedicines,
    required List<MedicineLog> allLogs,
    DateTime? currentTime,
  }) {
    final now = currentTime ?? DateTime.now();
    final year = targetMonth.year;
    final month = targetMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    final dailySummaries = <DayAdherenceSummary>[];
    int perfectDaysCount = 0;
    int missedDaysCount = 0;
    int totalScheduledDoses = 0;
    int totalTakenDoses = 0;
    int totalMissedDoses = 0;
    int daysWithSchedule = 0;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final isFutureDay = date.isAfter(DateTime(now.year, now.month, now.day));

      // 1. Get medicines scheduled for this day
      final scheduledMeds = allMedicines.where((med) {
        return ScheduleCalculator.isDateScheduled(
          date: date,
          startDate: med.medicine.startDate,
          endDate: med.medicine.endDate,
          repeatVariation: med.repeatVariationEnum,
          repeatDays: med.medicine.repeatDays,
          weekDays: med.weekDaysList,
          monthDays: med.monthDaysList,
        );
      }).toList();

      int dayScheduledDoses = 0;
      int dayTakenCount = 0;
      int dayMissedCount = 0;
      final dayLogs = <MedicineLog>[];

      for (final med in scheduledMeds) {
        for (final schedule in med.schedules) {
          dayScheduledDoses++;
          final scheduledDateTime = DateTime(
            year,
            month,
            day,
            schedule.hour,
            schedule.minute,
          );

          // Find log for this specific schedule and dose
          final log = allLogs.where((l) {
            return l.medicineId == med.medicine.id &&
                l.scheduledDateTime.year == scheduledDateTime.year &&
                l.scheduledDateTime.month == scheduledDateTime.month &&
                l.scheduledDateTime.day == scheduledDateTime.day &&
                l.scheduledDateTime.hour == scheduledDateTime.hour &&
                l.scheduledDateTime.minute == scheduledDateTime.minute;
          }).firstOrNull;

          if (log != null) {
            dayLogs.add(log);
            if (log.status == 'taken') {
              dayTakenCount++;
            } else {
              dayMissedCount++;
            }
          } else {
            // No log recorded yet
            if (scheduledDateTime.isBefore(now)) {
              // Past due without intake is counted as missed
              dayMissedCount++;
            }
          }
        }
      }

      final isAllTaken = !isFutureDay && dayScheduledDoses > 0 && dayTakenCount >= dayScheduledDoses;
      final isMissed = dayMissedCount > 0;

      if (dayScheduledDoses > 0) {
        daysWithSchedule++;
        totalScheduledDoses += dayScheduledDoses;
        totalTakenDoses += dayTakenCount;
        totalMissedDoses += dayMissedCount;

        if (isAllTaken) {
          perfectDaysCount++;
        }
        if (isMissed) {
          missedDaysCount++;
        }
      }

      dailySummaries.add(DayAdherenceSummary(
        date: date,
        totalScheduled: dayScheduledDoses,
        takenCount: dayTakenCount,
        missedCount: dayMissedCount,
        scheduledMedicines: scheduledMeds,
        logs: dayLogs,
      ));
    }

    // Calculate adherence percentage based on past and current doses
    final totalEligibleDoses = totalTakenDoses + totalMissedDoses;
    final adherenceRate = totalEligibleDoses == 0
        ? 100.0
        : ((totalTakenDoses / totalEligibleDoses) * 100).clamp(0.0, 100.0);

    return MonthAdherenceStats(
      month: DateTime(year, month, 1),
      totalDaysInMonth: daysInMonth,
      daysWithSchedule: daysWithSchedule,
      perfectDaysCount: perfectDaysCount,
      missedDaysCount: missedDaysCount,
      totalScheduledDoses: totalScheduledDoses,
      totalTakenDoses: totalTakenDoses,
      totalMissedDoses: totalMissedDoses,
      adherencePercentage: adherenceRate,
      dailySummaries: dailySummaries,
    );
  }
}
