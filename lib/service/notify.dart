// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:isar/isar.dart';
// import 'package:medicine_app/models/medicine_consumption_model.dart';
// import 'package:medicine_app/models/medicine_model.dart';
// import 'package:path_provider/path_provider.dart';

// class MedicineNotificationService {
//   static bool _isInitialized = false;
//   Isar? isar;

//   // Initialize both Isar database and Awesome Notifications
//   static Future<void> initialize(Isar? isar) async {
//     if (_isInitialized) return;

//     // Initialize Isar database if it's not already initialized
//     if (isar == null) {
//       final dir = await getApplicationDocumentsDirectory();
//       Isar.initializeIsarCore();
//       isar = await Isar.open(
//         [MedicineModelSchema, MedicineConsumeLogModelSchema],
//         directory: dir.path,
//       );
//     }

//     // Initialize Awesome Notifications
//     await _initializeNotifications();

//     _isInitialized = true;
//   }

//   static Future<void> _initializeNotifications() async {
//     await AwesomeNotifications().initialize(
//       'resource://drawable/ic_launcher', // App icon
//       [
//         NotificationChannel(
//           channelKey: 'medicine_alerts',
//           channelName: 'Medicine Alerts',
//           channelDescription: 'Notifications for medicine reminders',
//           defaultColor: Color(0xFF9D50DD),
//           ledColor: Colors.white,
//           importance: NotificationImportance.High,
//           channelShowBadge: true,
//           onlyAlertOnce: true,
//           playSound: true,
//           criticalAlerts: true,
//         ),
//         NotificationChannel(
//           channelKey: 'medicine_taken',
//           channelName: 'Medicine Taken',
//           channelDescription: 'Confirmation when medicine is taken',
//           defaultColor: Color(0xFF4CAF50),
//           ledColor: Colors.green,
//           importance: NotificationImportance.Low,
//           channelShowBadge: false,
//           playSound: false,
//         ),
//       ],
//     );

//     // Set up notification listeners
//     _setupNotificationListeners();
//   }

//   static void _setupNotificationListeners() {
//     // Listen for notification actions
//     AwesomeNotifications().setListeners(
//       onActionReceivedMethod: onActionReceivedMethod,
//       onNotificationCreatedMethod: onNotificationCreatedMethod,
//       onNotificationDisplayedMethod: onNotificationDisplayedMethod,
//       onDismissActionReceivedMethod: onDismissActionReceivedMethod,
//     );
//   }

//   // Handle notification actions (button clicks)
//   @pragma("vm:entry-point")
//   static Future<void> onActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     final payload = receivedAction.payload;

//     if (receivedAction.buttonKeyPressed == 'TAKING') {
//       await _handleMedicineTaken(payload);
//     } else if (receivedAction.buttonKeyPressed == 'SHOW_ALL') {
//       await _handleShowAll(payload);
//     } else if (receivedAction.buttonKeyPressed == 'SNOOZE') {
//       await _handleSnooze(payload);
//     }
//   }

//   @pragma("vm:entry-point")
//   static Future<void> onNotificationCreatedMethod(
//       ReceivedNotification receivedNotification) async {
//     // Handle notification created
//     debugPrint('Notification created: ${receivedNotification.id}');
//   }

//   @pragma("vm:entry-point")
//   static Future<void> onNotificationDisplayedMethod(
//       ReceivedNotification receivedNotification) async {
//     // Handle notification displayed
//     debugPrint('Notification displayed: ${receivedNotification.id}');
//   }

//   @pragma("vm:entry-point")
//   static Future<void> onDismissActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     // Handle notification dismissed
//     debugPrint('Notification dismissed: ${receivedAction.id}');
//   }

//   // TODO: on the last moment , check this properly working
//   // Handle "Taking" button click
//   static Future<void> _handleMedicineTaken(
//       Map<String, String?>? payload) async {
//     if (payload == null) return;

//     final medicineId = int.tryParse(payload['medicineId'] ?? '');
//     final scheduleId = int.tryParse(payload['scheduleId'] ?? '');
//     final scheduledTime = DateTime.tryParse(payload['scheduledTime'] ?? '');
//     final medicineName = payload['medicineName'] ?? '';

//     if (medicineId != null && scheduleId != null && scheduledTime != null) {
//       // Create intake record
//       // final intake = MedicineIntake(
//       //   medicineId: medicineId,
//       //   scheduleId: scheduleId,
//       //   scheduledTime: scheduledTime,
//       //   isTaken: true,
//       // );
//       // intake.takenTime = DateTime.now();

//       // await _isar!.writeTxn(() async {
//       //   await _isar!.medicineIntakes.put(intake);
//       // });

//       // Show confirmation notification
//       await _showConfirmationNotification(medicineName);
//     }
//   }

//   // Handle "Show All" button click
//   static Future<void> _handleShowAll(Map<String, String?>? payload) async {
//     // This will open the app - you can handle navigation in your main app
//     // by listening to the notification action in your main widget
//   }

//   // Handle snooze (5-minute delay)
//   static Future<void> _handleSnooze(Map<String, String?>? payload) async {
//     if (payload == null) return;

//     final medicineId = int.tryParse(payload['medicineId'] ?? '');
//     final medicineName = payload['medicineName'] ?? '';
//     final dosage = payload['dosage'] ?? '';

//     if (medicineId != null) {
//       // Schedule snooze notification
//       await _scheduleSnoozeNotification(
//         medicineId: medicineId,
//         medicineName: medicineName,
//         dosage: dosage,
//       );
//     }
//   }

//   // Request permissions
//   static Future<bool> requestPermissions() async {
//     return await AwesomeNotifications().isNotificationAllowed();
//   }

//   static Future<void> requestNotificationPermissions() async {
//     await AwesomeNotifications().requestPermissionToSendNotifications();
//   }

//   // Schedule notifications for all active medicine schedules
//   Future<void> scheduleAllMedicineNotifications() async {
//     // await _initializeDatabase();

//     // Cancel all existing notifications first
//     await AwesomeNotifications().cancelAll();

//     // Get all active medicines with their schedules
//     final medicines = await isar!.medicineModels.where().findAll();

//     for (final medicine in medicines) {
//       await medicine.schedules.load();

//       for (final schedule in medicine.schedules) {
//         if (schedule.isActive) {
//           await _scheduleNotificationForSchedule(medicine, schedule);
//         }
//       }
//     }
//   }

//   // Schedule notification for a specific schedule
//   static Future<void> _scheduleNotificationForSchedule(
//       Medicine medicine, MedicineSchedule schedule) async {
//     // Schedule for each day of the week
//     for (final dayOfWeek in schedule.daysOfWeek) {
//       final notificationId =
//           _generateNotificationId(medicine.id, schedule.id, dayOfWeek);

//       await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: notificationId,
//           channelKey: 'medicine_alerts',
//           title: '💊 Medicine Reminder',
//           body: 'Time to take ${medicine.name} (${medicine.dosage})',
//           bigPicture: 'asset://assets/medicine_reminder.png',
//           notificationLayout: NotificationLayout.BigPicture,
//           payload: {
//             'medicineId': medicine.id.toString(),
//             'scheduleId': schedule.id.toString(),
//             'medicineName': medicine.name,
//             'dosage': medicine.dosage,
//             'scheduledTime':
//                 _getNextScheduledTime(schedule, dayOfWeek).toIso8601String(),
//           },
//           wakeUpScreen: true,
//           criticalAlert: true,
//         ),
//         actionButtons: [
//           NotificationActionButton(
//             key: 'TAKING',
//             label: '✅ Taking',
//             color: Colors.green,
//             autoDismissible: true,
//           ),
//           NotificationActionButton(
//             key: 'SNOOZE',
//             label: '⏰ Snooze 5min',
//             color: Colors.orange,
//             autoDismissible: false,
//           ),
//           NotificationActionButton(
//             key: 'SHOW_ALL',
//             label: '📋 Show All',
//             color: Colors.blue,
//             autoDismissible: false,
//           ),
//         ],
//         schedule: NotificationCalendar(
//           weekday: dayOfWeek,
//           hour: schedule.hour,
//           minute: schedule.minute,
//           second: 0,
//           repeats: true,
//         ),
//       );
//     }
//   }

//   // Generate unique notification ID
//   static int _generateNotificationId(
//       int medicineId, int scheduleId, int dayOfWeek) {
//     return int.parse('$medicineId$scheduleId$dayOfWeek');
//   }

//   // Get next scheduled time for a specific day
//   static DateTime _getNextScheduledTime(
//       MedicineSchedule schedule, int dayOfWeek) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);

//     // Calculate days until the target day
//     final currentDayOfWeek = now.weekday;
//     int daysUntilTarget = dayOfWeek - currentDayOfWeek;

//     if (daysUntilTarget < 0) {
//       daysUntilTarget += 7;
//     } else if (daysUntilTarget == 0) {
//       // Same day - check if time has passed
//       final scheduledTime = DateTime(
//           now.year, now.month, now.day, schedule.hour, schedule.minute);

//       if (scheduledTime.isBefore(now)) {
//         daysUntilTarget = 7; // Next week
//       }
//     }

//     return today
//         .add(Duration(days: daysUntilTarget))
//         .add(Duration(hours: schedule.hour, minutes: schedule.minute));
//   }

//   // Schedule snooze notification
//   static Future<void> _scheduleSnoozeNotification({
//     required int medicineId,
//     required String medicineName,
//     required String dosage,
//   }) async {
//     final snoozeTime = DateTime.now().add(Duration(minutes: 5));

//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: medicineId + 1000000, // Unique ID for snooze
//         channelKey: 'medicine_alerts',
//         title: '💊 Medicine Reminder (Snoozed)',
//         body: 'Time to take $medicineName ($dosage)',
//         payload: {
//           'medicineId': medicineId.toString(),
//           'medicineName': medicineName,
//           'dosage': dosage,
//           'scheduledTime': snoozeTime.toIso8601String(),
//         },
//         wakeUpScreen: true,
//         criticalAlert: true,
//       ),
//       actionButtons: [
//         NotificationActionButton(
//           key: 'TAKING',
//           label: '✅ Taking',
//           color: Colors.green,
//           autoDismissible: true,
//         ),
//         NotificationActionButton(
//           key: 'SHOW_ALL',
//           label: '📋 Show All',
//           color: Colors.blue,
//           autoDismissible: false,
//         ),
//       ],
//       schedule: NotificationCalendar.fromDate(date: snoozeTime),
//     );
//   }

//   // Show confirmation notification
//   static Future<void> _showConfirmationNotification(String medicineName) async {
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: DateTime.now().millisecondsSinceEpoch,
//         channelKey: 'medicine_taken',
//         title: '✅ Medicine Taken',
//         body: 'You have successfully taken $medicineName',
//         notificationLayout: NotificationLayout.Default,
//         autoDismissible: true,
//       ),
//     );
//   }

//   // Add or update medicine schedule
//   static Future<void> addMedicineSchedule({
//     required String medicineName,
//     required String dosage,
//     required String description,
//     required List<MedicineSchedule> schedules,
//   }) async {
//     await _initializeDatabase();

//     final medicine = Medicine(
//       name: medicineName,
//       dosage: dosage,
//       description: description,
//     );

//     await _isar!.writeTxn(() async {
//       await _isar!.medicines.put(medicine);

//       // Add schedules
//       for (final schedule in schedules) {
//         schedule.medicineId = medicine.id;
//         await _isar!.medicineSchedules.put(schedule);
//         medicine.schedules.add(schedule);
//       }

//       await medicine.schedules.save();
//     });

//     // Reschedule all notifications
//     await scheduleAllMedicineNotifications();
//   }

//   // Cancel specific medicine notifications
//   static Future<void> cancelMedicineNotifications(int medicineId) async {
//     // await _initializeDatabase();

//     final medicine = await _isar!.medicines.get(medicineId);
//     if (medicine != null) {
//       await medicine.schedules.load();

//       for (final schedule in medicine.schedules) {
//         for (final dayOfWeek in schedule.daysOfWeek) {
//           final notificationId =
//               _generateNotificationId(medicineId, schedule.id, dayOfWeek);
//           await AwesomeNotifications().cancel(notificationId);
//         }
//       }
//     }
//   }

//   // Cancel all notifications
//   static Future<void> cancelAllNotifications() async {
//     await AwesomeNotifications().cancelAll();
//   }

//   // Get pending notifications
//   static Future<List<NotificationModel>> getPendingNotifications() async {
//     return await AwesomeNotifications().listScheduledNotifications();
//   }
// }
