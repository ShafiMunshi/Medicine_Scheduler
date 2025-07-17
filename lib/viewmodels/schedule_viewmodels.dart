import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medicine_app/data/repository/consume_repository.dart';
import 'package:medicine_app/models/medicine_consumption_model.dart';

class ScheduleViewmodels extends ChangeNotifier {
  final MedicineConsumeRepository consumeRepository;

  ScheduleViewmodels(this.consumeRepository);

  bool isLoading = false;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  List<MedicineConsumeLogModel> _medicinesConsume = [];

  List<MedicineConsumeLogModel> get medicinesConsume => _medicinesConsume;

  Future<void> get_all_medicine_consume_data() async {
    isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _medicinesConsume = await consumeRepository.getAllMedicineConsumedData();
      log("Length: ${_medicinesConsume.length}");
    } catch (e) {
      log("error: $e");
      _errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<MedicineConsumeLogModel>? get_todays_medicine_consume_data_list(
      int medicineId) {
    try {
      return _medicinesConsume.where((consume) {
        final now = DateTime.now();
        return medicineId == consume.medicineId &&
            consume.actualTakenTime?.year == now.year &&
            consume.actualTakenTime?.month == now.month &&
            consume.actualTakenTime?.day == now.day;
      }).toList();
    } catch (e) {
      log("error: $e");
      _errorMessage = e.toString();
    }
  }

  Future<void> update_medicine_consume_data(
      int medicineId, MedicineConsumeLogModel consumeModel) async {
    isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await consumeRepository.updateMedicineConsumeData(consumeModel);
      await get_all_medicine_consume_data(); // Only after success
    } catch (e) {
      log("error: $e");
      _errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
