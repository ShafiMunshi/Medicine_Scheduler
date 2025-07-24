import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/config/custom/custom_snackber.dart';
import 'package:medicine_app/data/source/my_shared_pref.dart';
import 'package:medicine_app/screens/top_screen_view.dart';
import 'package:medicine_app/test_logs.dart';
import 'package:nb_utils/nb_utils.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  // Initialize awesome notifications
  void initializeNotifications() async {
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
    );

    // Request notification permissions
    await requestNotificationPermissions();

    // Listen for notification actions
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  // Request notification permissions
  Future<void> requestNotificationPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  // Schedule notification with action buttons
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'scheduled_channel',
        title: title,
        body: body,
        category: NotificationCategory.Reminder,
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,

        fullScreenIntent: false,
        autoDismissible: true,
        backgroundColor: Colors.orange,
        // Custom sound (optional)
        customSound: 'resource://raw/notification_sound',
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'ACCEPT',
          label: 'Accept',
          color: Colors.green,
          autoDismissible: true,
        ),
        NotificationActionButton(
          key: 'REJECT',
          label: 'Reject',
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

  // Schedule repeating notification

  @pragma("vm:entry-point")
  // Handle notification actions
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    log('Action received: ${receivedAction.actionType}');
    log('Button key: ${receivedAction.buttonKeyPressed}');
    log('Notification ID: ${receivedAction.id}');

     final shred_pref = await SharedPreferences.getInstance();

    switch (receivedAction.buttonKeyPressed) {
      case 'ACCEPT':
        log('User accepted the notification');

        await shred_pref.setString("test", "Accepted Notification");

        // Handle accept action
        break;
      case 'REJECT':

        await shred_pref.setString("test", "rejected Notification");

        log('User rejected the notification');

        // Handle reject action
        break;
      case 'SNOOZE':
        log('User snoozed the notification');

        // Reschedule notification for 5 minutes later
      
        break;
      case 'COMPLETE':

        // Cancel repeating notification
        await AwesomeNotifications().cancel(receivedAction.id!);
        break;
      case 'POSTPONE':
        log('User postponed the task');
        // Handle postpone action
        break;
    }
  }

  // Snooze notification helper
  // static Future<void> _snoozeNotification(int notificationId) async {
  //   DateTime snoozeTime = DateTime.now().add(Duration(minutes: 5));

  //   await AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: notificationId,
  //       channelKey: 'scheduled_channel',
  //       title: 'Snoozed Reminder',
  //       body: 'This is your snoozed notification',
  //       wakeUpScreen: true,
  //     ),
  //     actionButtons: [
  //       NotificationActionButton(
  //         key: 'ACCEPT',
  //         label: 'Accept',
  //         color: Colors.green,
  //         autoDismissible: true,
  //       ),
  //       NotificationActionButton(
  //         key: 'SNOOZE',
  //         label: 'Snooze Again',
  //         color: Colors.orange,
  //         autoDismissible: false,
  //       ),
  //     ],
  //     schedule: NotificationCalendar.fromDate(date: snoozeTime),
  //   );
  // }

  @pragma("vm:entry-point")
  // Notification lifecycle callbacks
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    log('Notification created: ${receivedNotification.id}');
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    log('Notification displayed: ${receivedNotification.id}');
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    log('Notification dismissed: ${receivedAction.id}');
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  // Get scheduled notifications
  Future<void> getScheduledNotifications() async {
    List<NotificationModel> scheduledNotifications =
        await AwesomeNotifications().listScheduledNotifications();

    log('Scheduled notifications: ${scheduledNotifications.length}');
    for (var notification in scheduledNotifications) {
      log(
          'ID: ${notification.content!.id}, Title: ${notification.content!.title}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduled Notifications'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Schedule notification for 5 seconds from now
                DateTime scheduledTime =
                    DateTime.now().add(Duration(seconds: 5));
                scheduleNotification(
                  id: 1,
                  title: 'Meeting Reminder',
                  body: 'You have a meeting in 5 minutes',
                  scheduledDate: scheduledTime,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Notification scheduled for 5 seconds!')),
                );
              },
              child: Text('Schedule Notification (5 sec)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Schedule notification for specific date/time
                DateTime scheduledTime =
                    DateTime.now().add(Duration(minutes: 1));
                scheduleNotification(
                  id: 2,
                  title: 'Task Reminder',
                  body: 'Don\'t forget to complete your task!',
                  scheduledDate: scheduledTime,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Task reminder scheduled for 1 minute!')),
                );
              },
              child: Text('Schedule Task Reminder (1 min)'),
            ),
            SizedBox(height: 16),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => cancelNotification(3),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text('Cancel Repeating Reminder'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: cancelAllNotifications,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Cancel All Notifications'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: getScheduledNotifications,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Show Scheduled Notifications'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TopScreenView()));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Go to application'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TestLogs()));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Show all Isar test logs '),
            ),
            ElevatedButton(
              onPressed: () async {
                final data =await MySharedPref.getValue("test");
                CustomSnackBar.showCustomToast(message: "data: $data");
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Show all Shared Pref test logs '),
            ),
          ],
        ),
      ),
    );
  }
}
