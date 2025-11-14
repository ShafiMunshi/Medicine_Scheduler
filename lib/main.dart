import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicine_app/data/repository/auth_repository.dart';
import 'package:medicine_app/data/repository/consume_repository.dart';
import 'package:medicine_app/data/repository/medicine_repository.dart';
import 'package:medicine_app/data/source/local_db_source.dart';
import 'package:medicine_app/data/source/my_shared_pref.dart';
import 'package:medicine_app/routes.dart';
import 'package:medicine_app/service/notification_service.dart';
// import 'package:medicine_app/service/notification_service.dart.';
import 'package:medicine_app/test_page.dart';
import 'package:medicine_app/viewmodels/home_viewmodels.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodels.dart';
// import 'package:medicine_app/screens/top_screen_view.dart';
import 'package:medicine_app/viewmodels/schedule_viewmodels.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager().registerPeriodicTask(
    "periodic-task-identifier",
    "NotificationRescheduleTask",
    initialDelay: const Duration(seconds: 30),
    frequency: const Duration(minutes: 15),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    // statusBarColor: Colors.white, // status bar color
  ));

  await MySharedPref.init();

  final localDbService = LocalDatabaseService();
  await localDbService.init();

  // Always initialize Awesome Notifications
  await NotificationService.initializeNotifications();

  runApp(MyApp(
    localDbService: localDbService,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.localDbService, super.key});
  final LocalDatabaseService localDbService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          /// Provide the LocalDatabaseService
          ChangeNotifierProvider<LocalDatabaseService>.value(
              value: localDbService),

          Provider<AuthRepository>(create: (context) => AuthRepository()),

          /// ProxyProvider: Inject LocalDatabaseService into MedicineRepository
          ProxyProvider<LocalDatabaseService, MedicineRepository>(
              update: (_, localDb, __) => MedicineRepository(localDb)),

          /// ProxyProvider: Inject LocalDatabaseService into MedicineConsumedRepository
          ProxyProvider<LocalDatabaseService, MedicineConsumeRepository>(
              update: (_, localDb, __) => MedicineConsumeRepository(localDb)),

          ChangeNotifierProvider<MedicineViewmodels>(
              create: (context) => MedicineViewmodels(context.read())),

          ChangeNotifierProvider<ScheduleViewmodels>(
              create: (context) =>
                  ScheduleViewmodels(context.read(), context.read())),
          ChangeNotifierProvider<HomeViewmodels>(
              create: (context) => HomeViewmodels()),
        ],
        child: ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Medicine Tracker',
                  theme: ThemeData(
                    textTheme: GoogleFonts.lexendTextTheme(
                      Theme.of(context).textTheme,
                    ),
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                    useMaterial3: true,
                  ),
                  // home: TopScreenView(),
                  home: NotificationScreen(),
                  // home: NotificationScreen(),

                  routes: app_routes,
                )));
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    log(" background task: $task"); //simpleTask will be emitted here.

    await NotificationService
        .reschedule_all_medicine_notification_for_next_48_hours();
    return Future.value(true);
  });
}


// TODO: add / modify data in draft logs based on 
/// - when the medicine is first time created.  (done)
/// - when the medicine consume log is updated or reverted then we need to make changes into the draft logs (done)
/// - when the medicine is deleted then we need to remove the draft logs related to that medicine (done)
/// - when the medicine is modified ( schedule, dosage, time ) then we need to update the draft logs related to that medicine (done)

// TODO: reschedule in splash screen, workmanager, adding / modifying medicine, modify medicine consume log (done)

// TODO: when user first time open the app, read the draft logs and insert medicine consume logs which medicine was taken and then  (done in top_screen_view.dart)


// TODO: check if there is any recursive isSynced issue when updating the draft logs and medicine consume logs.
/// - when the medicine is marked as taken from the then it synced. 
/// - when the medicine is marked from draft logs then it synced.