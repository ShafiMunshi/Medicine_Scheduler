import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medicine_app/models/adherence_summary.dart';
import 'package:medicine_app/screens/home/widget/monthly_adherence_chart.dart';
import 'package:medicine_app/viewmodels/schedule_viewmodel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MonthlyAdherenceChart shows done icon above date and missed count below date', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;

    final targetMonth = DateTime(2025, 3, 1);
    final daysInMonth = 31;

    // Build mock summaries:
    // Day 4: 2 scheduled, 2 taken, 0 missed -> isAllTaken = true
    // Day 10: 3 scheduled, 1 taken, 2 missed -> isMissed = true (missedCount = 2)
    final dailySummaries = List.generate(daysInMonth, (index) {
      final day = index + 1;
      final date = DateTime(2025, 3, day);

      if (day == 4) {
        return DayAdherenceSummary(
          date: date,
          totalScheduled: 2,
          takenCount: 2,
          missedCount: 0,
        );
      } else if (day == 10) {
        return DayAdherenceSummary(
          date: date,
          totalScheduled: 3,
          takenCount: 1,
          missedCount: 2,
        );
      } else {
        return DayAdherenceSummary(
          date: date,
          totalScheduled: 0,
          takenCount: 0,
          missedCount: 0,
        );
      }
    });

    final mockStats = MonthAdherenceStats(
      month: targetMonth,
      totalDaysInMonth: daysInMonth,
      daysWithSchedule: 2,
      perfectDaysCount: 1,
      missedDaysCount: 1,
      totalScheduledDoses: 5,
      totalTakenDoses: 3,
      totalMissedDoses: 2,
      adherencePercentage: 60.0,
      dailySummaries: dailySummaries,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeSelectedMonthProvider.overrideWith((ref) => targetMonth),
          monthlyAdherenceStatsProvider.overrideWithValue(mockStats),
        ],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, child) => const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: MonthlyAdherenceChart(),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Month header
    expect(find.text('March 2025'), findsOneWidget);

    // Verify weekday labels
    expect(find.text('Mon'), findsOneWidget);
    expect(find.text('Tue'), findsOneWidget);
    expect(find.text('Sun'), findsOneWidget);

    // Verify Day 4 has the done tick icon above the date
    expect(find.byIcon(Iconsax.tick_circle), findsWidgets);

    // Verify Day 10 has the missed count '2' and close icon below the date
    expect(find.text('2'), findsWidgets);
    expect(find.byIcon(Iconsax.close_circle), findsWidgets);

    // Tap on Day 10 to inspect
    await tester.tap(find.text('10').first);
    await tester.pumpAndSettle();

    // Verify inspection card displays details
    expect(find.textContaining('Monday, March 10, 2025'), findsOneWidget);
    expect(find.textContaining('2 Missed (1/3 Taken)'), findsOneWidget);
  });
}
