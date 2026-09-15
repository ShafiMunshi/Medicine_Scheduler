import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/data/repositories/medicine_log_repository.dart';
import 'package:medicine_app/data/repositories/medicine_repository.dart';
import 'package:medicine_app/models/domain_models.dart';

void main() {
  late AppDatabase db;
  late DriftMedicineRepository medicineRepo;
  late DriftMedicineLogRepository logRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    medicineRepo = DriftMedicineRepository(db);
    logRepo = DriftMedicineLogRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('Insert medicine with multiple schedules and retrieve with schedules', () async {
    final now = DateTime.now();

    final med = MedicinesCompanion.insert(
      medicineName: 'Paracetamol',
      dosage: const Value(2.0),
      dosageUnit: 'pcs',
      availableQuantity: const Value(20.0),
      mealTiming: 'after',
      repeatVariation: 'day',
      startDate: now,
      endDate: now.add(const Duration(days: 10)),
      createdAt: now,
      modifiedAt: now,
    );

    final schedules = <MedicineSchedulesCompanion>[
      MedicineSchedulesCompanion.insert(
        dayTimeName: 'Morning',
        timeString: '08:00',
        hour: 8,
        minute: 0,
        medicineId: 0,
      ),
      MedicineSchedulesCompanion.insert(
        dayTimeName: 'Night',
        timeString: '20:00',
        hour: 20,
        minute: 0,
        medicineId: 0,
      ),
    ];

    final medId = await medicineRepo.insertMedicine(
      medicine: med,
      schedules: schedules,
    );

    expect(medId, isPositive);

    final allMeds = await medicineRepo.getAllMedicines();
    expect(allMeds.length, 1);
    expect(allMeds.first.medicine.medicineName, 'Paracetamol');
    expect(allMeds.first.schedules.length, 2);
    expect(allMeds.first.schedules[0].dayTimeName, 'Morning');
    expect(allMeds.first.schedules[1].dayTimeName, 'Night');
  });

  test('Cascade delete removes schedules and logs when medicine is deleted', () async {
    final now = DateTime.now();

    final medId = await medicineRepo.insertMedicine(
      medicine: MedicinesCompanion.insert(
        medicineName: 'Amoxicillin',
        dosage: const Value(1.0),
        dosageUnit: 'cup',
        mealTiming: 'before',
        repeatVariation: 'weekly',
        startDate: now,
        endDate: now.add(const Duration(days: 7)),
        createdAt: now,
        modifiedAt: now,
      ),
      schedules: [
        MedicineSchedulesCompanion.insert(
          dayTimeName: 'Noon',
          timeString: '12:00',
          hour: 12,
          minute: 0,
          medicineId: 0,
        ),
      ],
    );

    // Add a log
    await logRepo.markDose(
      medicineId: medId,
      scheduledDateTime: now,
      status: ConsumptionStatus.taken,
      dosageTaken: 1.0,
    );

    expect(await db.select(db.medicineSchedules).get(), isNotEmpty);
    expect(await db.select(db.medicineLogs).get(), isNotEmpty);

    // Delete medicine
    await medicineRepo.deleteMedicine(medId);

    // Schedules and logs should be cascade-deleted
    final remainingMeds = await medicineRepo.getAllMedicines();
    final remainingSchedules = await db.select(db.medicineSchedules).get();
    final remainingLogs = await db.select(db.medicineLogs).get();

    expect(remainingMeds, isEmpty);
    expect(remainingSchedules, isEmpty);
    expect(remainingLogs, isEmpty);
  });

  test('Marking dose as taken updates inventory and taken count transactionally', () async {
    final now = DateTime.now();

    final medId = await medicineRepo.insertMedicine(
      medicine: MedicinesCompanion.insert(
        medicineName: 'Vitamin C',
        dosage: const Value(1.0),
        dosageUnit: 'pcs',
        availableQuantity: const Value(30.0),
        mealTiming: 'after',
        repeatVariation: 'day',
        startDate: now,
        endDate: now.add(const Duration(days: 30)),
        createdAt: now,
        modifiedAt: now,
      ),
      schedules: [
        MedicineSchedulesCompanion.insert(
          dayTimeName: 'Morning',
          timeString: '09:00',
          hour: 9,
          minute: 0,
          medicineId: 0,
        ),
      ],
    );

    // Mark dose as taken
    final scheduledTime = DateTime(now.year, now.month, now.day, 9, 0);
    await logRepo.markDose(
      medicineId: medId,
      scheduledDateTime: scheduledTime,
      status: ConsumptionStatus.taken,
      dosageTaken: 1.0,
    );

    final medAfterTaken = await medicineRepo.getMedicineById(medId);
    expect(medAfterTaken?.medicine.availableQuantity, 29.0); // 30.0 - 1.0
    expect(medAfterTaken?.medicine.medicineTakenCount, 1); // 0 + 1

    // Revert dose
    await logRepo.revertDose(
      medicineId: medId,
      scheduledDateTime: scheduledTime,
    );

    final medAfterRevert = await medicineRepo.getMedicineById(medId);
    expect(medAfterRevert?.medicine.availableQuantity, 30.0); // restored
    expect(medAfterRevert?.medicine.medicineTakenCount, 0); // decremented
  });
}
