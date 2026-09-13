import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_app/core/utils/schedule_calculator.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/models/domain_models.dart';
import 'package:medicine_app/viewmodels/database_providers.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodel.dart';

/// The currently selected date in the Schedule screen
final scheduleSelectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// Reactive stream of all medicine logs recorded for today
final todayLogsProvider = StreamProvider<List<MedicineLog>>((ref) {
  final repo = ref.watch(medicineLogRepositoryProvider);
  return repo.watchTodayLogs();
});

/// Reactive stream of all medicine logs recorded for the selected schedule date
final logsForScheduleDateProvider = StreamProvider<List<MedicineLog>>((ref) {
  final repo = ref.watch(medicineLogRepositoryProvider);
  final targetDate = ref.watch(scheduleSelectedDateProvider);
  return repo.watchLogsForDate(targetDate);
});

/// Reactive stream of medicine logs for any specific date
final logsForSpecificDateProvider =
    StreamProvider.family<List<MedicineLog>, DateTime>((ref, date) {
  final repo = ref.watch(medicineLogRepositoryProvider);
  return repo.watchLogsForDate(date);
});

/// Medicines scheduled for the selected schedule date
final medicinesForScheduleDateProvider = Provider<List<MedicineWithSchedules>>((ref) {
  final allMedsAsync = ref.watch(allMedicinesProvider);
  final targetDate = ref.watch(scheduleSelectedDateProvider);
  final date = DateTime(targetDate.year, targetDate.month, targetDate.day);

  return allMedsAsync.when(
    data: (allMeds) {
      return allMeds.where((m) {
        return ScheduleCalculator.isDateScheduled(
          date: date,
          startDate: m.medicine.startDate,
          endDate: m.medicine.endDate,
          repeatVariation: m.repeatVariationEnum,
          repeatDays: m.medicine.repeatDays,
          weekDays: m.weekDaysList,
          monthDays: m.monthDaysList,
        );
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

/// All historical medicine logs
final allLogsProvider = FutureProvider<List<MedicineLog>>((ref) {
  final repo = ref.watch(medicineLogRepositoryProvider);
  return repo.getAllLogs();
});

/// Specific medicine logs provider
final medicineLogsProvider =
    FutureProvider.family<List<MedicineLog>, int>((ref, medicineId) {
  final repo = ref.watch(medicineLogRepositoryProvider);
  return repo.getLogsForMedicine(medicineId);
});

/// Controller for marking doses taken, skipped, or reverting
final scheduleControllerProvider =
    StateNotifierProvider<ScheduleController, AsyncValue<void>>((ref) {
  return ScheduleController(ref);
});

class ScheduleController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  ScheduleController(this.ref) : super(const AsyncValue.data(null));

  Future<void> markDoseAsTaken({
    required int medicineId,
    int? scheduleId,
    required DateTime scheduledDateTime,
    double? dosageTaken,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(medicineLogRepositoryProvider);
      await repo.markDose(
        medicineId: medicineId,
        scheduleId: scheduleId,
        scheduledDateTime: scheduledDateTime,
        status: ConsumptionStatus.taken,
        dosageTaken: dosageTaken,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      log('Error marking dose as taken: $e\n$st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markDoseAsSkipped({
    required int medicineId,
    int? scheduleId,
    required DateTime scheduledDateTime,
    double? dosageTaken,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(medicineLogRepositoryProvider);
      await repo.markDose(
        medicineId: medicineId,
        scheduleId: scheduleId,
        scheduledDateTime: scheduledDateTime,
        status: ConsumptionStatus.skipped,
        dosageTaken: dosageTaken,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      log('Error marking dose as skipped: $e\n$st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> revertDose({
    required int medicineId,
    required DateTime scheduledDateTime,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(medicineLogRepositoryProvider);
      await repo.revertDose(
        medicineId: medicineId,
        scheduledDateTime: scheduledDateTime,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      log('Error reverting dose: $e\n$st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleDoseTaken({
    required int medicineId,
    int? scheduleId,
    required DateTime scheduledDateTime,
    required double dosage,
    required bool isCurrentlyTaken,
  }) async {
    if (isCurrentlyTaken) {
      await revertDose(
        medicineId: medicineId,
        scheduledDateTime: scheduledDateTime,
      );
    } else {
      await markDoseAsTaken(
        medicineId: medicineId,
        scheduleId: scheduleId,
        scheduledDateTime: scheduledDateTime,
        dosageTaken: dosage,
      );
    }
  }

  /// Bulk action: marks all schedules for the specified medicine for a given date as taken
  Future<void> markAllDosesForDateAsTaken(DateTime date, MedicineWithSchedules med) async {
    for (final schedule in med.schedules) {
      final scheduledDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        schedule.hour,
        schedule.minute,
      );
      await markDoseAsTaken(
        medicineId: med.medicine.id,
        scheduleId: schedule.id,
        scheduledDateTime: scheduledDateTime,
        dosageTaken: med.medicine.dosage,
      );
    }
  }

  /// Bulk action: marks all schedules for the specified medicine for today as taken
  Future<void> markAllDosesForTodayAsTaken(MedicineWithSchedules med) async {
    await markAllDosesForDateAsTaken(DateTime.now(), med);
  }

  Future<void> clearAllLogs() async {
    final repo = ref.read(medicineLogRepositoryProvider);
    await repo.clearAllLogs();
  }
}
