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

  


}
