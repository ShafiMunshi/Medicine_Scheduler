import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/main.dart';
import 'package:medicine_app/models/medicine_model.dart';

class NotificationService {
  static Future<void> sendScheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    Map<String, String>? payload,
  }) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    log("is Notification sending is allowed: $isAllowed");
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'scheduled_channel',
          payload: payload,
          title: title,
          body: body,
          category: NotificationCategory.Reminder,
          notificationLayout: NotificationLayout.Default,
          wakeUpScreen: true,
          fullScreenIntent: false,
          autoDismissible: true,
          backgroundColor: Colors.blue,

          // Custom sound (optional)
          customSound: 'resource://raw/notification_sound',
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'TAKING',
            label: 'Taking',
            color: Colors.green,
            autoDismissible: true,
          ),
          NotificationActionButton(
            key: 'SKIP',
            label: 'Skip Now',
            color: Colors.red,
            autoDismissible: true,
          ),
          NotificationActionButton(
            key: 'SNOOZE',
            label: 'Snooze',
            color: Colors.orange,
            autoDismissible: false,
          ),
        ],
        schedule: NotificationCalendar(
          year: scheduledDate.year,
          month: scheduledDate.month,
          day: scheduledDate.day,
          hour: scheduledDate.hour,
          minute: scheduledDate.minute,
          second: 0,
          millisecond: 0,
          repeats: false,
        ),
      );
    } catch (e) {
      log("Error scheduling notification: $e");
      throw Exception(e);
    }
  }

  static ReceivedAction? initialAction;

  static Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
        null, // Use default app icon
        [
          NotificationChannel(
            channelKey: 'scheduled_channel',
            channelName: 'Scheduled Notifications',
            channelDescription:
                'Channel for scheduled notifications with actions',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
            enableVibration: true,
          ),
        ],
        debug: true);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);

    // Request notification permissions
    await requestNotificationPermissions();

    // Listen for notification actions
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceivedMethod,
      onDismissActionReceivedMethod: _onDismissActionReceivedMethod,
    );
  }

  // Request notification permissions
  static Future<void> requestNotificationPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  @pragma("vm:entry-point")
  static Future<void> _onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    log('Notification ID: ${receivedAction.id}');

    // final int medicineId = int.parse(receivedAction.payload!['medicineId']!);
    // final String scheduled = receivedAction.payload!['scheduledDateTime']!;
    // final int dosage = int.parse(receivedAction.payload!['dosage']!);
    // final String medicineName = receivedAction.payload!['medicineName']!;
    // final bool isSynced = receivedAction.payload!['isSynced'] == 'true';

    // final status = receivedAction.buttonKeyPressed == "TAKING"
    //     ? ConsumptionStatus.taken
    //     : ConsumptionStatus.skipped;

    // final medicineLog = MedicineDraftLog(
    //   isSynced: isSynced,
    //   medicineName: medicineName,
    //   medicineId: medicineId,
    //   scheduledDateTime: DateTime.parse(scheduled),
    //   actualTakenTime: null,
    //   status: status,
    //   dosage: dosage,
    // );

    // switch (receivedAction.buttonKeyPressed) {
    //   case 'TAKING':
    //     log('Taking');
    //     final updatedLog = medicineLog.copyWith(
    //       status: ConsumptionStatus.taken,
    //       actualTakenTime: DateTime.now(),
    //     );
    //     await DraftFileService.updateLog(updatedLog);
    //     break;
    //   case 'SKIP':
    //     log('Skipped');
    //     final updatedLog = medicineLog.copyWith(
    //       status: ConsumptionStatus.skipped,
    //       actualTakenTime: DateTime.now(),
    //     );
    //     // await DraftFileService.updateLog(updatedLog);
    //     break;
    //   case 'SNOOZE':
    //     log('User snoozed the notification');

    //     // Reschedule notification for 5 minutes later
    //     final rescheduledDate = DateTime.now().add(Duration(minutes: 5));
    //     await sendScheduleNotification(
    //         id: receivedAction.id!,
    //         title: receivedAction.title!,
    //         body: "Did you take your medicine?",
    //         scheduledDate: rescheduledDate,
    //         payload: medicineLog.toPayload());
    //     break;
    // }
  }

  /// This method is called when a notification is dismissed
  @pragma("vm:entry-point")
  static Future<void> _onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    log('Notification dismissed: ${receivedAction.id}');
  }

  // Cancel all notifications
  static Future<void> _cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  // Get scheduled notifications
  static Future<void> getScheduledNotifications() async {
    List<NotificationModel> scheduledNotifications =
        await AwesomeNotifications().listScheduledNotifications();

    log('Scheduled notifications: ${scheduledNotifications.length}');
    for (var notification in scheduledNotifications) {
      log('ID: ${notification.content!.id}, Title: ${notification.content!.title}');
    }
  }

  /// this function is used to reschedule all medicine notifications by checking the draft logs which is not taken yet and from current time to next 48 hours
  static Future<void> reschedule_all_medicine_notification_for_next_48_hours(
      List<MedicineModel> medicineLogs) async {
    log("Rescheduling all medicine notifications for next 48 hours");

    final currentTime = DateTime.now();
    final next48Hours = currentTime.add(Duration(hours: 48));

    await _cancelAllNotifications();

    // Analyze all medicine times and create smart notification schedule
    final optimalNotificationTimes =
        _analyzeOptimalNotificationTimes(medicineLogs);

    // Schedule smart reminder notifications for next 2 days
    await _scheduleSmartReminders(optimalNotificationTimes, medicineLogs);

    int idCounter = 1000; // Start with higher ID to avoid conflicts

    for (var mediLog in medicineLogs) {
      final scheduledDateTime = mediLog.finalScheduleDates;
      final scheduleList = mediLog.medicineScheduleList;

      if (scheduledDateTime != null && scheduleList != null) {
        for (var date in scheduledDateTime) {
          // Only schedule for next 48 hours
          if (date.isAfter(currentTime) && date.isBefore(next48Hours)) {
            for (var schedule in scheduleList) {
              if (schedule.timeString != null) {
                final timeParts = schedule.timeString!.split(':');
                if (timeParts.length == 2) {
                  final hour = int.tryParse(timeParts[0]);
                  final minute = int.tryParse(timeParts[1]);

                  if (hour != null && minute != null) {
                    final scheduledTime =
                        DateTime(date.year, date.month, date.day, hour, minute);

                    if (scheduledTime.isAfter(currentTime)) {
                      idCounter++;
                      log("Scheduling medicine notification: ID $idCounter for ${mediLog.medicineName} at $scheduledTime");

                      await sendScheduleNotification(
                        id: idCounter,
                        title: "Time for ${mediLog.medicineName}",
                        body:
                            "It's time to take your ${mediLog.medicineName}. Dosage: ${mediLog.dosage} ${mediLog.dosageUnit.name}",
                        scheduledDate: scheduledTime,
                        payload: {
                          'medicineId': mediLog.id?.toString() ?? '0',
                          'medicineName': mediLog.medicineName,
                          'dosage': mediLog.dosage.toString(),
                          'scheduledDateTime': scheduledTime.toIso8601String(),
                          'dayTimeName': schedule.dayTimeName ?? '',
                        },
                      );
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  /// Analyzes all medicine schedules and determines the best times for general reminders
  static List<TimeOfDay> _analyzeOptimalNotificationTimes(
      List<MedicineModel> medicines) {
    final Map<String, int> timeFrequency = {};

    // Count frequency of each time across all medicines
    for (var medicine in medicines) {
      if (medicine.medicineScheduleList != null) {
        for (var schedule in medicine.medicineScheduleList!) {
          if (schedule.timeString != null) {
            timeFrequency[schedule.timeString!] =
                (timeFrequency[schedule.timeString!] ?? 0) + 1;
          }
        }
      }
    }

    // Sort times by frequency and convert to TimeOfDay
    final sortedTimes = timeFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final optimalTimes = <TimeOfDay>[];

    for (var entry in sortedTimes.take(4)) {
      // Take top 4 most common times
      final timeParts = entry.key.split(':');
      if (timeParts.length == 2) {
        final hour = int.tryParse(timeParts[0]);
        final minute = int.tryParse(timeParts[1]);
        if (hour != null && minute != null) {
          optimalTimes.add(TimeOfDay(hour: hour, minute: minute));
        }
      }
    }

    // If we don't have enough times, add default reminder times
    if (optimalTimes.isEmpty) {
      optimalTimes.addAll([
        const TimeOfDay(hour: 8, minute: 0), // Morning
        const TimeOfDay(hour: 13, minute: 0), // Afternoon
        const TimeOfDay(hour: 18, minute: 0), // Evening
        const TimeOfDay(hour: 21, minute: 0), // Night
      ]);
    } else if (optimalTimes.length < 4) {
      // Fill remaining slots with strategic times
      final defaultTimes = [
        const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 13, minute: 0),
        const TimeOfDay(hour: 18, minute: 0),
        const TimeOfDay(hour: 21, minute: 0),
      ];

      for (var defaultTime in defaultTimes) {
        if (optimalTimes.length >= 4) break;

        // Check if this time is not too close to existing times
        bool tooClose = optimalTimes.any((existingTime) {
          final diff = (existingTime.hour * 60 + existingTime.minute) -
              (defaultTime.hour * 60 + defaultTime.minute);
          return diff.abs() < 120; // Less than 2 hours apart
        });

        if (!tooClose) {
          optimalTimes.add(defaultTime);
        }
      }
    }

    // Sort by time of day
    optimalTimes.sort((a, b) {
      final aMinutes = a.hour * 60 + a.minute;
      final bMinutes = b.hour * 60 + b.minute;
      return aMinutes.compareTo(bMinutes);
    });

    log("Optimal notification times identified: ${optimalTimes.map((t) => '${t.hour}:${t.minute.toString().padLeft(2, '0')}').join(', ')}");

    return optimalTimes;
  }

  /// Schedules smart reminder notifications at optimal times for next 2 days
  static Future<void> _scheduleSmartReminders(
      List<TimeOfDay> optimalTimes, List<MedicineModel> medicines) async {
    final currentTime = DateTime.now();
    final today =
        DateTime(currentTime.year, currentTime.month, currentTime.day);

    int reminderIdStart = 5000; // Use different ID range for reminders

    // Get total count of medicines that user should take
    final activeMedicineCount = medicines
        .where((m) =>
            m.finalScheduleDates != null &&
            m.finalScheduleDates!.any((date) =>
                date.isAfter(currentTime.subtract(Duration(days: 1)))))
        .length;

    // Schedule for today and tomorrow
    for (int dayOffset = 0; dayOffset <= 1; dayOffset++) {
      final targetDate = today.add(Duration(days: dayOffset));

      for (int timeIndex = 0; timeIndex < optimalTimes.length; timeIndex++) {
        final time = optimalTimes[timeIndex];
        final reminderDateTime = DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
          time.hour,
          time.minute,
        );

        // Only schedule future notifications
        if (reminderDateTime.isAfter(currentTime.add(Duration(minutes: 5)))) {
          final reminderId = reminderIdStart + (dayOffset * 10) + timeIndex;

          // Create contextual reminder message
          final timeLabel = _getTimeLabel(time);
          final medicinesDueCount =
              _countMedicinesDueAroundTime(medicines, targetDate, time);

          String reminderTitle;
          String reminderBody;

          if (medicinesDueCount > 0) {
            reminderTitle = "$timeLabel Medicine Reminder";
            reminderBody =
                "You have $medicinesDueCount medicine(s) to take around this time. Don't forget to stay healthy! 💊";
          } else {
            reminderTitle = "Health Check-in";
            reminderBody =
                "How are you feeling $timeLabel? Remember to take your medicines on time! 🌟";
          }

          log("Scheduling smart reminder: ID $reminderId at $reminderDateTime - $reminderTitle");

          await sendScheduleNotification(
            id: reminderId,
            title: reminderTitle,
            body: reminderBody,
            scheduledDate: reminderDateTime,
            payload: {
              'type': 'smart_reminder',
              'timeLabel': timeLabel,
              'medicineCount': activeMedicineCount.toString(),
              'dueCount': medicinesDueCount.toString(),
            },
          );
        }
      }
    }
  }

  /// Gets a friendly label for the time of day
  static String _getTimeLabel(TimeOfDay time) {
    final hour = time.hour;
    if (hour >= 5 && hour < 12) return "Morning";
    if (hour >= 12 && hour < 17) return "Afternoon";
    if (hour >= 17 && hour < 21) return "Evening";
    return "Night";
  }

  /// Counts how many medicines are due within 2 hours of the given time
  static int _countMedicinesDueAroundTime(
      List<MedicineModel> medicines, DateTime date, TimeOfDay targetTime) {
    int count = 0;
    final targetMinutes = targetTime.hour * 60 + targetTime.minute;

    for (var medicine in medicines) {
      if (medicine.finalScheduleDates != null &&
          medicine.medicineScheduleList != null) {
        // Check if medicine is scheduled for this date
        final isScheduledToday = medicine.finalScheduleDates!.any(
            (scheduleDate) =>
                scheduleDate.year == date.year &&
                scheduleDate.month == date.month &&
                scheduleDate.day == date.day);

        if (isScheduledToday) {
          // Check if any medicine time is within 2 hours of target time
          for (var schedule in medicine.medicineScheduleList!) {
            if (schedule.timeString != null) {
              final timeParts = schedule.timeString!.split(':');
              if (timeParts.length == 2) {
                final hour = int.tryParse(timeParts[0]);
                final minute = int.tryParse(timeParts[1]);
                if (hour != null && minute != null) {
                  final scheduleMinutes = hour * 60 + minute;
                  final timeDiff = (scheduleMinutes - targetMinutes).abs();

                  // Within 2 hours (120 minutes)
                  if (timeDiff <= 120) {
                    count++;
                    break; // Count each medicine only once per reminder time
                  }
                }
              }
            }
          }
        }
      }
    }

    return count;
  }

  ///  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************
  ///
  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = MyApp.navigatorKey.currentContext!;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/animated-bell.gif',
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                    'Allow Awesome Notifications to send you beautiful notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Allow',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  )),
            ],
          );
        });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}
