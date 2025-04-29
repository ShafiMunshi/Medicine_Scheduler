import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicine_app/app/data/repository/auth_repository.dart';
import 'package:medicine_app/app/data/repository/medicine_repository.dart';
import 'package:medicine_app/app/data/source/db_service_isar.dart';
import 'package:medicine_app/app/data/source/db_service_sqflite.dart';
import 'package:medicine_app/app/data/source/my_shared_pref.dart';
import 'package:medicine_app/app/viewmodels/medicine_viewmodels.dart';
import 'package:medicine_app/routes.dart';
import 'package:medicine_app/app/screens/top_screen_view.dart';
import 'package:medicine_app/app/viewmodels/viewmodels_auth.dart';
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
  await LocalDatabaseService().init();
  // await LocalDatabaseService().clear();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<LocalDatabaseService>(
              create: (context) => LocalDatabaseService()),
          Provider<AuthRepository>(create: (context) => AuthRepository()),
          Provider<MedicineRepository>(
              create: (context) => MedicineRepository(context.read())),
          ChangeNotifierProvider<AuthViewModels>(
              create: (context) => AuthViewModels(context.read())),
          ChangeNotifierProvider<MedicineViewmodels>(
              create: (context) => MedicineViewmodels(context.read())),
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
                  // home:TopScreenView()
                  home: TopScreenView(),
                  routes: app_routes,
                )));
  }
}
