import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_app/core/utils/schedule_calculator.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/models/domain_models.dart';
import 'package:medicine_app/service/notification_service.dart';
import 'package:medicine_app/viewmodels/auth_viewmodel.dart';
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
    required double dosage,
    required DosageUnit dosageUnit,
    required double availableQuantity,
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

      // Store medicine data to Firebase Firestore
      _saveToFirestoreSafely(
        medicineName: medicineName,
        dosage: dosage,
        dosageUnit: dosageUnit.name,
        availableQuantity: availableQuantity,
        mealTiming: mealTiming.name,
        repeatVariation: repeatVariation.name,
        repeatDays: repeatDays,
        weekDays: weekDays,
        monthDays: monthDays,
        startDate: startDate,
        endDate: endDate,
        scheduleTimes: scheduleTimes,
        imagePath: imagePath,
      );

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
    required double dosage,
    required DosageUnit dosageUnit,
    required double availableQuantity,
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

      // Update medicine in Firestore
      _saveToFirestoreSafely(
        medicineName: medicineName,
        dosage: dosage,
        dosageUnit: dosageUnit.name,
        availableQuantity: availableQuantity,
        mealTiming: mealTiming.name,
        repeatVariation: repeatVariation.name,
        repeatDays: repeatDays,
        weekDays: weekDays,
        monthDays: monthDays,
        startDate: startDate,
        endDate: endDate,
        scheduleTimes: scheduleTimes,
        imagePath: imagePath,
        medicineTakenCount: existingTakenCount ?? 0,
      );

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
      final med = await repo.getMedicineById(id);
      await repo.deleteMedicine(id);

      // Reschedule remaining active notifications
      final allMeds = await repo.getAllMedicines();
      await NotificationService.rescheduleAllActiveMedicines(allMeds);

      // Delete from Firestore
      if (med != null) {
        _deleteFromFirestoreSafely(medicineName: med.medicine.medicineName);
      }

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      log('Error deleting medicine: $e\n$st');
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> addStock(int id, double amountToAdd) async {
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

  /// Fetches all added medicines from Firebase Firestore and upserts them to local storage
  Future<MedicineSyncSummary> syncMedicinesFromFirestore(
    String uid, {
    void Function(String message, double progress)? onProgress,
  }) async {
    try {
      onProgress?.call('Connecting to Cloud Firestore...', 0.1);
      final firestore = ref.read(firestoreServiceProvider);
      final repo = ref.read(medicineRepositoryProvider);

      onProgress?.call('Fetching saved medicines from cloud...', 0.3);
      final remoteMeds = await firestore.fetchUserMedicines(uid);

      if (remoteMeds.isEmpty) {
        onProgress?.call('No cloud medicines found.', 1.0);
        return const MedicineSyncSummary(
          totalFound: 0,
          totalUpserted: 0,
          medicineNames: [],
          isSuccess: true,
        );
      }

      final List<String> upsertedNames = [];
      final double progressStep = 0.5 / remoteMeds.length;

      for (int i = 0; i < remoteMeds.length; i++) {
        final data = remoteMeds[i];
        final name = (data['medicineName'] as String?)?.trim() ?? 'Medicine';
        onProgress?.call(
          'Upserting $name (${i + 1}/${remoteMeds.length})...',
          0.3 + (i * progressStep),
        );

        // Parse repeatWeekDays
        String? weekDaysJson;
        if (data['repeatWeekDays'] != null) {
          if (data['repeatWeekDays'] is List) {
            weekDaysJson = jsonEncode(data['repeatWeekDays']);
          } else if (data['repeatWeekDays'] is String) {
            weekDaysJson = data['repeatWeekDays'] as String;
          }
        }

        // Parse repeatMonthDays
        String? monthDaysJson;
        if (data['repeatMonthDays'] != null) {
          if (data['repeatMonthDays'] is List) {
            monthDaysJson = jsonEncode(data['repeatMonthDays']);
          } else if (data['repeatMonthDays'] is String) {
            monthDaysJson = data['repeatMonthDays'] as String;
          }
        }

        // Parse dates safely
        DateTime startDate = DateTime.now();
        if (data['startDate'] != null) {
          if (data['startDate'] is Timestamp) {
            startDate = (data['startDate'] as Timestamp).toDate();
          } else if (data['startDate'] is String) {
            startDate = DateTime.tryParse(data['startDate'] as String) ?? DateTime.now();
          }
        }

        DateTime endDate = DateTime.now().add(const Duration(days: 30));
        if (data['endDate'] != null) {
          if (data['endDate'] is Timestamp) {
            endDate = (data['endDate'] as Timestamp).toDate();
          } else if (data['endDate'] is String) {
            endDate = DateTime.tryParse(data['endDate'] as String) ??
                DateTime.now().add(const Duration(days: 30));
          }
        }

        final now = DateTime.now();
        final medCompanion = MedicinesCompanion(
          medicineName: Value(name),
          imagePath: Value(data['imagePath'] as String?),
          dosage: Value((data['dosage'] as num?)?.toDouble() ?? 1.0),
          dosageUnit: Value((data['dosageUnit'] as String?) ?? 'pcs'),
          availableQuantity: Value((data['availableQuantity'] as num?)?.toDouble() ?? 0.0),
          mealTiming: Value((data['mealTiming'] as String?) ?? 'before'),
          repeatVariation: Value((data['repeatVariation'] as String?) ?? 'day'),
          repeatDays: Value(data['repeatDays'] as int?),
          repeatWeekDays: Value(weekDaysJson),
          repeatMonthDays: Value(monthDaysJson),
          startDate: Value(startDate),
          endDate: Value(endDate),
          medicineTakenCount: Value((data['medicineTakenCount'] as num?)?.toInt() ?? 0),
          createdAt: Value(now),
          modifiedAt: Value(now),
        );

        final rawSchedules = data['schedules'] as List<dynamic>? ?? [];
        final scheduleCompanions = rawSchedules.map((s) {
          final sMap = Map<String, dynamic>.from(s as Map);
          final dayTimeName = sMap['dayTimeName'] as String? ?? 'Morning';
          final timeString = sMap['timeString'] as String? ?? '08:00';
          final hour = (sMap['hour'] as num?)?.toInt() ?? 8;
          final minute = (sMap['minute'] as num?)?.toInt() ?? 0;
          return MedicineSchedulesCompanion(
            dayTimeName: Value(dayTimeName),
            timeString: Value(timeString),
            hour: Value(hour),
            minute: Value(minute),
          );
        }).toList();

        if (scheduleCompanions.isEmpty) {
          scheduleCompanions.add(
            const MedicineSchedulesCompanion(
              dayTimeName: Value('Morning'),
              timeString: Value('08:00'),
              hour: Value(8),
              minute: Value(0),
            ),
          );
        }

        await repo.upsertMedicine(
          medicine: medCompanion,
          schedules: scheduleCompanions,
        );
        upsertedNames.add(name);
      }

      onProgress?.call('Updating reminder notifications...', 0.9);
      final allMeds = await repo.getAllMedicines();
      await NotificationService.rescheduleAllActiveMedicines(allMeds);

      onProgress?.call('Sync complete!', 1.0);
      return MedicineSyncSummary(
        totalFound: remoteMeds.length,
        totalUpserted: upsertedNames.length,
        medicineNames: upsertedNames,
        isSuccess: true,
      );
    } catch (e, st) {
      log('Error syncing medicines from Firestore: $e\n$st');
      return MedicineSyncSummary(
        totalFound: 0,
        totalUpserted: 0,
        medicineNames: [],
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  void _saveToFirestoreSafely({
    required String medicineName,
    required double dosage,
    required String dosageUnit,
    required double availableQuantity,
    required String mealTiming,
    required String repeatVariation,
    int? repeatDays,
    List<String>? weekDays,
    List<int>? monthDays,
    required DateTime startDate,
    required DateTime endDate,
    required Map<String, TimeOfDay> scheduleTimes,
    String? imagePath,
    int medicineTakenCount = 0,
  }) {
    try {
      final user = fb.FirebaseAuth.instance.currentUser;
      if (user != null) {
        final firestore = ref.read(firestoreServiceProvider);
        final schedulesList = scheduleTimes.entries.map((entry) {
          final hourStr = entry.value.hour.toString().padLeft(2, '0');
          final minuteStr = entry.value.minute.toString().padLeft(2, '0');
          return {
            'dayTimeName': entry.key,
            'timeString': '$hourStr:$minuteStr',
            'hour': entry.value.hour,
            'minute': entry.value.minute,
          };
        }).toList();

        firestore.saveMedicine(
          uid: user.uid,
          medicineName: medicineName,
          dosage: dosage,
          dosageUnit: dosageUnit,
          availableQuantity: availableQuantity,
          mealTiming: mealTiming,
          repeatVariation: repeatVariation,
          repeatDays: repeatDays,
          repeatWeekDays: weekDays,
          repeatMonthDays: monthDays,
          startDate: startDate,
          endDate: endDate,
          medicineTakenCount: medicineTakenCount,
          imagePath: imagePath,
          schedules: schedulesList,
        ).catchError((e) {
          log('Error syncing medicine to Firestore in background: $e');
        });
      }
    } catch (e) {
      log('Firestore sync notice (safe to ignore if unauthenticated/offline): $e');
    }
  }

  void _deleteFromFirestoreSafely({required String medicineName}) {
    try {
      final user = fb.FirebaseAuth.instance.currentUser;
      if (user != null) {
        final firestore = ref.read(firestoreServiceProvider);
        firestore.deleteMedicineFromFirestore(
          uid: user.uid,
          medicineName: medicineName,
        ).catchError((e) {
          log('Error deleting medicine from Firestore in background: $e');
        });
      }
    } catch (e) {
      log('Firestore delete notice: $e');
    }
  }
}
