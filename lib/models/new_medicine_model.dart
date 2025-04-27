import 'dart:convert';
import 'package:flutter/material.dart'; // Needed for TimeOfDay
import 'package:uuid/uuid.dart'; // Recommended for unique IDs

class MedicineModel {
  final String id; // Use final for immutable fields after creation
  final String medicineName;
  final int dosage;
  final String dosageUnit; // Consider using an Enum for 'Pcs', 'Cup', etc.
  final int availableQuantity;
  final String mealTiming; // Consider using an Enum for 'Before', 'After'
  final Map<String, dynamic> repeatSchedule;
  final Map<String, String>
      scheduleTimes; // Stores time label and time as 'HH:mm'
  final DateTime startDate;
  final DateTime? endDate;
  final String? imagePath; // Local path to the captured image
  final DateTime createdAt;
  final DateTime modifiedAt;

  // Private constructor for internal use by factories
  MedicineModel._({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.dosageUnit,
    required this.availableQuantity,
    required this.mealTiming,
    required this.repeatSchedule,
    required this.scheduleTimes,
    required this.startDate,
    this.endDate,
    this.imagePath,
    required this.createdAt,
    required this.modifiedAt,
  });

  // --- Factory for creating NEW instances ---
  factory MedicineModel.create({
    required String medicineName,
    required int dosage,
    required String dosageUnit,
    required int availableQuantity,
    required String mealTiming,
    required Map<String, dynamic> repeatSchedule,
    required Map<String, TimeOfDay> scheduleTime, // Accept TimeOfDay map
    required DateTime startDate,
    DateTime? endDate,
    String? imagePath,
  }) {
    const uuid = Uuid();
    final now = DateTime.now();

    // Convert TimeOfDay map to Map<String, String> for storage
    final serializableScheduleTimes = scheduleTime.map(
      (key, value) =>
          MapEntry(key, timeOfDayToString(value)), // Use public helper
    );

    return MedicineModel._(
      id: uuid.v4(), // Generate a unique ID
      medicineName: medicineName,
      dosage: dosage,
      dosageUnit: dosageUnit,
      availableQuantity: availableQuantity,
      mealTiming: mealTiming,
      repeatSchedule: repeatSchedule,
      scheduleTimes: serializableScheduleTimes,
      startDate: startDate,
      endDate: endDate,
      imagePath: imagePath,
      createdAt: now, // Set creation time
      modifiedAt: now, // Set modification time initially same as creation
    );
  }

  // --- Factory for creating instances from storage data (Map) ---
  factory MedicineModel.fromMap(Map<String, dynamic> map) {
    // Basic validation (add more as needed)
    if (map['id'] == null ||
        map['medicineName'] == null ||
        map['dosage'] == null /* ... etc */) {
      throw FormatException(
          "Missing required fields in MedicineModel map: $map");
    }

    return MedicineModel._(
      id: map['id'] as String,
      medicineName: map['medicineName'] as String,
      dosage: map['dosage'] as int,
      dosageUnit: map['dosageUnit'] as String,
      availableQuantity: map['availableQuantity'] as int,
      mealTiming: map['mealTiming'] as String,
      repeatSchedule: Map<String, dynamic>.from(
          map['repeatSchedule'] as Map? ?? {}), // Handle potential null map
      scheduleTimes: Map<String, String>.from(
          map['scheduleTimes'] as Map? ?? {}), // Handle potential null map
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int)
          : null,
      imagePath: map['imagePath'] as String?, // Allow null directly
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      modifiedAt: DateTime.fromMillisecondsSinceEpoch(map['modifiedAt'] as int),
    );
  }

  // --- Factory for creating instances from storage data (JSON String) ---
  factory MedicineModel.fromJson(String source) {
    try {
      final map = json.decode(source) as Map<String, dynamic>;
      return MedicineModel.fromMap(map);
    } catch (e) {
      print("Error decoding MedicineModel from JSON: $e");
      // Depending on your error handling strategy, you might rethrow,
      // return a default object, or throw a specific exception type.
      throw FormatException(
          "Invalid JSON format for MedicineModel: $source", e);
    }
  }

  // --- Serialization Method ---
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'medicineName': medicineName,
      'dosage': dosage,
      'dosageUnit': dosageUnit,
      'availableQuantity': availableQuantity,
      'mealTiming': mealTiming,
      'repeatSchedule': repeatSchedule,
      'scheduleTimes': scheduleTimes,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'imagePath': imagePath,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'modifiedAt': modifiedAt.millisecondsSinceEpoch,
    };
  }

  String toJson() => json.encode(toMap());

  // --- Helper method to get TimeOfDay back ---
  Map<String, TimeOfDay?> getScheduleTimesAsTimeOfDay() {
    return scheduleTimes.map((key, value) {
      final timeOfDay = stringToTimeOfDay(value); // Use public helper
      // Optionally handle the null case if stringToTimeOfDay fails
      // if (timeOfDay == null) {
      //   print("Warning: Could not parse stored time '$value' for key '$key'");
      // }
      return MapEntry(key, timeOfDay);
    });
  }

  // --- CopyWith method for easy updates (optional but recommended) ---
  MedicineModel copyWith({
    String? id,
    String? medicineName,
    int? dosage,
    String? dosageUnit,
    int? availableQuantity,
    String? mealTiming,
    Map<String, dynamic>? repeatSchedule,
    Map<String, String>? scheduleTimes, // Note: Pass the string map if copying
    DateTime? startDate,
    DateTime? endDate, // Use ValueGetter trick for nullable fields if needed
    String? imagePath, // Use ValueGetter trick for nullable fields if needed
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return MedicineModel._(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      dosage: dosage ?? this.dosage,
      dosageUnit: dosageUnit ?? this.dosageUnit,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      mealTiming: mealTiming ?? this.mealTiming,
      repeatSchedule: repeatSchedule ?? this.repeatSchedule,
      scheduleTimes: scheduleTimes ?? this.scheduleTimes,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      // Always update modifiedAt when copying, unless explicitly passed
      modifiedAt: modifiedAt ?? DateTime.now(),
    );
  }
}

/// Converts TimeOfDay to a serializable string "HH:mm".
String timeOfDayToString(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

/// Converts a string "HH:mm" back to TimeOfDay.
/// Returns null if the format is invalid.
TimeOfDay? stringToTimeOfDay(String timeString) {
  try {
    final parts = timeString.split(':');
    if (parts.length != 2) return null; // Invalid format
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return null; // Invalid numbers
    }
    return TimeOfDay(hour: hour, minute: minute);
  } catch (e) {
    // Handle potential exceptions during parsing, although tryParse should prevent most
    print("Error parsing time string '$timeString': $e");
    return null;
  }
}
