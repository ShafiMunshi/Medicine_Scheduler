import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/data/source/my_shared_pref.dart';
import 'package:medicine_app/screens/settings/settings_view.dart';
import 'package:medicine_app/service/notification_service.dart';
import 'package:medicine_app/viewmodels/profile_viewmodel.dart';
import 'package:medicine_app/widgets/user_avatar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await MySharedPref.init();
  });

  group('UserAvatarWidget Tests', () {
    testWidgets('renders preset emoji for avatar_male_1', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserAvatarWidget(
              avatarPath: 'avatar_male_1',
              radius: 30,
            ),
          ),
        ),
      );

      expect(find.text('👨'), findsOneWidget);
    });

    testWidgets('renders preset emoji for avatar_doctor_f', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserAvatarWidget(
              avatarPath: 'avatar_doctor_f',
              radius: 30,
            ),
          ),
        ),
      );

      expect(find.text('👩‍⚕️'), findsOneWidget);
    });

    testWidgets('renders fallback widget when avatarPath is null or empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserAvatarWidget(
              avatarPath: null,
              radius: 30,
            ),
          ),
        ),
      );

      expect(find.byType(ClipOval), findsOneWidget);
    });
  });

  group('Notification Preferences Tests', () {
    test('areNotificationsEnabled defaults to true', () {
      expect(NotificationService.areNotificationsEnabled(), isTrue);
    });

    test('setNotificationsEnabled updates preference correctly', () async {
      await NotificationService.setNotificationsEnabled(false);
      expect(NotificationService.areNotificationsEnabled(), isFalse);

      await NotificationService.setNotificationsEnabled(true);
      expect(NotificationService.areNotificationsEnabled(), isTrue);
    });
  });

  group('SettingsView Widget Tests', () {
    testWidgets('renders modern settings view with notification switch', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (_, __) => ProviderScope(
            overrides: [
              userProfileProvider.overrideWith(
                (ref) async => const User(
                  id: 1,
                  name: 'Shafi Munshi',
                  age: 24,
                  isProfileCompleted: true,
                  role: 'patient',
                ),
              ),
            ],
            child: const MaterialApp(
              home: SettingsView(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Medication Reminders'), findsOneWidget);
      expect(find.text('Health Profile & Details'), findsOneWidget);
      expect(find.text('Caregiver & Family Supervision'), findsOneWidget);
      expect(find.text('All Medication Logs'), findsOneWidget);
      expect(find.text('Privacy & Data Protection'), findsOneWidget);
      expect(find.text('Rate This App'), findsOneWidget);

      // Verify switch is present
      expect(find.byType(Switch), findsOneWidget);
    });
  });
}
