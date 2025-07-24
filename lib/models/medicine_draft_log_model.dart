import 'package:medicine_app/models/medicine_consumption_model.dart';

class MedicineDraftLog {
  final int medicineId;
  final DateTime
      scheduledDateTime; // Scheduled time for the medicine which is specified in the medicine model
  final DateTime?
      actualTakenTime; // Actual time when the medicine was taken, can be null if not taken yet
  final ConsumptionStatus status;
  final int? dosageTaken;

  MedicineDraftLog({
    required this.medicineId,
    required this.scheduledDateTime,
    required this.status,
    this.actualTakenTime,
    this.dosageTaken,
  });

  Map<String, dynamic> toJson() => {
        'medicineId': medicineId,
        'scheduledDateTime': scheduledDateTime.toIso8601String(),
        'actualTakenTime': actualTakenTime?.toIso8601String(),
        'status': status.name,
        'dosageTaken': dosageTaken,
      };

  /// Converts the MedicineDraftLog to a payload map for notifications
  /// This is used to pass data when scheduling notifications
  Map<String, String>? toPayload() => {
        'medicineId': medicineId.toString(),
        'scheduledDateTime': scheduledDateTime.toIso8601String(),
        'actualTakenTime': actualTakenTime?.toIso8601String() ?? '',
        'status': status.name,
        'dosageTaken': dosageTaken.toString(),
      };

  static MedicineDraftLog fromJson(Map<String, dynamic> json) =>
      MedicineDraftLog(
        medicineId: json['medicineId'],
        scheduledDateTime: DateTime.parse(json['scheduledDateTime']),
        actualTakenTime: json['actualTakenTime'] != null
            ? DateTime.parse(json['actualTakenTime'])
            : null,
        status: ConsumptionStatus.values.byName(json['status']),
        dosageTaken: json['dosageTaken'],
      );
}
