import 'dart:developer';

import 'package:isar/isar.dart';
import 'package:medicine_app/app/data/source/db_service_isar.dart';
import 'package:medicine_app/models/medicine_model.dart';

class MedicineRepository {
  final LocalDatabaseService localDatabaseService;

  MedicineRepository(this.localDatabaseService);

  Future<void> insertMedicine(MedicineModel medicineData) async {
    try {
      final db = Isar.getInstance();
      log('Isar instance: $db');
      if (db != null) {
        db.writeTxn(() {
          return db.medicineModels.put(medicineData);
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<MedicineModel>> getAllMedicines() async {
    try {
      final db = Isar.getInstance();
      log('Isar instance: $db');
      if (db != null) {
        return await db.medicineModels.where().findAll();
      }

      return [];
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
