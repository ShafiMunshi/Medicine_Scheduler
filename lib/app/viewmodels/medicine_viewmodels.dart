import 'package:flutter/material.dart';
import 'package:medicine_app/app/data/repository/medicine_repository.dart';
import 'package:medicine_app/app/data/source/my_shared_pref.dart';
import 'package:medicine_app/models/medicine_model.dart';

class MedicineViewmodels extends ChangeNotifier {
  final MedicineRepository medicineRepository;

  MedicineViewmodels(this.medicineRepository);

  bool isLoading = false;

  List<MedicineModel> _medicines = [];

  List<MedicineModel> get medicines => _medicines;

  Future<void> add_medicine(MedicineModel medicine) async {
    isLoading = true;
    notifyListeners();

    try {
      final row = await medicineRepository.insertMedicine(medicine);

      // also save the time schedule for alarm to the shared pref
      MySharedPref.setTimeList(
          'time_list', medicine.scheduleTimes.values.toList());

      // get_all_medicine();
    } catch (e) {
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
