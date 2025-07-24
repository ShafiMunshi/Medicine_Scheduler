import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/data/source/my_shared_pref.dart';
import 'package:medicine_app/models/medicine_consumption_model.dart';
import 'package:medicine_app/models/medicine_draft_log_model.dart';
import 'dart:developer';

class NotificationService {
  static Future<void> sendScheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    Map<String, String>? payload,
  }) async {
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
  }

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

    final int medicineId = int.parse(receivedAction.payload!['medicineId']!);
    final String scheduled = receivedAction.payload!['scheduledDateTime']!;
    final int dosage = int.parse(receivedAction.payload!['dosage']!);

    final status = receivedAction.buttonKeyPressed == "TAKING"
        ? ConsumptionStatus.taken
        : ConsumptionStatus.skipped;

    final medicineLog = MedicineDraftLog(
      medicineId: medicineId,
      scheduledDateTime: DateTime.parse(scheduled),
      actualTakenTime: DateTime.now(),
      status: status,
      dosageTaken: dosage,
    );

    switch (receivedAction.buttonKeyPressed) {
      case 'TAKING':
        log('Taking');
        await MySharedPref.saveDraftMedicineLogs(medicineLog);
        break;
      case 'SKIP':
        log('Skipped');
        await MySharedPref.saveDraftMedicineLogs(medicineLog);
        break;
      case 'SNOOZE':
        log('User snoozed the notification');

        // Reschedule notification for 5 minutes later
        final rescheduledDate = DateTime.now().add(Duration(minutes: 5));
        await sendScheduleNotification(
            id: receivedAction.id!,
            title: receivedAction.title!,
            body: "Did you take your medicine?",
            scheduledDate: rescheduledDate,
            payload: medicineLog.toPayload());
        break;
    }
  }

  /// This method is called when a notification is dismissed
  @pragma("vm:entry-point")
  static Future<void> _onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    log('Notification dismissed: ${receivedAction.id}');
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
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
}
