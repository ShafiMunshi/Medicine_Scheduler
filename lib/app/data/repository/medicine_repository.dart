import 'dart:developer';

import 'package:isar/isar.dart';
import 'package:medicine_app/app/data/source/db_service_isar.dart';
import 'package:medicine_app/app/data/source/my_shared_pref.dart';
import 'package:medicine_app/models/medicine_model.dart';

class MedicineRepository {
  final LocalDatabaseService db;

  MedicineRepository(this.db);

  Future<int> insertMedicine(MedicineModel medicineData) async {
    try {
      // also save the time schedule for alarm to the shared pref
      MySharedPref.setTimeList(
          'time_list', medicineData.scheduleTimes.values.toList());

      db.isar.writeTxn(() {
        return db.isar.medicineModels.put(medicineData);
      });

      return -1;
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
