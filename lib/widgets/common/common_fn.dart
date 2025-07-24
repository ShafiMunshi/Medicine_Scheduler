import 'dart:developer';

import 'package:flutter/material.dart';

String timeOfDayToString(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

TimeOfDay? stringToTimeOfDay(String? timeString) {
  if (timeString == null) return null;
  try {
    final parts = timeString.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return null;
    }
    return TimeOfDay(hour: hour, minute: minute);
  } catch (e) {
    log("Error parsing time string '$timeString': $e");
    return null;
  }
}

String formatTimeOfDayTo12Hour(TimeOfDay time, BuildContext context) {
  final localizations = MaterialLocalizations.of(context);
  return localizations.formatTimeOfDay(time);
}

int generateNotificationId(int medicineId, DateTime scheduleTime) {
  // Creates a consistent unique ID per scheduled item
  return int.parse(
      '$medicineId${scheduleTime.millisecondsSinceEpoch % 1000000}');
}
