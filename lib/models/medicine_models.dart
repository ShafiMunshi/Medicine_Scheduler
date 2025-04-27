// ignore_for_file: public_member_api_docs, sort_constructors_first
class MedicineModels {
  String name;
  String medicinePhotoUrl;
  String form;
  int availableMedicine;
  bool isBeforeMeal;
  Map<String, DateTime> dayTime;
  DateTime endDate;
  DateTime startDate;
  int repeatDay;
  int scheduleType;
  MedicineModels({
    required this.name,
    required this.medicinePhotoUrl,
    required this.form,
    required this.availableMedicine,
    required this.isBeforeMeal,
    required this.dayTime,
    required this.endDate,
    required this.startDate,
    required this.repeatDay,
    required this.scheduleType,
  });
}
