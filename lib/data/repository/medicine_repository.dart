import 'dart:developer';

import 'package:isar/isar.dart';
import 'package:medicine_app/data/source/local_db_source.dart';
import 'package:medicine_app/data/source/my_shared_pref.dart';
import 'package:medicine_app/models/medicine_draft_log_model.dart';
import 'package:medicine_app/models/medicine_model.dart';
import 'package:medicine_app/service/draft_file_service.dart';

class MedicineRepository {
  final LocalDatabaseService db;

  MedicineRepository(this.db);

  Future<int> insertMedicine(MedicineModel medicineData) async {
    try {
      final rowId = await db.isar.writeTxn(() async {
        return await db.isar.medicineModels.put(medicineData);
      });

      final insertedMedicine = medicineData.copyWith(id: rowId);
      // also save the time schedule for alarm to the shared pref
      final draftLogs = MedicineDraftLog.fromMedicineModels(insertedMedicine);
      await DraftFileService.addLog(draftLogs);

      return rowId;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<MedicineModel>> getAllMedicines() async {
    try {
      return await db.isar.medicineModels.where().findAll();
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<void> updateMedicine(MedicineModel medicineData) async {
    try {
      await db.isar.writeTxn(() async {
        await db.isar.medicineModels.put(medicineData);
      });

      await DraftFileService.clearLogsByMedicineId(medicineData.id!);
      await DraftFileService.addLog(
        MedicineDraftLog.fromMedicineModels(medicineData),
      );
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<void> clearSpecificMedicine(int id) async {
    try {
      // specify the id of the medicine to clear
      await db.isar.writeTxn(() async {
        await db.isar.medicineModels.delete(id);
      });

      // also clear the draft logs related to this medicine
      await DraftFileService.clearLogsByMedicineId(id);
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  // get medicine by id
  Future<MedicineModel?> getSpecificMedicine(int id) async {
    try {
      return await db.isar.medicineModels.get(id);
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
