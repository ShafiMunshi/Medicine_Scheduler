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

  test('upsertMedicine inserts new medicine if absent, and updates if already present', () async {
    final now = DateTime.now();

    final newMed = MedicinesCompanion.insert(
      medicineName: 'Amoxicillin',
      dosage: const Value(1.0),
      dosageUnit: 'pcs',
      availableQuantity: const Value(10.0),
      mealTiming: 'after',
      repeatVariation: 'day',
      startDate: now,
      endDate: now.add(const Duration(days: 7)),
      createdAt: now,
      modifiedAt: now,
    );

    final schedule1 = [
      MedicineSchedulesCompanion.insert(
        dayTimeName: 'Morning',
        timeString: '08:00',
        hour: 8,
        minute: 0,
        medicineId: 0,
      ),
    ];

    // 1. First upsert should insert
    final id1 = await medicineRepo.upsertMedicine(medicine: newMed, schedules: schedule1);
    expect(id1 > 0, isTrue);

    var allMeds = await medicineRepo.getAllMedicines();
    expect(allMeds.length, 1);
    expect(allMeds.first.medicine.medicineName, 'Amoxicillin');
    expect(allMeds.first.medicine.availableQuantity, 10.0);
    expect(allMeds.first.schedules.length, 1);

    // 2. Second upsert with updated quantity & 2 schedules should update existing record, not duplicate
    final updatedMed = MedicinesCompanion.insert(
      medicineName: 'Amoxicillin',
      dosage: const Value(2.0),
      dosageUnit: 'pcs',
      availableQuantity: const Value(20.0),
      mealTiming: 'after',
      repeatVariation: 'day',
      startDate: now,
      endDate: now.add(const Duration(days: 7)),
      createdAt: now,
      modifiedAt: now,
    );

    final schedule2 = [
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

    final id2 = await medicineRepo.upsertMedicine(medicine: updatedMed, schedules: schedule2);
    expect(id2, id1);

    allMeds = await medicineRepo.getAllMedicines();
    expect(allMeds.length, 1); // Still 1 medicine!
    expect(allMeds.first.medicine.availableQuantity, 20.0); // Updated!
    expect(allMeds.first.medicine.dosage, 2.0); // Updated!
    expect(allMeds.first.schedules.length, 2); // Schedules replaced!
  });

  test('clearAllData erases all rows across medicines, schedules, logs, and users tables', () async {
    final now = DateTime.now();

    // 1. Insert medicine and schedule
    final medId = await medicineRepo.insertMedicine(
      medicine: MedicinesCompanion.insert(
        medicineName: 'Aspirin',
        dosageUnit: 'pcs',
        mealTiming: 'after',
        repeatVariation: 'day',
        startDate: now,
        endDate: now.add(const Duration(days: 5)),
        createdAt: now,
        modifiedAt: now,
      ),
      schedules: [
        MedicineSchedulesCompanion.insert(
          dayTimeName: 'Morning',
          timeString: '08:00',
          hour: 8,
          minute: 0,
          medicineId: 0,
        ),
      ],
    );

    // 2. Insert log
    await logRepo.markDose(
      medicineId: medId,
      scheduledDateTime: now,
      status: ConsumptionStatus.taken,
      dosageTaken: 1.0,
    );

    // 3. Insert user
    await db.into(db.users).insert(
      UsersCompanion.insert(
        name: 'Test Patient',
        role: const Value('patient'),
      ),
    );

    // Verify data exists
    expect((await db.select(db.medicines).get()).length, 1);
    expect((await db.select(db.medicineSchedules).get()).length, 1);
    expect((await db.select(db.medicineLogs).get()).length, 1);
    expect((await db.select(db.users).get()).length, 1);

    // 4. Erase all data
    await db.clearAllData();

    // Verify all tables are empty
    expect((await db.select(db.medicines).get()).isEmpty, isTrue);
    expect((await db.select(db.medicineSchedules).get()).isEmpty, isTrue);
    expect((await db.select(db.medicineLogs).get()).isEmpty, isTrue);
    expect((await db.select(db.users).get()).isEmpty, isTrue);
  });
}


