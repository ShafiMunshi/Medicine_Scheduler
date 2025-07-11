import 'package:flutter/material.dart';
import 'package:medicine_app/app/data/repository/medicine_repository.dart';
import 'package:medicine_app/app/data/source/my_shared_pref.dart';
import 'package:medicine_app/models/medicine_model.dart';

class MedicineViewmodels extends ChangeNotifier {
  final MedicineRepository medicineRepository;

  MedicineViewmodels(this.medicineRepository);

  bool isLoading = false;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  List<MedicineModel> _medicines = [];

  List<MedicineModel> get medicines => _medicines;

  Future<void> add_medicine(MedicineModel medicine) async {
    isLoading = true;
    notifyListeners();

    try {
      final row = await medicineRepository.insertMedicine(medicine);

      if (row != -1) {
        throw 'Something went wrong to save the medicine.';
      }
    } catch (e) {
      _errorMessage = e.toString();
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> get_all_medicine() async {
    isLoading = true;
    notifyListeners();

    try {
      final medi = await medicineRepository.getAllMedicines();
      print("length: ${medi?.length}");

      if (medi != null) {
        print(medi);
        _medicines = medi;
      }
    } catch (e) {
      print("error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
