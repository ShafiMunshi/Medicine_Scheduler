import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/data/repository/consume_repository.dart';
import 'package:medicine_app/data/source/my_shared_pref.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/screens/settings/all_medicine_log_view.dart';
import 'package:medicine_app/screens/settings/my_profile_view.dart';
import 'package:medicine_app/test_file_logs_page.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  static String routeName = '/settings_view';
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        title: 'Settings',
        changeIcon: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 10,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            listCard(
                title: 'My Profile',
                icon: Icons.person_2_rounded,
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => MyProfileView()));
                }),
            listCard(title: 'Access Settings', onTap: () async {}),
            listCard(
                title: 'Privacy Policy',
                icon: Icons.privacy_tip,
                onTap: () async {}),
            listCard(
                title: 'Rate This App',
                icon: Icons.privacy_tip,
                onTap: () async {}),
            ElevatedButton(onPressed: () {}, child: Text('Sign Out')),
            // Card(
            //   child: ListTile(
            //     title: Text('All Medicine Consume Log'),
            //     onTap: () async {
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: (_) => AllMedicineLogView()));
            //     },
            //   ),
            // ),
            // Card(
            //   child: ListTile(
            //     title: Text('Clear Medicine Consume Log'),
            //     onTap: () async {
            //       await context
            //           .read<MedicineConsumeRepository>()
            //           .clearAllMedicineConsumeLogs();
            //     },
            //   ),
            // ),
            // Card(
            //   child: ListTile(
            //     title: Text('Clear Shared Pref Log'),
            //     onTap: () async {
            //       await MySharedPref.clear();
            //     },
            //   ),
            // ),
            // Card(
            //   child: ListTile(
            //     title: Text('Show Draft Log'),
            //     onTap: () async {
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: (_) => TestFileLogsPage()));
            //     },
            //   ),
            // ),
            // ElevatedButton(
            //   onPressed: getScheduledNotifications,
            //   style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            //   child: Text('Show Scheduled Notifications'),
            // ),
          ],
        ),
      ),
    );
  }

  ListTile listCard({
    required String title,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      contentPadding: EdgeInsets.only(left: 8, right: 8),
      leading: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(8),
        child: Icon(
          icon ?? Icons.settings,
          size: 20,
          color: Colors.black54,
        ),
      ),
      onTap: onTap,
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
