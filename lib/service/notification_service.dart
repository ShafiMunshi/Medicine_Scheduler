import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
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

  static const String _channelId = 'medicine_reminders_v2';
  static const String _channelName = 'Medication Reminders';
  static const String _channelDescription =
      'Important alarms and notifications for scheduled medications';

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
        AndroidInitializationSettings('@mipmap/launcher_icon');

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

    // 3. Create Android notification channel with max priority and alarm sound
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

  /// Immediately shows an instant notification (for testing & verification).
  static Future<void> showNotificationNow({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      visibility: NotificationVisibility.public,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      category: AndroidNotificationCategory.reminder,
      icon: '@mipmap/launcher_icon',
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
      NotificationDetails(android: androidDetails, iOS: darwinDetails),
      payload: payload != null ? jsonEncode(payload) : null,
    );
  }

  /// Schedules a single notification with automatic fallback to inexact alarms
  /// if exact alarms are not permitted on the device.
  static Future<bool> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required Map<String, dynamic> payload,
  }) async {
    try {
      if (!areNotificationsEnabled()) {
        if (kDebugMode) {
          log('Skipping scheduleNotification $id ($title): notifications are turned off in settings.');
        }
        return false;
      }

      final now = tz.TZDateTime.now(tz.local);
      final tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

      // Verify notification time is in the future
      if (tzDateTime.isBefore(now)) {
        if (kDebugMode) {
          log('Skipping notification $id ($title): $tzDateTime is in the past.');
        }
        return false;
      }

      final androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        visibility: NotificationVisibility.public,
        audioAttributesUsage: AudioAttributesUsage.alarm,
        category: AndroidNotificationCategory.reminder,
        icon: '@mipmap/launcher_icon',
        actions: const [
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

      // Determine initial schedule mode based on device capability
      final canExact = await canScheduleExactAlarms();
      AndroidScheduleMode mode = canExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;

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
      } catch (scheduleError) {
        log('Exact schedule failed ($scheduleError), retrying with inexactAllowWhileIdle fallback...');
        // Fallback to inexactAllowWhileIdle ensures the notification is NEVER dropped
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
        log('Fallback inexact schedule succeeded for notification ID $id');
        return true;
      }
    } catch (e, stack) {
      log('Failed to schedule notification $id: $e\n$stack');
      return false;
    }
  }

  /// Reschedules all upcoming medicine notifications for the next 30 days.
  /// Cancels all existing notifications first to ensure no orphan or duplicate alarms exist.
  /// Returns the total number of notifications successfully scheduled.
  static Future<int> rescheduleAllActiveMedicines(
      List<MedicineWithSchedules> medicines) async {
    try {
      log('Rescheduling all active medicine reminders for ${medicines.length} medicines...');

      // Cancel all current scheduled notifications
      await _notificationsPlugin.cancelAll();

      if (!areNotificationsEnabled()) {
        log('Notifications are disabled by user. Cleared all reminders.');
        return 0;
      }

      final now = DateTime.now();
      final lookAheadDays = 30; // Schedule 30 days ahead offline
      int scheduledCount = 0;

      for (var med in medicines) {
        final scheduleDates = ScheduleCalculator.calculateScheduledDates(
          startDate: med.medicine.startDate,
          endDate: med.medicine.endDate,
          repeatVariation: med.repeatVariationEnum,
          repeatDays: med.medicine.repeatDays,
          weekDays: med.weekDaysList,
          monthDays: med.monthDaysList,
        );

        if (scheduleDates.isEmpty || med.schedules.isEmpty) continue;

        for (int dayOffset = 0; dayOffset < lookAheadDays; dayOffset++) {
          final targetDate = DateTime(now.year, now.month, now.day + dayOffset);

          // Check if this date is part of the medicine's scheduled dates
          final isScheduledToday = scheduleDates.any((d) =>
              d.year == targetDate.year &&
              d.month == targetDate.month &&
              d.day == targetDate.day);

          if (!isScheduledToday) continue;

          for (final schedule in med.schedules) {
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

              final success = await scheduleNotification(
                id: notificationId,
                title: 'Time for ${med.medicine.medicineName}',
                body:
                    'Take ${ScheduleCalculator.formatDosage(med.medicine.dosage, med.dosageUnitEnum)} (${med.mealTimingEnum.displayName})',
                scheduledDate: scheduledTime,
                payload: {
                  'medicineId': med.medicine.id,
                  'scheduleId': schedule.id,
                  'medicineName': med.medicine.medicineName,
                  'dosage': med.medicine.dosage,
                  'scheduledDateTime': scheduledTime.toIso8601String(),
                },
              );
              if (success) {
                scheduledCount++;
              }
            }
          }
        }
      }

      log('Finished rescheduling $scheduledCount notifications for ${medicines.length} medicines.');
      return scheduledCount;
    } catch (e) {
      log('NotificationService: rescheduleAllActiveMedicines skipped or failed: $e');
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
