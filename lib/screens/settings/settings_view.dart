import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/screens/settings/all_medicine_log_view.dart';
import 'package:medicine_app/screens/settings/my_profile_view.dart';
import 'package:medicine_app/service/notification_service.dart';
import 'package:nb_utils/nb_utils.dart';

class SettingsView extends ConsumerWidget {
  static const String routeName = '/settings_view';
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        title: 'Settings',
        changeIcon: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            listCard(
              title: 'My Profile',
              icon: Icons.person_2_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyProfileView()),
                );
              },
            ),
            10.verticalSpace,
            listCard(
              title: 'All Medicine Consumption Logs',
              icon: Icons.history,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AllMedicineLogView()),
                );
              },
            ),
            10.verticalSpace,
            listCard(
              title: 'Notification Status & Permissions',
              icon: Icons.notifications_active_outlined,
              onTap: () async {
                final canExact = await NotificationService.canScheduleExactAlarms();
                final pending = await NotificationService.getPendingNotifications();
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Notification Diagnostics'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Exact Alarm Supported: ${canExact ? "Yes ✅" : "No ⚠️"}'),
                          const SizedBox(height: 8),
                          Text('Scheduled Upcoming Alarms: ${pending.length}'),
                          const SizedBox(height: 12),
                          const Text(
                            'Exact alarms trigger at the exact second even during Doze mode without internet connection.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            10.verticalSpace,
            listCard(
              title: 'Test Notification (5 seconds)',
              icon: Icons.alarm,
              onTap: () async {
                final fireTime = DateTime.now().add(const Duration(seconds: 5));
                await NotificationService.scheduleNotification(
                  id: 99999,
                  title: 'Test Reminder 💊',
                  body: 'Exact offline notification is working accurately!',
                  scheduledDate: fireTime,
                  payload: {
                    'type': 'test',
                    'scheduledDateTime': fireTime.toIso8601String(),
                  },
                );
                toast('Notification scheduled for 5 seconds from now!');
              },
            ),
            10.verticalSpace,
            listCard(
              title: 'Privacy Policy',
              icon: Icons.privacy_tip_outlined,
              onTap: () {
                toast('All your medicine schedules are stored 100% locally on your device.');
              },
            ),
            10.verticalSpace,
            listCard(
              title: 'Rate This App',
              icon: Icons.star_rate_outlined,
              onTap: () {
                toast('Thank you for using Medicine Scheduler!');
              },
            ),
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
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon ?? Icons.settings,
          size: 22,
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }
}
