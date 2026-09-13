import 'dart:convert';
import 'dart:developer';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_app/core/utils/schedule_calculator.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/models/domain_models.dart';
import 'package:medicine_app/service/notification_service.dart';
import 'package:medicine_app/viewmodels/database_providers.dart';

/// Stream of all medicines with their schedule items
final allMedicinesProvider = StreamProvider<List<MedicineWithSchedules>>((ref) {
  final repo = ref.watch(medicineRepositoryProvider);
  return repo.watchAllMedicines();
});

/// Currently selected date in the calendar/timeline view
final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// List of medicines that are scheduled for the selected date
final medicinesForSelectedDateProvider = Provider<List<MedicineWithSchedules>>((ref) {
  final allMedsAsync = ref.watch(allMedicinesProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  return allMedsAsync.when(
    data: (allMeds) {
      return allMeds.where((m) {
        return ScheduleCalculator.isDateScheduled(
          date: selectedDate,
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

/// List of medicines that are scheduled for TODAY
final todayMedicinesProvider = Provider<List<MedicineWithSchedules>>((ref) {
  final allMedsAsync = ref.watch(allMedicinesProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return allMedsAsync.when(
    data: (allMeds) {
      return allMeds.where((m) {
        return ScheduleCalculator.isDateScheduled(
          date: today,
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

/// Controller for Medicine CRUD actions
final medicineControllerProvider =
    StateNotifierProvider<MedicineController, AsyncValue<void>>((ref) {
  return MedicineController(ref);
});

class MedicineController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  MedicineController(this.ref) : super(const AsyncValue.data(null));

  Future<int?> addMedicine({
    required String medicineName,
    required int dosage,
    required DosageUnit dosageUnit,
    required int availableQuantity,
    required MealTiming mealTiming,
    required RepeatVariation repeatVariation,
    int? repeatDays,
    List<String>? weekDays,
    List<int>? monthDays,
    required DateTime startDate,
    required DateTime endDate,
    required Map<String, TimeOfDay> scheduleTimes,
    String? imagePath,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(medicineRepositoryProvider);
      final now = DateTime.now();

      final medCompanion = MedicinesCompanion(
        medicineName: Value(medicineName),
        imagePath: Value(imagePath),
        dosage: Value(dosage),
        dosageUnit: Value(dosageUnit.name),
        availableQuantity: Value(availableQuantity),
        mealTiming: Value(mealTiming.name),
        repeatVariation: Value(repeatVariation.name),
        repeatDays: Value(repeatDays),
        repeatWeekDays: Value(weekDays != null ? jsonEncode(weekDays) : null),
        repeatMonthDays: Value(monthDays != null ? jsonEncode(monthDays) : null),
        startDate: Value(startDate),
        endDate: Value(endDate),
        medicineTakenCount: const Value(0),
        createdAt: Value(now),
        modifiedAt: Value(now),
      );

      final scheduleCompanions = scheduleTimes.entries.map((entry) {
        final hourStr = entry.value.hour.toString().padLeft(2, '0');
        final minuteStr = entry.value.minute.toString().padLeft(2, '0');
        return MedicineSchedulesCompanion(
          dayTimeName: Value(entry.key),
          timeString: Value('$hourStr:$minuteStr'),
          hour: Value(entry.value.hour),
          minute: Value(entry.value.minute),
        );
      }).toList();

      final id = await repo.insertMedicine(
        medicine: medCompanion,
        schedules: scheduleCompanions,
      );

      // Reschedule all notifications with the new medicine included
      final allMeds = await repo.getAllMedicines();
      await NotificationService.rescheduleAllActiveMedicines(allMeds);

      state = const AsyncValue.data(null);
      return id;
    } catch (e, st) {
      log('Error adding medicine: $e\n$st');
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> updateMedicine({
    required int id,
    required String medicineName,
    required int dosage,
    required DosageUnit dosageUnit,
    required int availableQuantity,
    required MealTiming mealTiming,
    required RepeatVariation repeatVariation,
    int? repeatDays,
    List<String>? weekDays,
    List<int>? monthDays,
    required DateTime startDate,
    required DateTime endDate,
    required Map<String, TimeOfDay> scheduleTimes,
    String? imagePath,
    int? existingTakenCount,
    DateTime? existingCreatedAt,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(medicineRepositoryProvider);
      final now = DateTime.now();

      final medCompanion = MedicinesCompanion(
        id: Value(id),
        medicineName: Value(medicineName),
        imagePath: Value(imagePath),
        dosage: Value(dosage),
        dosageUnit: Value(dosageUnit.name),
        availableQuantity: Value(availableQuantity),
        mealTiming: Value(mealTiming.name),
        repeatVariation: Value(repeatVariation.name),
        repeatDays: Value(repeatDays),
        repeatWeekDays: Value(weekDays != null ? jsonEncode(weekDays) : null),
        repeatMonthDays: Value(monthDays != null ? jsonEncode(monthDays) : null),
        startDate: Value(startDate),
        endDate: Value(endDate),
        medicineTakenCount: Value(existingTakenCount ?? 0),
        createdAt: Value(existingCreatedAt ?? now),
        modifiedAt: Value(now),
      );

      final scheduleCompanions = scheduleTimes.entries.map((entry) {
        final hourStr = entry.value.hour.toString().padLeft(2, '0');
        final minuteStr = entry.value.minute.toString().padLeft(2, '0');
        return MedicineSchedulesCompanion(
          dayTimeName: Value(entry.key),
          timeString: Value('$hourStr:$minuteStr'),
          hour: Value(entry.value.hour),
          minute: Value(entry.value.minute),
        );
      }).toList();

      await repo.updateMedicine(
        medicine: medCompanion,
        schedules: scheduleCompanions,
      );

      // Reschedule all active notifications
      final allMeds = await repo.getAllMedicines();
      await NotificationService.rescheduleAllActiveMedicines(allMeds);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      log('Error updating medicine: $e\n$st');
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> deleteMedicine(int id) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(medicineRepositoryProvider);
      await repo.deleteMedicine(id);

      // Reschedule remaining active notifications
      final allMeds = await repo.getAllMedicines();
      await NotificationService.rescheduleAllActiveMedicines(allMeds);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      log('Error deleting medicine: $e\n$st');
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> addStock(int id, int amountToAdd) async {
    try {
      final repo = ref.read(medicineRepositoryProvider);
      final med = await repo.getMedicineById(id);
      if (med != null) {
        await repo.updateMedicineStock(
          medicineId: id,
          availableQuantity: med.medicine.availableQuantity + amountToAdd,
        );
      }
    } catch (e, st) {
      log('Error adding stock: $e\n$st');
    }
  }
}
