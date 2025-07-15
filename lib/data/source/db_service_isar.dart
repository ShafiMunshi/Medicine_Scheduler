import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:medicine_app/models/medicine_model.dart';
import 'package:path_provider/path_provider.dart';

class LocalDatabaseService extends ChangeNotifier {
  late Isar isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [
        MedicineModelSchema,
      ],
      directory: dir.path,
    );

    notifyListeners();
  }

  Future<void> clearAll() async {
    final isar = Isar.getInstance();
    isar?.writeTxn(() {
      return isar.medicineModels.clear();
    });
  }
}
