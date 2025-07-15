import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medicine_app/app/data/repository/medicine_repository.dart';
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
    _errorMessage = null;
    notifyListeners();

    try {
      final row = await medicineRepository.insertMedicine(medicine);
      log("inserted row num: $row");
      if (row == -1) {
        throw 'Something went wrong while saving the medicine.';
      }

      await get_all_medicine(); // only call this if insertion succeeded
    } catch (e) {
      _errorMessage = e.toString();
      log("add_medicine error:$e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> get_all_medicine() async {
    isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _medicines = await medicineRepository.getAllMedicines();
      log("Length: ${_medicines.length}");
    } catch (e) {
      log("error: $e");
      _errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> update_medicine(MedicineModel medicine) async {
    isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await medicineRepository.updateMedicine(medicine);
      await get_all_medicine(); // Only after success
    } catch (e) {
      log("error: $e");
      _errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> delete_medicine(int id) async {
    isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await medicineRepository.clearSpecificMedicine(id).whenComplete(() async {
        await get_all_medicine();
      });
    } catch (e) {
      log("error: $e");
      _errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
