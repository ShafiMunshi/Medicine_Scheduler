import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/screens/auth/sign_in_page.dart';
import 'package:medicine_app/screens/caregiver/caregiver_dashboard_view.dart';
import 'package:medicine_app/screens/caregiver/parent_linking_view.dart';
import 'package:medicine_app/screens/profile/user_profile_setup_view.dart';
import 'package:medicine_app/screens/settings/all_medicine_log_view.dart';
import 'package:medicine_app/screens/settings/my_profile_view.dart';
import 'package:medicine_app/service/notification_service.dart';
import 'package:medicine_app/viewmodels/auth_viewmodel.dart';
import 'package:nb_utils/nb_utils.dart';

class SettingsView extends ConsumerWidget {
  static const String routeName = '/settings_view';
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFbUser = ref.watch(currentFirebaseUserProvider);

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
            // Account Status Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: currentFbUser != null
                    ? AppColors.primaryColor.withOpacity(0.08)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: currentFbUser != null
                      ? AppColors.primaryColor.withOpacity(0.2)
                      : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    child: Icon(
                      currentFbUser != null ? Icons.person : Icons.person_outline,
                      color: Colors.white,
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentFbUser != null
                              ? (currentFbUser.displayName ?? 'Signed In')
                              : 'Not Signed In',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        2.verticalSpace,
                        Text(
                          currentFbUser != null
                              ? (currentFbUser.email ?? 'Active Account')
                              : 'Sign in to use Medicine Scheduler',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (currentFbUser != null)
                    TextButton(
                      onPressed: () async {
                        await ref.read(authControllerProvider.notifier).signOut();
                        toast('Signed out');
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            SignWithEmailInScreen.routeName,
                            (route) => false,
                          );
                        }
                      },
                      child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
                    )
                  else
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          SignWithEmailInScreen.routeName,
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text('Sign In', style: TextStyle(fontSize: 12)),
                    ),
                ],
              ),
            ),
            14.verticalSpace,

            // Health Profile Section
            listCard(
              title: 'Health Profile & Medical Details',
              icon: Icons.health_and_safety_outlined,
              iconColor: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UserProfileSetupView(isInitialSetup: false),
                  ),
                );
              },
            ),
            10.verticalSpace,

            // Caregiver & Family Linking
            listCard(
              title: 'Caregiver & Family Supervision',
              icon: Icons.family_restroom,
              iconColor: Colors.indigo,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ParentLinkingView(),
                  ),
                );
              },
            ),
            10.verticalSpace,

            // Caregiver Live Dashboard
            listCard(
              title: 'Caregiver Dashboard (Monitor Family)',
              icon: Icons.remove_red_eye_outlined,
              iconColor: Colors.deepOrange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CaregiverDashboardView(),
                  ),
                );
              },
            ),
            10.verticalSpace,

            listCard(
              title: 'My Profile (Basic)',
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
    Color? iconColor,
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
          color: (iconColor ?? Colors.black87).withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon ?? Icons.settings,
          size: 22,
          color: iconColor ?? Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }
}
