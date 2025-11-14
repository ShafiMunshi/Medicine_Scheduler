import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medicine_app/data/repository/medicine_repository.dart';
import 'package:medicine_app/models/medicine_model.dart';
import 'package:medicine_app/service/notification_service.dart';

class MedicineViewmodels extends ChangeNotifier {
  final MedicineRepository medicineRepository;

  MedicineViewmodels(this.medicineRepository);

  bool isLoading = false;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  List<MedicineModel> _medicines = [];

  List<MedicineModel> get medicines => _medicines;

  List<MedicineModel> _todaysMedicines = [];

  List<MedicineModel> get todaysMedicines => _todaysMedicines;

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
      await NotificationService
          .reschedule_all_medicine_notification_for_next_48_hours();
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
      await get_all_medicine();

      await NotificationService
          .reschedule_all_medicine_notification_for_next_48_hours(); // Only after success
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

      await NotificationService
          .reschedule_all_medicine_notification_for_next_48_hours();
    } catch (e) {
      log("error: $e");
      _errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> get_todays_medicine() async {
    try {
      if (medicines.isEmpty) {
        await get_all_medicine();
      }
      isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);

      _todaysMedicines = medicines.where((medicine) {
        return medicine.finalScheduleDates?.any((date) {
              final d = DateTime(date.year, date.month, date.day);
              return d == todayDate;
            }) ??
            false;
      }).toList();
    } catch (e) {
      log("Error: $e");
      _errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<MedicineModel?> get_medicine_by_id(int id) async {
    try {
      return await medicineRepository.getSpecificMedicine(id);
    } catch (e) {
      log("Error: $e");
      throw Exception(e);
    }
  }
}
