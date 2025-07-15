import 'dart:developer';

import 'package:isar/isar.dart';
import 'package:medicine_app/data/source/db_service_isar.dart';
import 'package:medicine_app/data/source/my_shared_pref.dart';
import 'package:medicine_app/models/medicine_model.dart';

class MedicineRepository {
  final LocalDatabaseService db;

  MedicineRepository(this.db);

  Future<int> insertMedicine(MedicineModel medicineData) async {
    try {
      // also save the time schedule for alarm to the shared pref
      MySharedPref.setTimeList(
          'time_list', medicineData.scheduleTimes.values.toList());

      final rowId = await db.isar.writeTxn(() async {
        return await db.isar.medicineModels.put(medicineData);
      });

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
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
