import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:medicine_app/constant/app_constants.dart';
import 'package:medicine_app/models/medicine_draft_log_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPref {
  MySharedPref._();

  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> reload() async {
    _sharedPreferences.reload();
  }

  static setValue(String key, String value) {
    _sharedPreferences.setString(key, value);
    if (kDebugMode) {
      print("$key = $value (setted)");
    }
  }

  static String? getValue(String key) {
    return _sharedPreferences.getString(key);
  }

  static Future<void> setBool(String key, bool val) async {
    await _sharedPreferences.setBool(key, val);
  }

  static isContains(String key) {
    _sharedPreferences.containsKey(key);
  }

  

  static Future<void> saveDraftMedicineLogs(MedicineDraftLog newLogs) async {
    final prefs = await SharedPreferences.getInstance();
    final oldLogs = await getDraftMedicineLogs();
    final updatedLogs = [...oldLogs, newLogs];
    await prefs.setStringList(
      AppConstants.DRAFT_MEDICINE_LOGS,
      updatedLogs.map((log) => jsonEncode(log.toJson())).toList(),
    );
  }

  static Future<List<MedicineDraftLog>> getDraftMedicineLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final logs = prefs.getStringList(AppConstants.DRAFT_MEDICINE_LOGS) ?? [];
    return logs
        .map((log) => MedicineDraftLog.fromJson(jsonDecode(log)))
        .toList();
  }

  static Future<void> clear() async => await _sharedPreferences.clear();
}
