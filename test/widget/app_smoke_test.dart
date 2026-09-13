import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/screens/top_screen_view.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodel.dart';
import 'package:medicine_app/viewmodels/profile_viewmodel.dart';
import 'package:medicine_app/viewmodels/schedule_viewmodel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TopScreenView renders and navigates through tabs', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allMedicinesProvider.overrideWith((ref) => Stream.value(<MedicineWithSchedules>[])),
          todayMedicinesProvider.overrideWithValue(<MedicineWithSchedules>[]),
          userProfileProvider.overrideWith((ref) => Future.value(null)),
          todayLogsProvider.overrideWith((ref) => Stream.value(<MedicineLog>[])),
          logsForScheduleDateProvider.overrideWith((ref) => Stream.value(<MedicineLog>[])),
          allLogsProvider.overrideWith((ref) => Future.value(<MedicineLog>[])),
        ],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, child) => const MaterialApp(
            home: TopScreenView(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify bottom navigation items exist
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Medicine'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // Tap on 'Medicine' tab
    await tester.tap(find.text('Medicine'));
    await tester.pumpAndSettle();

    // Tap on 'Schedule' tab
    await tester.tap(find.text('Schedule'));
    await tester.pumpAndSettle();

    // Tap on 'Settings' tab
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    // Tap back to 'Home' tab
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    tester.view.resetPhysicalSize();
  });
}
