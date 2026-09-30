import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/core/utils/schedule_calculator.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/data/repositories/medicine_log_repository.dart';
import 'package:medicine_app/data/source/my_shared_pref.dart';
import 'package:medicine_app/models/domain_models.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Top-level background notification action handler (invoked when app is terminated/backgrounded).
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) async {
  log('Notification tapped in background: action=${notificationResponse.actionId}, payload=${notificationResponse.payload}');

  final payloadStr = notificationResponse.payload;
  if (payloadStr == null) return;

  try {
    final Map<String, dynamic> data = jsonDecode(payloadStr);
    final medicineId = data['medicineId'] as int?;
    final scheduleId = data['scheduleId'] as int?;
    final scheduledDateStr = data['scheduledDateTime'] as String?;
    final dosage = (data['dosage'] as num?)?.toDouble() ?? 1.0;

    if (medicineId != null && scheduledDateStr != null) {
      final scheduledDateTime = DateTime.parse(scheduledDateStr);
      final db = AppDatabase();
      final logRepo = DriftMedicineLogRepository(db);

      if (notificationResponse.actionId == 'TAKE_ACTION') {
        await logRepo.markDose(
          medicineId: medicineId,
          scheduleId: scheduleId,
          scheduledDateTime: scheduledDateTime,
          status: ConsumptionStatus.taken,
          dosageTaken: dosage,
        );
        log('Background: Marked dose as TAKEN for medicine $medicineId at $scheduledDateTime');
      } else if (notificationResponse.actionId == 'SKIP_ACTION') {
        await logRepo.markDose(
          medicineId: medicineId,
          scheduleId: scheduleId,
          scheduledDateTime: scheduledDateTime,
          status: ConsumptionStatus.skipped,
          dosageTaken: dosage,
        );
        log('Background: Marked dose as SKIPPED for medicine $medicineId at $scheduledDateTime');
      }

      await db.close();
    }
  } catch (e, stack) {
    log('Error handling background notification response: $e\n$stack');
  }
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'medicine_reminders_v3';
  static const String _channelName = 'Medication Reminders';
  static const String _channelDescription =
      'High-priority alarms and notifications for scheduled medications';

  static const String prefKeyNotificationsEnabled = 'pref_notifications_enabled';

  static bool _isInitialized = false;

  /// Checks whether notifications are enabled by the user in app settings. Defaults to true.
  static bool areNotificationsEnabled() {
    try {
      return MySharedPref.getBool(prefKeyNotificationsEnabled) ?? true;
    } catch (_) {
      return true;
    }
  }

  /// Updates whether notifications are enabled by the user in app settings.
  /// If disabled, all currently scheduled notifications are cancelled.
  static Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      await MySharedPref.setBool(prefKeyNotificationsEnabled, enabled);
    } catch (_) {}
    if (!enabled) {
      await cancelAll();
      log('User disabled notifications: cancelled all scheduled alarms.');
    } else {
      log('User enabled notifications in app settings.');
    }
  }

  /// Checks whether notifications are allowed at the Android / iOS OS system level.
  static Future<bool> isSystemNotificationEnabled() async {
    if (Platform.isAndroid) {
      final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        return await androidPlugin.areNotificationsEnabled() ?? true;
      }
    }
    return true;
  }

  /// Initializes timezone data, notification channels, and platform settings.
  static Future<void> initialize() async {
    if (_isInitialized) return;

    // 1. Initialize timezone database with robust fallback matching device offset
    tz.initializeTimeZones();
    try {
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
      log('Timezone initialized to: $currentTimeZone');
    } catch (e) {
      log('Could not obtain device local timezone ($e), searching matching offset...');
      try {
        final offset = DateTime.now().timeZoneOffset;
        final matchingLocation = tz.timeZoneDatabase.locations.values.firstWhere(
          (loc) => loc.currentTimeZone.offset == offset.inMilliseconds,
          orElse: () => tz.getLocation('UTC'),
        );
        tz.setLocalLocation(matchingLocation);
        log('Fallback timezone set to ${matchingLocation.name} with offset $offset');
      } catch (_) {
        tz.setLocalLocation(tz.UTC);
      }
    }

    // 2. Initialization settings for Android, iOS, macOS, Linux
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('ic_notification');

    const DarwinInitializationSettings darwinSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const LinuxInitializationSettings linuxSettings =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
      linux: linuxSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('Foreground notification response received: ${response.actionId}');
        notificationTapBackground(response);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // 3. Create Android notification channel with max priority, alarm sound, and vibration
    if (Platform.isAndroid) {
      final androidNotificationPlugin =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidNotificationPlugin != null) {
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        );

        await androidNotificationPlugin.createNotificationChannel(channel);
      }
    }

    _isInitialized = true;
    log('NotificationService initialized successfully.');
  }

  /// Requests notification permission from the user (Android 13+ and iOS).
  static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        // Request standard notification permission (Android 13+)
        final notifGranted =
            await androidImplementation.requestNotificationsPermission();

        log('Android Notification Permission granted: $notifGranted');
        return notifGranted ?? true;
      }
    } else if (Platform.isIOS) {
      final iosImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      if (iosImplementation != null) {
        final granted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        log('iOS Permissions granted: $granted');
        return granted ?? false;
      }
    } else if (Platform.isMacOS) {
      final macOSImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>();

      if (macOSImplementation != null) {
        final granted = await macOSImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
    }

    return true;
  }

  /// Checks if the app can schedule exact alarms on Android 12+ without throwing SecurityException.
  static Future<bool> canScheduleExactAlarms() async {
    if (Platform.isAndroid) {
      final androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        return await androidImplementation.canScheduleExactNotifications() ?? false;
      }
    }
    return true;
  }

  /// Opens the system settings screen for exact alarm permission on Android 12+.
  static Future<bool> requestExactAlarmsPermission() async {
    if (Platform.isAndroid) {
      final androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        return await androidImplementation.requestExactAlarmsPermission() ?? false;
      }
    }
    return true;
  }

  static const String prefKeyExactAlarmPrompted = 'pref_exact_alarm_prompted';

  /// Checks if exact alarm permission is missing on Android 12+, and if so, shows a polite prompt.
  static Future<bool> checkAndPromptExactAlarms(BuildContext context, {bool forcePrompt = false}) async {
    if (!Platform.isAndroid) return true;

    final canExact = await canScheduleExactAlarms();
    if (canExact) return true;

    final alreadyPrompted = MySharedPref.getBool(prefKeyExactAlarmPrompted) ?? false;
    if (alreadyPrompted && !forcePrompt) {
      return false;
    }

    await MySharedPref.setBool(prefKeyExactAlarmPrompted, true);

    if (!context.mounted) return false;

    final shouldOpen = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.alarm_on_rounded, color: AppColors.primaryColor, size: 26),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Enable Exact Alarms',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: const Text(
          'To ensure you receive on-time reminders before taking your medicine (even when your phone is locked or in battery saving mode), Dosey requires "Alarms & Reminders" permission.\n\nPlease toggle it ON in Settings.',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Not Now', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(ctx, true);
              await requestExactAlarmsPermission();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );

    return shouldOpen ?? false;
  }

  /// Immediately shows an instant notification (for testing & verification).
  static Future<void> showNotificationNow({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      visibility: NotificationVisibility.public,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      category: AndroidNotificationCategory.alarm,
      icon: 'ic_notification',
      ticker: 'Medication Test',
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(android: androidDetails, iOS: darwinDetails),
      payload: payload != null ? jsonEncode(payload) : null,
    );
  }

  /// Schedules a single notification with alarmClock / exact delivery and automatic fallbacks.
  static Future<bool> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required Map<String, dynamic> payload,
    AndroidScheduleMode? preferredMode,
  }) async {
    try {
      if (!areNotificationsEnabled()) {
        if (kDebugMode) {
          log('Skipping scheduleNotification $id ($title): notifications are turned off in settings.');
        }
        return false;
      }

      final now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

      // Verify notification time is in the future.
      // If it is within 1 second of now (e.g. slight delay during 5-second test), push by 3 seconds.
      if (tzDateTime.isBefore(now.add(const Duration(seconds: 1)))) {
        final diff = scheduledDate.difference(DateTime.now());
        if (diff.inSeconds >= -5 && diff.inSeconds <= 2) {
          tzDateTime = now.add(const Duration(seconds: 3));
        } else {
          if (kDebugMode) {
            log('Skipping notification $id ($title): $tzDateTime is in the past.');
          }
          return false;
        }
      }

      final isTest = payload['type'] == 'test' || payload['type'] == 'test_instant';

      final androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
        visibility: NotificationVisibility.public,
        audioAttributesUsage: AudioAttributesUsage.alarm,
        category: AndroidNotificationCategory.alarm,
        icon: 'ic_notification',
        ticker: 'Medication Reminder',
        actions: isTest
            ? null
            : const [
                AndroidNotificationAction(
                  'TAKE_ACTION',
                  'Take',
                  showsUserInterface: false,
                  cancelNotification: true,
                ),
                AndroidNotificationAction(
                  'SKIP_ACTION',
                  'Skip',
                  showsUserInterface: false,
                  cancelNotification: true,
                ),
              ],
      );

      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      // Determine schedule mode: exactAllowWhileIdle is preferred when supported
      final canExact = preferredMode != null
          ? (preferredMode != AndroidScheduleMode.inexactAllowWhileIdle)
          : await canScheduleExactAlarms();

      AndroidScheduleMode mode = preferredMode ??
          (canExact
              ? AndroidScheduleMode.exactAllowWhileIdle
              : AndroidScheduleMode.inexactAllowWhileIdle);

      // 1. Primary schedule attempt
      try {
        await _notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tzDateTime,
          notificationDetails,
          androidScheduleMode: mode,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: jsonEncode(payload),
        );
        log('Scheduled notification ID $id for $tzDateTime (mode=$mode)');
        return true;
      } catch (firstError) {
        log('Schedule with $mode failed ($firstError), attempting fallback...');
      }

      // 2. Fallback attempt: if exact was requested, try alarmClock
      if (canExact && mode != AndroidScheduleMode.alarmClock) {
        try {
          await _notificationsPlugin.zonedSchedule(
            id,
            title,
            body,
            tzDateTime,
            notificationDetails,
            androidScheduleMode: AndroidScheduleMode.alarmClock,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: jsonEncode(payload),
          );
          log('Fallback alarmClock schedule succeeded for notification ID $id');
          return true;
        } catch (alarmError) {
          log('Fallback alarmClock failed ($alarmError), trying inexact...');
        }
      }

      // 3. Guaranteed safe fallback: inexactAllowWhileIdle
      try {
        await _notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tzDateTime,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: jsonEncode(payload),
        );
        log('Guaranteed inexact schedule succeeded for notification ID $id');
        return true;
      } catch (inexactError) {
        log('All scheduling attempts failed for notification $id: $inexactError');
        return false;
      }
    } catch (e, stack) {
      log('Failed to schedule notification $id: $e\n$stack');
      return false;
    }
  }

  /// Reschedules upcoming medicine notifications for the next 7 rolling days.
  /// Cancels all existing notifications first to ensure no orphan or duplicate alarms exist.
  /// Uses event loop yielding and safety caps to guarantee ZERO UI freezing or ANR popups.
  /// Returns the total number of notifications successfully scheduled.
  static Future<int> rescheduleAllActiveMedicines(
      List<MedicineWithSchedules> medicines) async {
    try {
      log('Rescheduling active medicine reminders for ${medicines.length} medicines...');

      // Cancel all current scheduled notifications first
      await _notificationsPlugin.cancelAll();

      if (!areNotificationsEnabled()) {
        log('Notifications are disabled by user. Cleared all reminders.');
        return 0;
      }

      if (medicines.isEmpty) {
        log('No active medicines found to schedule.');
        return 0;
      }

      final now = DateTime.now();
      const lookAheadDays = 7; // Rolling 7-day schedule (safe from Android AlarmManager limits)
      const maxAlarms = 64; // Safety ceiling to strictly avoid exceeding Android OS exact alarm quotas
      int scheduledCount = 0;

      // Check exact alarm permission once up-front instead of on every iteration
      final canExact = await canScheduleExactAlarms();
      final scheduleMode = canExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;

      for (var med in medicines) {
        if (med.schedules.isEmpty) continue;
        if (scheduledCount >= maxAlarms) break;

        for (int dayOffset = 0; dayOffset < lookAheadDays; dayOffset++) {
          if (scheduledCount >= maxAlarms) break;

          final targetDate = DateTime(now.year, now.month, now.day + dayOffset);

          // Fast O(1) date scheduled check
          final isScheduled = ScheduleCalculator.isDateScheduled(
            date: targetDate,
            startDate: med.medicine.startDate,
            endDate: med.medicine.endDate,
            repeatVariation: med.repeatVariationEnum,
            repeatDays: med.medicine.repeatDays,
            weekDays: med.weekDaysList,
            monthDays: med.monthDaysList,
          );

          if (!isScheduled) continue;

          for (final schedule in med.schedules) {
            if (scheduledCount >= maxAlarms) break;

            final scheduledTime = DateTime(
              targetDate.year,
              targetDate.month,
              targetDate.day,
              schedule.hour,
              schedule.minute,
            );

            // Only schedule if the time is in the future
            if (scheduledTime.isAfter(now)) {
              final notificationId = ScheduleCalculator.generateNotificationId(
                med.medicine.id,
                schedule.id,
                scheduledTime,
              );

              final mealTimingText = med.mealTimingEnum == MealTiming.before
                  ? 'Take before meal'
                  : 'Take after meal';

              final success = await scheduleNotification(
                id: notificationId,
                title: 'Time for ${med.medicine.medicineName} 💊',
                body:
                    'Scheduled for ${schedule.timeString} ($mealTimingText) • Take ${ScheduleCalculator.formatDosage(med.medicine.dosage, med.dosageUnitEnum)}',
                scheduledDate: scheduledTime,
                preferredMode: scheduleMode,
                payload: {
                  'medicineId': med.medicine.id,
                  'scheduleId': schedule.id,
                  'medicineName': med.medicine.medicineName,
                  'dosage': med.medicine.dosage,
                  'mealTiming': med.medicine.mealTiming,
                  'scheduledDateTime': scheduledTime.toIso8601String(),
                },
              );

              if (success) {
                scheduledCount++;
              }

              // Yield to event loop on every dose to guarantee zero UI freezing / ANR
              await Future.delayed(const Duration(milliseconds: 10));
            }
          }
        }
      }

      log('Finished rescheduling $scheduledCount notifications for ${medicines.length} medicines.');
      return scheduledCount;
    } catch (e, stack) {
      log('NotificationService: rescheduleAllActiveMedicines failed: $e\n$stack');
      return 0;
    }
  }

  /// Cancels a specific notification by ID.
  static Future<void> cancel(int notificationId) async {
    try {
      await _notificationsPlugin.cancel(notificationId);
    } catch (e) {
      log('NotificationService.cancel failed: $e');
    }
  }

  /// Cancels all notifications.
  static Future<void> cancelAll() async {
    try {
      await _notificationsPlugin.cancelAll();
    } catch (e) {
      log('NotificationService.cancelAll failed: $e');
    }
  }

  /// Returns a list of all currently scheduled pending notifications.
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _notificationsPlugin.pendingNotificationRequests();
    } catch (e) {
      log('NotificationService.getPendingNotifications failed: $e');
      return [];
    }
  }
}
