import 'package:flutter/material.dart';
import 'package:medicine_app/models/medicine_draft_log_model.dart';

class TestFileLogsPage extends StatefulWidget {
  const TestFileLogsPage({super.key});

  @override
  State<TestFileLogsPage> createState() => _TestFileLogsPageState();
}

class _TestFileLogsPageState extends State<TestFileLogsPage> {
  List<MedicineDraftLog> _logs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // DraftFileService.readLogs().then((logs) {
    //   log("Logs read successfully. Count: ${logs.length}");
    //   setState(() {
    //     _logs = logs;
    //     isLoading = false;
    //   });
    // }).catchError((error) {
    //   log("Error reading logs: $error");
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Logs'),
        actions: [
          Text('Total Logs: ${_logs.length}'),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
              ? const Center(child: Text('No logs found'))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      final log = _logs[index];
                      return ListTile(
                        title: Text(
                            "ID: ${log.medicineId.toString()} - ${log.medicineName}"),
                        subtitle: Text(
                          'Scheduled: ${log.scheduledDateTime}\n'
                          'Actual Taken: ${log.actualTakenTime?.toIso8601String() ?? 'Not taken yet'}\n'
                          'Status: ${log.status?.name ?? 'Unknown'}\n'
                          'Dosage: ${log.dosage ?? 'Not specified'}\n'
                          'Is Synced: ${log.isSynced}',
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: Colors.grey.shade300)),
                      );
                    },
                  ),
                ),
    );
  }
}
