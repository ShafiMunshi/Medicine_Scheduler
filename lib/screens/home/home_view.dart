import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_assets.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/core/utils/schedule_calculator.dart';
import 'package:medicine_app/screens/home/widget/monthly_adherence_chart.dart';
import 'package:medicine_app/screens/my_medicine/widget/medicine_widget.dart';
import 'package:medicine_app/screens/profile/user_profile_setup_view.dart';
import 'package:medicine_app/viewmodels/database_providers.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodel.dart';
import 'package:medicine_app/viewmodels/profile_viewmodel.dart';
import 'package:medicine_app/viewmodels/schedule_viewmodel.dart';
import 'package:medicine_app/service/notification_service.dart';
import 'package:medicine_app/widgets/user_avatar_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeView extends ConsumerWidget {
  static const String routeName = '/home_view';
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayMedicines = ref.watch(todayMedicinesProvider);
    final allMedicinesAsync = ref.watch(allMedicinesProvider);
    final todayLogs = ref.watch(todayLogsProvider).value ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topProfileSection(context, ref),
            const NotificationStatusBanner(),
            12.verticalSpace,
            topHorizontalProgressBar(todayMedicines.length, allMedicinesAsync.value?.length ?? 0),
            16.verticalSpace,
            const MonthlyAdherenceChart(),
            16.verticalSpace,
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today\'s Medication',
                        style: boldTextStyle(size: 16),
                      ),
                      Text(
                        '${todayMedicines.length} scheduled',
                        style: secondaryTextStyle(size: 12),
                      ),
                    ],
                  ),
                  12.verticalSpace,
                  allMedicinesAsync.when(
                    data: (_) {
                      if (todayMedicines.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
                                10.verticalSpace,
                                const Text(
                                  "No Medicine Scheduled for Today",
                                  style: TextStyle(color: Colors.grey, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: todayMedicines.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final medicine = todayMedicines[index];
                          final nearestTimeLeft = ScheduleCalculator.getTimeUntilNextDose(
                            medicine.scheduleItems,
                            DateTime.now(),
                          );

                          final stockIndex = ScheduleCalculator.getStockProgressIndex(
                            availableQuantity: medicine.medicine.availableQuantity,
                            medicineTakenCount: medicine.medicine.medicineTakenCount,
                          );

                          return MedicineWidget(
                            medicineName: medicine.medicine.medicineName,
                            timeLeft: nearestTimeLeft,
                            lengthNeedToBeColored: stockIndex,
                            index: index,
                            medicine: medicine,
                            imagePath: medicine.medicine.imagePath,
                            targetDate: DateTime.now(),
                            logs: todayLogs,
                          );
                        },
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Center(child: Text("Error: $e")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topHorizontalProgressBar(int remainingToday, int totalCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _topCardWidget(
            asset: AppAssets.clockk,
            data: remainingToday.toString(),
            subTitle: 'Remaining today',
            color: AppColors.mistiColor,
          ),
        ),
        15.horizontalSpace,
        Flexible(
          child: _topCardWidget(
            asset: AppAssets.tablet,
            data: totalCount.toString(),
            subTitle: 'Total Medicine',
            color: AppColors.purpleLow,
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 20);
  }

  Container _topCardWidget({
    required String asset,
    required String data,
    required String subTitle,
    required Color color,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10.r),
      decoration: boxDecoration(bgColor: color, radius: 16.r),
      child: Row(
        children: [
          SvgPicture.asset(asset),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data,
                  style: boldTextStyle(size: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subTitle,
                  style: secondaryTextStyle(size: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget topProfileSection(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (user) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UserProfileSetupView(isInitialSetup: false),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(25.r),
              child: Row(
                children: [
                  UserAvatarWidget(
                    avatarPath: user?.imagePath,
                    radius: 25.r,
                    borderWidth: 1.5,
                    borderColor: AppColors.primaryColor.withValues(alpha: 0.3),
                  ),
                  15.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Shafi Munshi',
                        style: boldTextStyle(),
                      ),
                      Text(
                        '${user?.age ?? 24} years old',
                        style: secondaryTextStyle(),
                      ),
                    ],
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                final pending = await NotificationService.getPendingNotifications();
                final isSysEnabled = await NotificationService.isSystemNotificationEnabled();
                if (context.mounted) {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    backgroundColor: Colors.white,
                    builder: (ctx) => SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.notifications_active, color: AppColors.primaryColor),
                                10.horizontalSpace,
                                const Text(
                                  'Medication Reminders Status',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            14.verticalSpace,
                            Text(
                              '• Notification Permissions: ${isSysEnabled ? "Allowed ✅" : "Blocked ❌ (Enable in System Settings)"}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            8.verticalSpace,
                            Text(
                              '• Active Offline Alarms: ${pending.length} scheduled',
                              style: const TextStyle(fontSize: 14),
                            ),
                            16.verticalSpace,
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      Navigator.pop(ctx);
                                      final fireTime = DateTime.now().add(const Duration(seconds: 5));
                                      await NotificationService.scheduleNotification(
                                        id: 99999,
                                        title: 'Test Reminder 💊',
                                        body: 'Medication alarm is ringing on time!',
                                        scheduledDate: fireTime,
                                        payload: {
                                          'type': 'test',
                                          'scheduledDateTime': fireTime.toIso8601String(),
                                        },
                                      );
                                      toast('Test reminder scheduled for 5s from now!');
                                    },
                                    child: const Text('Test (5s)'),
                                  ),
                                ),
                                10.horizontalSpace,
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(ctx);
                                      final allMeds = await ref.read(medicineRepositoryProvider).getAllMedicines();
                                      final count = await NotificationService.rescheduleAllActiveMedicines(allMeds);
                                      toast('Refreshed $count upcoming medication reminders');
                                    },
                                    child: const Text('Reschedule'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: boxDecoration(
                  bgColor: white,
                  radius: 12.r,
                  color: AppColors.greyColor,
                ),
                child: SvgPicture.asset(
                  AppAssets.notifications,
                ),
              ),
            )
          ],
        ).paddingSymmetric(horizontal: 20);
      },
      loading: () => const SizedBox(height: 50),
      error: (_, __) => const SizedBox(height: 50),
    );
  }
}

class NotificationStatusBanner extends StatefulWidget {
  const NotificationStatusBanner({super.key});

  @override
  State<NotificationStatusBanner> createState() => _NotificationStatusBannerState();
}

class _NotificationStatusBannerState extends State<NotificationStatusBanner> with WidgetsBindingObserver {
  bool _isSysEnabled = true;
  bool _canExact = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _check();
    }
  }

  Future<void> _check() async {
    try {
      final sys = await NotificationService.isSystemNotificationEnabled();
      final exact = await NotificationService.canScheduleExactAlarms();
      if (mounted) {
        setState(() {
          _isSysEnabled = sys;
          _canExact = exact;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_isSysEnabled && _canExact) {
      return const SizedBox.shrink();
    }

    final isNotifBlocked = !_isSysEnabled;
    final message = isNotifBlocked
        ? 'Notifications are blocked in system settings. Medicine alerts cannot pop up.'
        : 'Alarms & Reminders permission is required to alert you before your medicine times.';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 22),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isNotifBlocked ? 'Enable Notifications' : 'Enable Exact Alarms',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDC2626),
                    fontSize: 13,
                  ),
                ),
                2.verticalSpace,
                Text(
                  message,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF7F1D1D)),
                ),
              ],
            ),
          ),
          8.horizontalSpace,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              if (isNotifBlocked) {
                await NotificationService.requestPermissions();
              } else {
                await NotificationService.requestExactAlarmsPermission();
              }
              await _check();
            },
            child: const Text('Fix', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
