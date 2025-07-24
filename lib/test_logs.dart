import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:medicine_app/data/source/local_db_source.dart';
import 'package:medicine_app/models/testing_model.dart';
import 'package:provider/provider.dart';

class TestLogs extends StatefulWidget {
  const TestLogs({super.key});

  @override
  State<TestLogs> createState() => _TestLogsState();
}

class _TestLogsState extends State<TestLogs> {
  List<TestingModel> _logs = [];

  @override
  void initState() {
    super.initState();
    final vm = context.read<LocalDatabaseService>();

    // Initialize the local database service
    vm.init().then((_) async {
      // Optionally, you can perform any additional setup after initialization
      _logs = await vm.isar.testingModels.where().findAll();
      print("LocalDatabaseService initialized successfully.");
    }).catchError((error) {
      print("Error initializing LocalDatabaseService: $error");
    });

    setState(() {});
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
                  title: Text(log.name ?? 'No Name'),
                );
              },
            ),
    );
  }
}
