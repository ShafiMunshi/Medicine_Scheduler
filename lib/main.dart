import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicine_app/data/repository/auth_repository.dart';
import 'package:medicine_app/data/repository/consume_repository.dart';
import 'package:medicine_app/data/repository/medicine_repository.dart';
import 'package:medicine_app/data/source/local_db_source.dart';
import 'package:medicine_app/data/source/my_shared_pref.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodels.dart';
import 'package:medicine_app/routes.dart';
import 'package:medicine_app/screens/top_screen_view.dart';
import 'package:medicine_app/viewmodels/schedule_viewmodels.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  runApp(MyApp(
    localDbService: localDbService,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.localDbService, super.key});
  final LocalDatabaseService localDbService;

  // This widget is the root of your application.
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
              create: (context) => ScheduleViewmodels(context.read())),
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
                  home: TopScreenView(),
                  // home: CountdownWithProgress( initialDuration: Duration(hours: 1),),
                  routes: app_routes,
                )));
  }
}
