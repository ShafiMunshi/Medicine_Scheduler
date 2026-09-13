import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_app/core/utils/schedule_calculator.dart';
import 'package:medicine_app/models/domain_models.dart';

void main() {
  group('ScheduleCalculator - calculateScheduledDates', () {
    test('Daily repeat generates every day correctly', () {
      final start = DateTime(2026, 1, 1);
      final end = DateTime(2026, 1, 5);

      final dates = ScheduleCalculator.calculateScheduledDates(
        startDate: start,
        endDate: end,
        repeatVariation: RepeatVariation.day,
        repeatDays: 1,
      );

      expect(dates.length, 5);
      expect(dates.first, DateTime(2026, 1, 1));
      expect(dates.last, DateTime(2026, 1, 5));
    });

    test('Daily repeat every 2 days generates alternating dates', () {
      final start = DateTime(2026, 1, 1);
      final end = DateTime(2026, 1, 5);

      final dates = ScheduleCalculator.calculateScheduledDates(
        startDate: start,
        endDate: end,
        repeatVariation: RepeatVariation.day,
        repeatDays: 2,
      );

      expect(dates.length, 3);
      expect(dates, [
        DateTime(2026, 1, 1),
        DateTime(2026, 1, 3),
        DateTime(2026, 1, 5),
      ]);
    });

    test('Weekly repeat generates only selected weekdays', () {
      final start = DateTime(2026, 1, 5); // Monday
      final end = DateTime(2026, 1, 11); // Sunday

      final dates = ScheduleCalculator.calculateScheduledDates(
        startDate: start,
        endDate: end,
        repeatVariation: RepeatVariation.weekly,
        weekDays: ['Mon', 'Wed', 'Fri'],
      );

      expect(dates.length, 3);
      expect(dates.map((d) => d.weekday), [
        DateTime.monday,
        DateTime.wednesday,
        DateTime.friday,
      ]);
    });

    test('Monthly repeat generates only selected days of the month', () {
      final start = DateTime(2026, 1, 1);
      final end = DateTime(2026, 3, 31);

      final dates = ScheduleCalculator.calculateScheduledDates(
        startDate: start,
        endDate: end,
        repeatVariation: RepeatVariation.monthly,
        monthDays: [1, 15],
      );

      // 2 per month for 3 months = 6 dates
      expect(dates.length, 6);
      expect(dates.every((d) => d.day == 1 || d.day == 15), isTrue);
    });

    test('Returns empty list when endDate is before startDate', () {
      final start = DateTime(2026, 2, 10);
      final end = DateTime(2026, 2, 1);

      final dates = ScheduleCalculator.calculateScheduledDates(
        startDate: start,
        endDate: end,
        repeatVariation: RepeatVariation.day,
      );

      expect(dates, isEmpty);
    });
  });

  group('ScheduleCalculator - isDateScheduled', () {
    test('Correctly identifies daily schedules', () {
      final start = DateTime(2026, 1, 1);
      final end = DateTime(2026, 1, 10);

      final isScheduled = ScheduleCalculator.isDateScheduled(
        date: DateTime(2026, 1, 5),
        startDate: start,
        endDate: end,
        repeatVariation: RepeatVariation.day,
        repeatDays: 2,
      );

      expect(isScheduled, isTrue); // Jan 1, 3, 5, 7, 9
    });

    test('Correctly rejects non-scheduled date', () {
      final start = DateTime(2026, 1, 1);
      final end = DateTime(2026, 1, 10);

      final isScheduled = ScheduleCalculator.isDateScheduled(
        date: DateTime(2026, 1, 4),
        startDate: start,
        endDate: end,
        repeatVariation: RepeatVariation.day,
        repeatDays: 2,
      );

      expect(isScheduled, isFalse);
    });
  });

  group('ScheduleCalculator - Notification ID Precision', () {
    test('Generates deterministic positive 31-bit integer', () {
      final date = DateTime(2026, 5, 20);
      final id1 = ScheduleCalculator.generateNotificationId(10, 2, date);
      final id2 = ScheduleCalculator.generateNotificationId(10, 2, date);

      expect(id1, id2);
      expect(id1 >= 0, isTrue);
      expect(id1 <= 0x7FFFFFFF, isTrue);
    });

    test('Different inputs produce unique IDs (zero collisions in typical space)', () {
      final ids = <int>{};
      final date = DateTime(2026, 5, 20);

      for (int med = 1; med <= 20; med++) {
        for (int sched = 1; sched <= 4; sched++) {
          for (int day = 1; day <= 14; day++) {
            final testDate = date.add(Duration(days: day));
            final id = ScheduleCalculator.generateNotificationId(med, sched, testDate);
            ids.add(id);
          }
        }
      }

      // 20 medicines * 4 times/day * 14 days = 1120 schedules
      expect(ids.length, 20 * 4 * 14);
    });
  });

  group('ScheduleCalculator - Metrics & Adherence', () {
    test('Stock progress index calculation', () {
      expect(ScheduleCalculator.getStockProgressIndex(availableQuantity: 100, medicineTakenCount: 10), 5);
      expect(ScheduleCalculator.getStockProgressIndex(availableQuantity: 50, medicineTakenCount: 50), 3);
      expect(ScheduleCalculator.getStockProgressIndex(availableQuantity: 0, medicineTakenCount: 50), 0);
    });

    test('Course progress calculation', () {
      expect(ScheduleCalculator.getCourseProgress(totalEstimatedDoses: 100, takenCount: 50), 0.5);
      expect(ScheduleCalculator.getCourseProgress(totalEstimatedDoses: 100, takenCount: 100), 1.0);
      expect(ScheduleCalculator.getCourseProgress(totalEstimatedDoses: 0, takenCount: 0), 0.0);
    });

    test('Estimated pill difference calculation', () {
      final diff = ScheduleCalculator.getEstimatedPillDifference(
        totalDosesPerDay: 3,
        dosagePerTime: 2,
        totalScheduledDays: 10,
        availableQuantity: 50,
      );
      // 3 * 2 * 10 = 60 pills needed - 50 available = 10 needed
      expect(diff, 10);
    });
  });
}
