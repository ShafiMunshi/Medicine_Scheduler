import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:medicine_app/models/medicine_draft_log_model.dart';
import 'package:path_provider/path_provider.dart';

class DraftFileService {
  static const _fileName = 'medicine_draft_logs.json';

  /// Set a manual path if path_provider doesn't work in background isolates
  static Future<File> _getFile() async {
    // For foreground isolate with path_provider:
    // final directory = await getApplicationDocumentsDirectory();
    // return File('${directory.path}/$_fileName');

    // log("main path : ${directory.path}/$_fileName");

    // For background isolate, use hardcoded app directory path
    final path = '/data/user/0/com.example.medicine_app/app_flutter/$_fileName';

    // Ensure the directory exists
    final dir = Directory(path).parent;
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return File(path);
  }

  /// Save list of logs
  static Future<void> _saveLogs(List<MedicineDraftLog> logs) async {
    try {
      final file = await _getFile();
      final jsonStr = jsonEncode(logs.map((log) => log.toJson()).toList());
      await file.writeAsString(jsonStr);
    } catch (e) {
      log("Error saving logs: $e");
    }
  }

  /// Read all saved logs
  static Future<List<MedicineDraftLog>> readLogs() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];
      final jsonStr = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonStr);
      return jsonList.map((item) => MedicineDraftLog.fromJson(item)).toList();
    } catch (e) {
      log("Error reading logs: $e");
      return [];
    }
  }

  /// Add a single log
  static Future<void> addLog(List<MedicineDraftLog> newLogs) async {
    final logs = await readLogs();
    logs.addAll(newLogs);
    await _saveLogs(logs);
  }

  /// Update a specific log by matching medicineId and scheduledDateTime
  static Future<void> updateLog(MedicineDraftLog updatedLog) async {
    final logs = await readLogs();

    final index = logs.indexWhere((log) =>
        log.medicineId == updatedLog.medicineId &&
        log.scheduledDateTime.toIso8601String() ==
            updatedLog.scheduledDateTime.toIso8601String());

    if (index != -1) {
      logs[index] = updatedLog;
      await _saveLogs(logs);
    }
  }

  /// Clear all logs
  static Future<void> clearLogs() async {
    final file = await _getFile();
    if (await file.exists()) {
      await file.writeAsString('[]');
    }
  }
}
