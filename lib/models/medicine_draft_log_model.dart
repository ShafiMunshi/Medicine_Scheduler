import 'package:medicine_app/models/medicine_consumption_model.dart';
import 'package:medicine_app/models/medicine_model.dart';
import 'package:medicine_app/widgets/common/common_fn.dart';

class MedicineDraftLog {
  final int medicineId;
  final DateTime
      scheduledDateTime; // Scheduled time for the medicine which is specified in the medicine model
  final DateTime?
      actualTakenTime; // Actual time when the medicine was taken, can be null if not taken yet
  final ConsumptionStatus? status;
  final int? dosage;

  MedicineDraftLog({
    required this.medicineId,
    required this.scheduledDateTime,
    this.status,
    this.actualTakenTime,
    this.dosage,
  });

  Map<String, dynamic> toJson() => {
        'medicineId': medicineId,
        'scheduledDateTime': scheduledDateTime.toIso8601String(),
        'actualTakenTime': actualTakenTime?.toIso8601String(),
        'status': status?.name,
        'dosage': dosage,
      };

  /// Converts the MedicineDraftLog to a payload map for notifications
  /// This is used to pass data when scheduling notifications
  Map<String, String>? toPayload() => {
        'medicineId': medicineId.toString(),
        'scheduledDateTime': scheduledDateTime.toIso8601String(),
        'actualTakenTime': actualTakenTime?.toIso8601String() ?? '',
        'status': status?.name ?? '',
        'dosage': dosage.toString(),
      };

  static MedicineDraftLog fromJson(Map<String, dynamic> json) =>
      MedicineDraftLog(
        medicineId: json['medicineId'],
        scheduledDateTime: DateTime.parse(json['scheduledDateTime']),
        actualTakenTime: json['actualTakenTime'] != null
            ? DateTime.parse(json['actualTakenTime'])
            : null,
        status: json['status'] != null
            ? ConsumptionStatus.values.firstWhere(
                (e) => e.name == json['status'],
                orElse: () => ConsumptionStatus
                    .skipped, // Handle unknown status gracefully
              )
            : null,
        dosage: json['dosage'],
      );

  /// Converts a MedicineModel to a list of MedicineDraftLog
  static List<MedicineDraftLog> fromMedicineModels(MedicineModel medicine) {
    List<MedicineDraftLog> logs = [];

    final scheduleTimeList = medicine.medicineScheduleList
        ?.map((e) => stringToTimeOfDay(e.timeString))
        .toList();

    final now = DateTime.now();

    medicine.finalScheduleDates?.forEach((date) {
      scheduleTimeList?.forEach((time) {
        logs.add(MedicineDraftLog(
          medicineId: medicine.id!,
          scheduledDateTime: DateTime(
            date.year,
            date.month,
            date.day,
            time?.hour ?? now.hour, // TODO: Handle null time maybe cause error
            time?.minute ?? now.minute,
          ),
          status: null,
          actualTakenTime: null,
          dosage: medicine.dosage,
        ));
      });
    });

    return logs;
  }

  MedicineDraftLog copyWith({
    int? medicineId,
    DateTime? scheduledDateTime,
    DateTime? actualTakenTime,
    ConsumptionStatus? status,
    int? dosage,
  }) {
    return MedicineDraftLog(
      medicineId: medicineId ?? this.medicineId,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      actualTakenTime: actualTakenTime ?? this.actualTakenTime,
      status: status ?? this.status,
      dosage: dosage ?? this.dosage,
    );
  }
}
