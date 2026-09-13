import 'dart:async';
import 'package:drift/drift.dart';
import 'package:medicine_app/data/database/app_database.dart';

abstract class MedicineRepository {
  Stream<List<MedicineWithSchedules>> watchAllMedicines();
  Future<List<MedicineWithSchedules>> getAllMedicines();
  Future<MedicineWithSchedules?> getMedicineById(int id);
  Future<int> insertMedicine({
    required MedicinesCompanion medicine,
    required List<MedicineSchedulesCompanion> schedules,
  });
  Future<void> updateMedicine({
    required MedicinesCompanion medicine,
    required List<MedicineSchedulesCompanion> schedules,
  });
  Future<void> updateMedicineStock({
    required int medicineId,
    required double availableQuantity,
  });
  Future<void> deleteMedicine(int id);
}

class DriftMedicineRepository implements MedicineRepository {
  final AppDatabase db;

  DriftMedicineRepository(this.db);

  @override
  Stream<List<MedicineWithSchedules>> watchAllMedicines() {
    final medicinesStream = db.select(db.medicines).watch();
    final schedulesStream = db.select(db.medicineSchedules).watch();

    return medicinesStream.switchMap((medicinesList) {
      return schedulesStream.map((allSchedules) {
        return medicinesList.map((med) {
          final medSchedules = allSchedules
              .where((s) => s.medicineId == med.id)
              .toList()
            ..sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));

          return MedicineWithSchedules(
            medicine: med,
            schedules: medSchedules,
          );
        }).toList();
      });
    });
  }

  @override
  Future<List<MedicineWithSchedules>> getAllMedicines() async {
    final allMeds = await db.select(db.medicines).get();
    final allSchedules = await db.select(db.medicineSchedules).get();

    return allMeds.map((med) {
      final medSchedules = allSchedules
          .where((s) => s.medicineId == med.id)
          .toList()
        ..sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));

      return MedicineWithSchedules(
        medicine: med,
        schedules: medSchedules,
      );
    }).toList();
  }

  @override
  Future<MedicineWithSchedules?> getMedicineById(int id) async {
    final med = await (db.select(db.medicines)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (med == null) return null;

    final schedules = await (db.select(db.medicineSchedules)
          ..where((tbl) => tbl.medicineId.equals(id)))
        .get();

    schedules.sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));

    return MedicineWithSchedules(
      medicine: med,
      schedules: schedules,
    );
  }

  @override
  Future<int> insertMedicine({
    required MedicinesCompanion medicine,
    required List<MedicineSchedulesCompanion> schedules,
  }) async {
    return db.transaction(() async {
      final medicineId = await db.into(db.medicines).insert(medicine);

      for (final schedule in schedules) {
        await db.into(db.medicineSchedules).insert(
              schedule.copyWith(medicineId: Value(medicineId)),
            );
      }
      return medicineId;
    });
  }

  @override
  Future<void> updateMedicine({
    required MedicinesCompanion medicine,
    required List<MedicineSchedulesCompanion> schedules,
  }) async {
    await db.transaction(() async {
      await db.update(db.medicines).replace(medicine);

      final medId = medicine.id.value;
      // Delete old schedules and insert new ones
      await (db.delete(db.medicineSchedules)..where((tbl) => tbl.medicineId.equals(medId))).go();

      for (final schedule in schedules) {
        await db.into(db.medicineSchedules).insert(
              schedule.copyWith(medicineId: Value(medId)),
            );
      }
    });
  }

  @override
  Future<void> updateMedicineStock({
    required int medicineId,
    required double availableQuantity,
  }) async {
    await (db.update(db.medicines)..where((tbl) => tbl.id.equals(medicineId))).write(
      MedicinesCompanion(
        availableQuantity: Value(availableQuantity),
        modifiedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> deleteMedicine(int id) async {
    await (db.delete(db.medicines)..where((tbl) => tbl.id.equals(id))).go();
  }
}

extension _StreamSwitchMap<T> on Stream<T> {
  Stream<R> switchMap<R>(Stream<R> Function(T) mapper) {
    StreamController<R>? controller;
    StreamSubscription<T>? upstreamSub;
    StreamSubscription<R>? currentInnerSub;

    controller = StreamController<R>(
      onListen: () {
        upstreamSub = listen(
          (data) {
            currentInnerSub?.cancel();
            currentInnerSub = mapper(data).listen(
              (innerData) => controller?.add(innerData),
              onError: (e, s) => controller?.addError(e, s),
            );
          },
          onError: (e, s) => controller?.addError(e, s),
          onDone: () => controller?.close(),
        );
      },
      onCancel: () async {
        await currentInnerSub?.cancel();
        await upstreamSub?.cancel();
      },
    );

    return controller.stream;
  }
}
