import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:medicine_app/core/utils/schedule_calculator.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/data/repositories/medicine_log_repository.dart';
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

  static const String _channelId = 'medicine_reminders';
  static const String _channelName = 'Medicine Reminders';
  static const String _channelDescription =
      'Notifications for scheduled medicine intake';

  static bool _isInitialized = false;

  /// Initializes timezone data, notification channels, and platform settings.
  static Future<void> initialize() async {
    if (_isInitialized) return;

    // 1. Initialize timezone database
    tz.initializeTimeZones();
    try {
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
      log('Timezone initialized to: $currentTimeZone');
    } catch (e) {
      log('Could not obtain device local timezone, defaulting to UTC: $e');
      tz.setLocalLocation(tz.UTC);
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

    // 3. Create Android notification channel
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
        );

        await androidNotificationPlugin.createNotificationChannel(channel);
      }
    }

    _isInitialized = true;
    log('NotificationService initialized successfully.');
  }

  /// Requests notification and exact alarm permissions from the user.
  static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        // Request standard notification permission (Android 13+)
        final notifGranted =
            await androidImplementation.requestNotificationsPermission();

        // Request exact alarm permission (Android 12+)
        final exactGranted =
            await androidImplementation.requestExactAlarmsPermission();

        log('Android Permissions: notifications=$notifGranted, exactAlarms=$exactGranted');
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
        log('macOS Permissions granted: $granted');
        return granted ?? false;
      }
    }

    return true;
  }

  /// Checks/requests exact alarm permission on this device (Android 12+).
  static Future<bool> canScheduleExactAlarms() async {
    if (Platform.isAndroid) {
      final androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        return await androidImplementation.requestExactAlarmsPermission() ?? true;
      }
    }
    return true;
  }

  /// Schedules a single exact notification.
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

      final androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        category: AndroidNotificationCategory.reminder,
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

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDateTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: jsonEncode(payload),
      );

      if (kDebugMode) {
        log('Scheduled notification ID $id for $scheduledDate ($title)');
      }
    } catch (e, stack) {
      log('Failed to schedule notification $id: $e\n$stack');
    }
  }

  /// Reschedules all upcoming medicine notifications for the next 7 days.
  /// Cancels all existing notifications first to ensure no orphan or duplicate alarms exist.
  static Future<void> rescheduleAllActiveMedicines(
      List<MedicineWithSchedules> medicines) async {
    try {
      log('Rescheduling all active medicine reminders for ${medicines.length} medicines...');

      // Cancel all current scheduled notifications
      await _notificationsPlugin.cancelAll();

      final now = DateTime.now();
      final lookAheadDays = 7; // Schedule 7 days ahead offline

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

              await scheduleNotification(
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
            }
          }
        }
      }

      log('Finished rescheduling notifications.');
    } catch (e) {
      log('NotificationService: rescheduleAllActiveMedicines skipped or failed (likely test environment): $e');
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
