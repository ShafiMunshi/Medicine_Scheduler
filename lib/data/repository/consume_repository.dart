import 'dart:developer';

import 'package:isar/isar.dart';
import 'package:medicine_app/data/source/local_db_source.dart';
import 'package:medicine_app/models/medicine_consumption_model.dart';
import 'package:medicine_app/service/draft_file_service.dart';

class MedicineConsumeRepository {
  final LocalDatabaseService db;

  MedicineConsumeRepository(this.db);

  Future<int> insertMedicineConsume(
      MedicineConsumeLogModel medicineData) async {
    try {
      final rowId = await db.isar.writeTxn(() async {
        return await db.isar.medicineConsumeLogModels.put(medicineData);
      });

      return rowId;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<MedicineConsumeLogModel>> getAllMedicineConsumedData() async {
    try {
      return await db.isar.medicineConsumeLogModels.where().findAll();
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<void> updateMedicineConsumeData(
      MedicineConsumeLogModel consumeData) async {
    try {
      await db.isar.writeTxn(() async {
        await db.isar.medicineConsumeLogModels.put(consumeData);
      });

      await DraftFileService.updateLogByMedicineId(
          isSynced: true,
          medicineId: consumeData.medicineId,
          scheduledDateTime: consumeData.scheduledDateTime,
          isTaken: consumeData.status == ConsumptionStatus.taken);
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<void> clearSpecificMedicineConsume(
      MedicineConsumeLogModel consumeData) async {
    try {
      // specify the id of the medicine to clear
      await db.isar.writeTxn(() async {
        await db.isar.medicineConsumeLogModels.delete(consumeData.id!);
      });

      await DraftFileService.updateLogByMedicineId(
          isSynced: false,
          medicineId: consumeData.medicineId,
          scheduledDateTime: consumeData.scheduledDateTime,
          isTaken: consumeData.status == ConsumptionStatus.taken);
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<void> clearAllMedicineConsumeLogs() async {
    try {
      await db.isar.writeTxn(() async {
        await db.isar.medicineConsumeLogModels.clear();
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
