import 'package:flutter/material.dart';
import 'package:medicine_app/models/medicine_models.dart';

class MedicineViewmodels extends ChangeNotifier {
  bool isLoading = false;

  void add_medicine(MedicineModels medicine) {
    isLoading = true;
    notifyListeners();

    
  }
}
