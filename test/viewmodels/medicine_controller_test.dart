import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/models/domain_models.dart';
import 'package:medicine_app/viewmodels/database_providers.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodel.dart';
import 'package:medicine_app/viewmodels/schedule_viewmodel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test('MedicineController adds medicine and updates allMedicinesProvider', () async {
    final controller = container.read(medicineControllerProvider.notifier);
    final now = DateTime.now();

    final id = await controller.addMedicine(
      medicineName: 'Omeprazole',
      dosage: 1,
      dosageUnit: DosageUnit.pcs,
      availableQuantity: 14,
      mealTiming: MealTiming.before,
      repeatVariation: RepeatVariation.day,
      repeatDays: 1,
      startDate: now,
      endDate: now.add(const Duration(days: 14)),
      scheduleTimes: {
        'Morning': const TimeOfDay(hour: 7, minute: 30),
      },
    );

    expect(id, isNotNull);

    // Read all medicines from the stream provider
    final meds = await container.read(allMedicinesProvider.future);
    expect(meds.length, 1);
    expect(meds.first.medicine.medicineName, 'Omeprazole');
    expect(meds.first.schedules.length, 1);
    expect(meds.first.schedules.first.dayTimeName, 'Morning');
  });

  test('TodayMedicinesProvider includes medicine scheduled for today', () async {
    final controller = container.read(medicineControllerProvider.notifier);
    final now = DateTime.now();

    await controller.addMedicine(
      medicineName: 'Ibuprofen',
      dosage: 1,
      dosageUnit: DosageUnit.pcs,
      availableQuantity: 20,
      mealTiming: MealTiming.after,
      repeatVariation: RepeatVariation.day,
      repeatDays: 1,
      startDate: now,
      endDate: now.add(const Duration(days: 5)),
      scheduleTimes: {
        'Noon': const TimeOfDay(hour: 13, minute: 0),
      },
    );

    // Allow stream to emit
    await container.read(allMedicinesProvider.future);

    final todayMeds = container.read(todayMedicinesProvider);
    expect(todayMeds.length, 1);
    expect(todayMeds.first.medicine.medicineName, 'Ibuprofen');
  });

  test('ScheduleController marks dose as taken and updates stock', () async {
    final medController = container.read(medicineControllerProvider.notifier);
    final schedController = container.read(scheduleControllerProvider.notifier);
    final now = DateTime.now();

    final medId = await medController.addMedicine(
      medicineName: 'Metformin',
      dosage: 2,
      dosageUnit: DosageUnit.pcs,
      availableQuantity: 50,
      mealTiming: MealTiming.after,
      repeatVariation: RepeatVariation.day,
      repeatDays: 1,
      startDate: now,
      endDate: now.add(const Duration(days: 30)),
      scheduleTimes: {
        'Morning': const TimeOfDay(hour: 8, minute: 0),
      },
    );

    expect(medId, isNotNull);

    final scheduledDateTime = DateTime(now.year, now.month, now.day, 8, 0);
    await schedController.markDoseAsTaken(
      medicineId: medId!,
      scheduledDateTime: scheduledDateTime,
      dosageTaken: 2,
    );

    final repo = container.read(medicineRepositoryProvider);
    final updatedMed = await repo.getMedicineById(medId);

    expect(updatedMed?.medicine.availableQuantity, 48); // 50 - 2
    expect(updatedMed?.medicine.medicineTakenCount, 1);
  });
}
