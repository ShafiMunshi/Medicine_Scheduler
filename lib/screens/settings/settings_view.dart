import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/data/repository/consume_repository.dart';
import 'package:medicine_app/data/source/my_shared_pref.dart';
import 'package:medicine_app/screens/settings/all_medicine_log_view.dart';
import 'package:medicine_app/test_file_logs_page.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  static String routeName = '/settings_view';
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: ListTile(
                title: Text('All Medicine Consume Log'),
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AllMedicineLogView()));
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Clear Medicine Consume Log'),
                onTap: () async {
                  await context
                      .read<MedicineConsumeRepository>()
                      .clearAllMedicineConsumeLogs();
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Clear Shared Pref Log'),
                onTap: () async {
                  await MySharedPref.clear();
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Show Draft Log'),
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => TestFileLogsPage()));
                },
              ),
            ),
            ElevatedButton(
              onPressed: getScheduledNotifications,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Show Scheduled Notifications'),
            ),
          ],
        ),
      ),
    );
  }

  // Get scheduled notifications
  Future<void> getScheduledNotifications() async {
    List<NotificationModel> scheduledNotifications =
        await AwesomeNotifications().listScheduledNotifications();

    log('Scheduled notifications: ${scheduledNotifications.length}');
    for (var notification in scheduledNotifications) {
      log('ID: ${notification.content!.id}, Title: ${notification.content!.title} at ');
    }
  }
}
