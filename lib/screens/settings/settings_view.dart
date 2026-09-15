import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/screens/auth/sign_in_page.dart';
import 'package:medicine_app/screens/caregiver/caregiver_dashboard_view.dart';
import 'package:medicine_app/screens/caregiver/parent_linking_view.dart';
import 'package:medicine_app/screens/profile/user_profile_setup_view.dart';
import 'package:medicine_app/screens/settings/all_medicine_log_view.dart';
import 'package:medicine_app/screens/settings/my_profile_view.dart';
import 'package:medicine_app/service/notification_service.dart';
import 'package:medicine_app/viewmodels/auth_viewmodel.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodel.dart';
import 'package:medicine_app/viewmodels/profile_viewmodel.dart';
import 'package:medicine_app/widgets/user_avatar_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class SettingsView extends ConsumerStatefulWidget {
  static const String routeName = '/settings_view';
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  late bool _notificationsEnabled;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = NotificationService.areNotificationsEnabled();
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });

    await NotificationService.setNotificationsEnabled(value);

    if (value) {
      final granted = await NotificationService.requestPermissions();
      if (!granted && mounted) {
        toast('Please allow notification permissions in settings');
      }

      final allMeds = await ref.read(allMedicinesProvider.future);
      await NotificationService.rescheduleAllActiveMedicines(allMeds);
      toast('Medication reminders enabled');
    } else {
      toast('Medication reminders disabled');
    }
  }

  Future<void> _rateApp() async {
    try {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        toast('Thank you for rating Medicine Scheduler!');
      }
    } catch (_) {
      toast('Thank you for using Medicine Scheduler!');
    }
  }

  void _showPrivacyDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                  ),
                  12.horizontalSpace,
                  const Text(
                    'Privacy & Data Policy',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              16.verticalSpace,
              const Text(
                '• 100% Offline-First: All your medication schedules, dose times, and health logs are stored securely on your local device.',
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              8.verticalSpace,
              const Text(
                '• Offline Alarms: Reminders trigger via on-device exact hardware alarms without transmitting data to external servers.',
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              8.verticalSpace,
              const Text(
                '• Family & Caregiver Sync: Only when you explicitly link with a caregiver is adherence status synchronized over encrypted channels.',
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              20.verticalSpace,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Understood'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text(
          'Are you sure you want to sign out from your account? Your local schedules will remain safe.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(authControllerProvider.notifier).signOut();
              toast('Signed out successfully');
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  SignWithEmailInScreen.routeName,
                  (route) => false,
                );
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentFbUser = ref.watch(currentFirebaseUserProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // 1. User Profile Header Card
          _buildUserProfileCard(currentFbUser, profileAsync),
          20.verticalSpace,

          // 2. Notification Settings Section
          _buildSectionHeader('REMINDERS & NOTIFICATIONS'),
          _buildCardGroup([
            _buildSwitchTile(
              icon: Icons.notifications_active_rounded,
              iconColor: Colors.deepPurple,
              title: 'Medication Reminders',
              subtitle: 'Receive exact alarm alerts for scheduled doses',
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.access_alarm_rounded,
              iconColor: Colors.teal,
              title: 'Exact Alarm Precision',
              subtitle: 'Optimized for timely alerts even in Doze mode',
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  'Enabled',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
              onTap: () async {
                final canExact = await NotificationService.canScheduleExactAlarms();
                toast(canExact
                    ? 'Exact alarms are supported and permitted ✅'
                    : 'Please grant exact alarm permissions in settings');
              },
            ),
          ]),
          20.verticalSpace,

          // 3. Health Profile & Supervision Section
          _buildSectionHeader('HEALTH & CAREGIVER'),
          _buildCardGroup([
            _buildSettingsTile(
              icon: Icons.health_and_safety_outlined,
              iconColor: Colors.teal,
              title: 'Health Profile & Details',
              subtitle: 'Blood group, allergies, weight, conditions & avatar',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UserProfileSetupView(isInitialSetup: false),
                  ),
                );
              },
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.family_restroom_rounded,
              iconColor: Colors.indigo,
              title: 'Caregiver & Family Supervision',
              subtitle: 'Connect family members to monitor adherence',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ParentLinkingView(),
                  ),
                );
              },
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.remove_red_eye_outlined,
              iconColor: Colors.deepOrange,
              title: 'Caregiver Dashboard',
              subtitle: 'Live compliance and intake overview for loved ones',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CaregiverDashboardView(),
                  ),
                );
              },
            ),
          ]),
          20.verticalSpace,

          // 4. Logs & Data Section
          _buildSectionHeader('MEDICATION RECORDS'),
          _buildCardGroup([
            _buildSettingsTile(
              icon: Icons.history_rounded,
              iconColor: Colors.blue,
              title: 'All Medication Logs',
              subtitle: 'History of doses taken, missed, and skipped',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AllMedicineLogView(),
                  ),
                );
              },
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.badge_outlined,
              iconColor: Colors.blueGrey,
              title: 'Personal Info & Contact',
              subtitle: 'View contact number and address details',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyProfileView(),
                  ),
                );
              },
            ),
          ]),
          20.verticalSpace,

          // 5. About & Support Section
          _buildSectionHeader('ABOUT & SUPPORT'),
          _buildCardGroup([
            _buildSettingsTile(
              icon: Icons.shield_outlined,
              iconColor: Colors.cyan.shade800,
              title: 'Privacy & Data Protection',
              subtitle: '100% offline-first local database',
              onTap: _showPrivacyDialog,
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.star_rate_rounded,
              iconColor: Colors.amber.shade700,
              title: 'Rate This App',
              subtitle: 'Support Medicine Scheduler on Google Play',
              onTap: _rateApp,
            ),
          ]),
          20.verticalSpace,

          // 6. Developer & Testing Options (HIDDEN IN RELEASE MODE)
          if (!kReleaseMode) ...[
            _buildSectionHeader('DEVELOPER TESTING (DEBUG ONLY)'),
            _buildCardGroup(
              [
                _buildSettingsTile(
                  icon: Icons.alarm,
                  iconColor: Colors.amber.shade800,
                  title: 'Test Notification (5 seconds)',
                  subtitle: 'Schedules a test alarm to test offline notification',
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
                    toast('Test notification scheduled for 5s from now!');
                  },
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.bug_report_outlined,
                  iconColor: Colors.red.shade700,
                  title: 'Notification Diagnostics',
                  subtitle: 'Inspect exact alarm capability & pending alarms',
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
                              Text('Exact Alarms Supported: ${canExact ? "Yes ✅" : "No ⚠️"}'),
                              const SizedBox(height: 8),
                              Text('Scheduled Pending Alarms: ${pending.length}'),
                              const SizedBox(height: 12),
                              const Text(
                                'Exact alarms trigger precisely during Doze mode without internet connection.',
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
              ],
              borderColor: Colors.amber.shade300,
            ),
            20.verticalSpace,
          ],

          // App Version & Branding Footer
          Center(
            child: Column(
              children: [
                Text(
                  'Medicine Scheduler v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                4.verticalSpace,
                Text(
                  'Stay on track with your health & medication',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          24.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildUserProfileCard(
    dynamic currentFbUser,
    AsyncValue<dynamic> profileAsync,
  ) {
    return profileAsync.when(
      data: (user) {
        final displayName = (user?.name != null && user!.name.isNotEmpty && user.name != 'Shafi Munshi')
            ? user.name
            : (currentFbUser?.displayName ?? user?.name ?? 'Shafi Munshi');
        final email = currentFbUser?.email ?? user?.email ?? 'Active Account';
        final role = (user?.role ?? 'Patient').toUpperCase();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  UserAvatarWidget(
                    avatarPath: user?.imagePath,
                    radius: 28,
                    borderWidth: 2,
                    borderColor: AppColors.primaryColor.withValues(alpha: 0.2),
                  ),
                  14.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                displayName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            6.horizontalSpace,
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                role,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        3.verticalSpace,
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              14.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: BorderSide(color: AppColors.primaryColor.withValues(alpha: 0.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const UserProfileSetupView(isInitialSetup: false),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primaryColor),
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  if (currentFbUser != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          side: BorderSide(color: Colors.red.shade200),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _showSignOutDialog,
                        icon: Icon(Icons.logout, size: 16, color: Colors.red.shade600),
                        label: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade600,
                          ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            SignWithEmailInScreen.routeName,
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.login, size: 16),
                        label: const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildCardGroup(List<Widget> children, {Color? borderColor}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor ?? Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 52,
      color: Colors.grey.shade100,
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: Colors.grey.shade400,
          ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        activeTrackColor: AppColors.primaryColor,
        onChanged: onChanged,
      ),
    );
  }
}
