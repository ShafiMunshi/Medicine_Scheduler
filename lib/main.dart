import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicine_app/repository/auth/auth_repository.dart';
import 'package:medicine_app/routes.dart';
import 'package:medicine_app/screens/top_screen_view.dart';
import 'package:medicine_app/viewmodels/viewmodels_auth.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    // statusBarColor: Colors.white, // status bar color
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthRepository>(create: (_) => AuthRepository()),
          ChangeNotifierProvider<AuthViewModels>(
              create: (_) => AuthViewModels(context.read())),
          // ChangeNotifierProvider<AuthViewModels>(
          //     create: (_) => AuthViewModels(context.read())),
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
