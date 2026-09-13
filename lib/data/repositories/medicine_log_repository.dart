import 'package:drift/drift.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/models/domain_models.dart';

abstract class MedicineLogRepository {
  Stream<List<MedicineLog>> watchTodayLogs();
  Future<List<MedicineLog>> getLogsForDate(DateTime date);
  Future<List<MedicineLog>> getAllLogs();
  Future<List<MedicineLog>> getLogsForMedicine(int medicineId);
  Future<void> markDose({
    required int medicineId,
    int? scheduleId,
    required DateTime scheduledDateTime,
    required ConsumptionStatus status,
    int? dosageTaken,
  });
  Future<void> revertDose({
    required int medicineId,
    required DateTime scheduledDateTime,
  });
  Future<void> clearAllLogs();
}

class DriftMedicineLogRepository implements MedicineLogRepository {
  final AppDatabase db;

  DriftMedicineLogRepository(this.db);

  @override
  Stream<List<MedicineLog>> watchTodayLogs() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    return (db.select(db.medicineLogs)
          ..where((tbl) =>
              tbl.scheduledDateTime.isBiggerOrEqualValue(startOfDay) &
              tbl.scheduledDateTime.isSmallerOrEqualValue(endOfDay)))
        .watch();
  }

  @override
  Future<List<MedicineLog>> getLogsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    return (db.select(db.medicineLogs)
          ..where((tbl) =>
              tbl.scheduledDateTime.isBiggerOrEqualValue(startOfDay) &
              tbl.scheduledDateTime.isSmallerOrEqualValue(endOfDay)))
        .get();
  }

  @override
  Future<List<MedicineLog>> getAllLogs() async {
    return (db.select(db.medicineLogs)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.scheduledDateTime)]))
        .get();
  }

  @override
  Future<List<MedicineLog>> getLogsForMedicine(int medicineId) async {
    return (db.select(db.medicineLogs)
          ..where((tbl) => tbl.medicineId.equals(medicineId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.scheduledDateTime)]))
        .get();
  }

  @override
  Future<void> markDose({
    required int medicineId,
    int? scheduleId,
    required DateTime scheduledDateTime,
    required ConsumptionStatus status,
    int? dosageTaken,
  }) async {
    await db.transaction(() async {
      // Check if a log already exists for this exact scheduled time
      final existing = await (db.select(db.medicineLogs)
            ..where((tbl) =>
                tbl.medicineId.equals(medicineId) &
                tbl.scheduledDateTime.equals(scheduledDateTime)))
          .getSingleOrNull();

      final previousStatus = existing?.status;
      final now = DateTime.now();

      if (existing != null) {
        await (db.update(db.medicineLogs)..where((tbl) => tbl.id.equals(existing.id))).write(
          MedicineLogsCompanion(
            actualTakenTime: Value(status == ConsumptionStatus.taken ? now : null),
            status: Value(status.name),
            dosageTaken: Value(dosageTaken ?? existing.dosageTaken),
          ),
        );
      } else {
        await db.into(db.medicineLogs).insert(
              MedicineLogsCompanion(
                medicineId: Value(medicineId),
                scheduleId: Value(scheduleId),
                scheduledDateTime: Value(scheduledDateTime),
                actualTakenTime: Value(status == ConsumptionStatus.taken ? now : null),
                status: Value(status.name),
                dosageTaken: Value(dosageTaken ?? 1),
              ),
            );
      }

      // Update medicine inventory and taken count if transitioning to/from taken
      final med = await (db.select(db.medicines)..where((tbl) => tbl.id.equals(medicineId)))
          .getSingleOrNull();

      if (med != null) {
        int newAvailable = med.availableQuantity;
        int newTaken = med.medicineTakenCount;
        final dose = dosageTaken ?? med.dosage;

        if (status == ConsumptionStatus.taken && previousStatus != 'taken') {
          newAvailable = (med.availableQuantity - dose).clamp(0, 99999);
          newTaken = med.medicineTakenCount + 1;
        } else if (status != ConsumptionStatus.taken && previousStatus == 'taken') {
          newAvailable = med.availableQuantity + dose;
          newTaken = (med.medicineTakenCount - 1).clamp(0, 99999);
        }

        await (db.update(db.medicines)..where((tbl) => tbl.id.equals(medicineId))).write(
          MedicinesCompanion(
            availableQuantity: Value(newAvailable),
            medicineTakenCount: Value(newTaken),
            modifiedAt: Value(now),
          ),
        );
      }
    });
  }

  @override
  Future<void> revertDose({
    required int medicineId,
    required DateTime scheduledDateTime,
  }) async {
    await db.transaction(() async {
      final existing = await (db.select(db.medicineLogs)
            ..where((tbl) =>
                tbl.medicineId.equals(medicineId) &
                tbl.scheduledDateTime.equals(scheduledDateTime)))
          .getSingleOrNull();

      if (existing != null) {
        final wasTaken = existing.status == 'taken';
        await (db.delete(db.medicineLogs)..where((tbl) => tbl.id.equals(existing.id))).go();

        if (wasTaken) {
          final med = await (db.select(db.medicines)..where((tbl) => tbl.id.equals(medicineId)))
              .getSingleOrNull();

          if (med != null) {
            await (db.update(db.medicines)..where((tbl) => tbl.id.equals(medicineId))).write(
              MedicinesCompanion(
                availableQuantity: Value(med.availableQuantity + existing.dosageTaken),
                medicineTakenCount: Value((med.medicineTakenCount - 1).clamp(0, 99999)),
                modifiedAt: Value(DateTime.now()),
              ),
            );
          }
        }
      }
    });
  }

  @override
  Future<void> clearAllLogs() async {
    await db.delete(db.medicineLogs).go();
  }
}
