import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/models/domain_models.dart';
import 'package:medicine_app/viewmodels/database_providers.dart';

/// Reactive stream of all medicine logs recorded for today
final todayLogsProvider = StreamProvider<List<MedicineLog>>((ref) {
  final repo = ref.watch(medicineLogRepositoryProvider);
  return repo.watchTodayLogs();
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
    int? dosageTaken,
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
    int? dosageTaken,
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

  /// Bulk action: marks all schedules for the specified medicine for today as taken
  Future<void> markAllDosesForTodayAsTaken(MedicineWithSchedules med) async {
    final now = DateTime.now();
    for (final schedule in med.schedules) {
      final scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
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

  Future<void> clearAllLogs() async {
    final repo = ref.read(medicineLogRepositoryProvider);
    await repo.clearAllLogs();
  }
}
