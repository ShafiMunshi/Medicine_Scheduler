import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medicine_app/models/medicine_draft_log_model.dart';
import 'package:medicine_app/service/draft_file_service.dart';

class TestFileLogsPage extends StatefulWidget {
  const TestFileLogsPage({super.key});

  @override
  State<TestFileLogsPage> createState() => _TestFileLogsPageState();
}

class _TestFileLogsPageState extends State<TestFileLogsPage> {
  List<MedicineDraftLog> _logs = [];

  @override
  void initState() {
    super.initState();
    DraftFileService.readLogs().then((logs) {
      log("Logs read successfully. Count: ${logs.length}");
      setState(() {
        _logs = logs;
      });
    }).catchError((error) {
      log("Error reading logs: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Logs'),
      ),
      body: _logs.isEmpty
          ? const Center(child: Text('No logs found'))
          : ListView.builder(
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                return ListTile(
                  title: Text(log.medicineId.toString() ?? 'No Name'),
                  subtitle: Text(
                    'Scheduled: ${log.scheduledDateTime}\n'
                    'Actual Taken: ${log.actualTakenTime?.toIso8601String() ?? 'Not taken yet'}\n'
                    'Status: ${log.status?.name ?? 'Unknown'}\n'
                    'Dosage: ${log.dosage ?? 'Not specified'}',
                  ),
                );
              },
            ),
    );
  }
}
