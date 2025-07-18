// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:isar/isar.dart';

part 'medicine_consumption_model.g.dart';

enum ConsumptionStatus {
  taken,
  skipped,
  missed, // Automatically marked if no activity past deadline
}

@collection
class MedicineConsumeLogModel {
  Id? id = Isar.autoIncrement;
  final int medicineId;
  final DateTime scheduledDateTime; // Date + Time combined
  final DateTime? actualTakenTime;
  @enumerated
  final ConsumptionStatus status;
  final int? dosageTaken;

  MedicineConsumeLogModel(
      {this.id,
      required this.medicineId,
      required this.scheduledDateTime,
      required this.actualTakenTime,
      required this.status,
      required this.dosageTaken});

  @override
  String toString() {
    return 'MedicineConsumeLogModel(id: $id, medicineId: $medicineId, scheduledDateTime: $scheduledDateTime, actualTakenTime: $actualTakenTime, status: $status, dosageTaken: $dosageTaken)\n';
  }

  MedicineConsumeLogModel copyWith({
    Id? id,
    int? medicineId,
    DateTime? scheduledDateTime,
    DateTime? actualTakenTime,
    ConsumptionStatus? status,
    int? dosageTaken,
  }) {
    return MedicineConsumeLogModel(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      actualTakenTime: actualTakenTime ?? this.actualTakenTime,
      status: status ?? this.status,
      dosageTaken: dosageTaken ?? this.dosageTaken,
    );
  }
}
