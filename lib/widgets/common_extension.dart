import 'dart:developer';

import 'package:flutter/material.dart';

extension MyTextFieldExt on TextEditingController {
  int toInt() {
    if (text.isEmpty) {
      return 0;
    }
    return int.parse(text.trim());
  }
}

extension MyTimeOfDayExt on TimeOfDay {
  String timeOfDayToString() {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  TimeOfDay? stringToTimeOfDay(String timeString) {
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
}
