import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodel.dart';
import 'package:medicine_app/viewmodels/schedule_viewmodel.dart';

class AllMedicineLogView extends ConsumerWidget {
  const AllMedicineLogView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allLogsAsync = ref.watch(allLogsProvider);
    final allMedsAsync = ref.watch(allMedicinesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Consumption Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear All Logs',
            onPressed: () => _confirmClear(context, ref),
          ),
        ],
      ),
      body: allLogsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(
              child: Text(
                'No consumption logs recorded yet.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          final medicines = allMedsAsync.value ?? [];

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: logs.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final log = logs[index];
              final med = medicines
                  .where((m) => m.medicine.id == log.medicineId)
                  .firstOrNull;
              final medName = med?.medicine.medicineName ?? 'Medicine #${log.medicineId}';

              final isTaken = log.status == 'taken';
              final isSkipped = log.status == 'skipped';

              final statusColor = isTaken
                  ? Colors.green
                  : (isSkipped ? Colors.orange : Colors.red);

              final dateFormat = DateFormat('EEE, d MMM yyyy, h:mm a');
              final scheduledStr = dateFormat.format(log.scheduledDateTime);
              final takenStr = log.actualTakenTime != null
                  ? dateFormat.format(log.actualTakenTime!)
                  : 'Not recorded';

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: statusColor.withOpacity(0.15),
                  child: Icon(
                    isTaken ? Icons.check : (isSkipped ? Icons.skip_next : Icons.close),
                    color: statusColor,
                  ),
                ),
                title: Text(
                  medName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Scheduled: $scheduledStr'),
                    if (isTaken) Text('Taken at: $takenStr'),
                    Text('Dose: ${log.dosageTaken} ${med?.dosageUnitEnum.displayName ?? "Pcs"}'),
                  ],
                ),
                trailing: Chip(
                  label: Text(
                    log.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: statusColor.withOpacity(0.1),
                  side: BorderSide.none,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _confirmClear(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Logs'),
        content: const Text('Are you sure you want to clear all historical intake logs?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(scheduleControllerProvider.notifier).clearAllLogs();
              ref.invalidate(allLogsProvider);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
