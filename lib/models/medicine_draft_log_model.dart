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
  final String medicineName; 
  final bool isSynced; 

  MedicineDraftLog({
    required this.medicineId,
    required this.scheduledDateTime,
    required this.medicineName,
   required this.isSynced ,
    this.status,
    this.actualTakenTime,
    this.dosage,
  });

  Map<String, dynamic> toJson() => {
        'medicineName': medicineName,
        'medicineId': medicineId,
        'scheduledDateTime': scheduledDateTime.toIso8601String(),
        'actualTakenTime': actualTakenTime?.toIso8601String(),
        'status': status?.name,
        'dosage': dosage,
        'isSynced': isSynced
      };

  /// Converts the MedicineDraftLog to a payload map for notifications
  /// This is used to pass data when scheduling notifications
  Map<String, String>? toPayload() => {
        'medicineName': medicineName,
        'medicineId': medicineId.toString(),
        'scheduledDateTime': scheduledDateTime.toIso8601String(),
        'actualTakenTime': actualTakenTime?.toIso8601String() ?? '',
        'status': status?.name ?? '',
        'dosage': dosage.toString(),
        'isSynced': isSynced.toString()
      };

  static MedicineDraftLog fromJson(Map<String, dynamic> json) =>
      MedicineDraftLog(
        medicineName: json['medicineName'] ?? '',
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
        isSynced: json['isSynced'],
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
          medicineName: medicine.medicineName,
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
          isSynced: false
        ));
      });
    });

    return logs;
  }

  MedicineDraftLog copyWith({
    String? medicineName,
    int? medicineId,
    DateTime? scheduledDateTime,
    DateTime? actualTakenTime,
    ConsumptionStatus? status,
    int? dosage,
    bool? isSynced
  }) {
    return MedicineDraftLog(
      medicineName: medicineName ?? this.medicineName,
      medicineId: medicineId ?? this.medicineId,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      actualTakenTime: actualTakenTime ?? this.actualTakenTime,
      status: status ?? this.status,
      dosage: dosage ?? this.dosage,
      isSynced: isSynced ?? this.isSynced

    );
  }
}
