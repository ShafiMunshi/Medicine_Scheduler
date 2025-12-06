import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medicine_app/data/repository/consume_repository.dart';
import 'package:medicine_app/data/repository/medicine_repository.dart';
import 'package:medicine_app/models/medicine_consumption_model.dart';
import 'package:medicine_app/models/medicine_model.dart';

class ScheduleViewmodels extends ChangeNotifier {
  final MedicineConsumeRepository consumeRepository;
  final MedicineRepository medicineRepository;

  ScheduleViewmodels(this.consumeRepository, this.medicineRepository);

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
      log("Length: ${_medicinesConsume}");
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

  Future<void> update_medicine_consume_data(int medicineId,
      MedicineConsumeLogModel consumeModel, MedicineModel medicineModel) async {
    isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await consumeRepository.updateMedicineConsumeData(
        consumeModel,
      );
      final updatedMedicine = medicineModel.copyWith(
        modifiedAt: DateTime.now(),
        availableQuantity: medicineModel.availableQuantity - 1,
        medicineTakenCount: medicineModel.medicineTakenCount + 1,
      );
      await medicineRepository.updateMedicine(updatedMedicine);
      await get_all_medicine_consume_data();
      // await NotificationService
      //     .reschedule_all_medicine_notification_for_next_48_hours();
    } catch (e) {
      log("error: $e");
      _errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> revert_updated_medicine_consume_data(int medicineId,
      MedicineConsumeLogModel consumeModel, MedicineModel medicineModel) async {
    isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await consumeRepository.clearSpecificMedicineConsume(
        consumeModel,
      );
      final updatedMedicine = medicineModel.copyWith(
        modifiedAt: DateTime.now(),
        availableQuantity: medicineModel.availableQuantity + 1,
        medicineTakenCount: medicineModel.medicineTakenCount - 1,
      );
      await medicineRepository.updateMedicine(updatedMedicine);
      await get_all_medicine_consume_data(); // Only after success
      // TODO: Do something for below this line
      // await NotificationService
      //     .reschedule_all_medicine_notification_for_next_48_hours();
    } catch (e) {
      log("error: $e");
      _errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<MedicineConsumeLogModel>> get_specific_medicine_consume_data(
      int medicineId) async {
    try {
      return await consumeRepository.getSpecificMedicineConsumeData(medicineId);
    } catch (e) {
      log("error: $e");
      _errorMessage = e.toString();
      throw Exception('Failed to get specific medicine consume data $e');
    }
  }
}
