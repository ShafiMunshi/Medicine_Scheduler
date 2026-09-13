import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/models/domain_models.dart';
import 'package:medicine_app/screens/auth/auth_gate.dart';
import 'package:medicine_app/screens/auth/sign_in_page.dart';
import 'package:medicine_app/screens/profile/user_profile_setup_view.dart';
import 'package:medicine_app/screens/top_screen_view.dart';
import 'package:medicine_app/viewmodels/auth_viewmodel.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodel.dart';
import 'package:medicine_app/viewmodels/profile_viewmodel.dart';
import 'package:medicine_app/viewmodels/schedule_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseUser extends Mock implements fb.User {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('AuthGate shows SignWithEmailInScreen when unauthenticated (no guest mode allowed)', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(null)),
          userProfileStreamProvider.overrideWith((ref) => Stream.value(null)),
          allMedicinesProvider.overrideWith((ref) => Stream.value(<MedicineWithSchedules>[])),
          todayMedicinesProvider.overrideWithValue(<MedicineWithSchedules>[]),
          todayLogsProvider.overrideWith((ref) => Stream.value(<MedicineLog>[])),
          logsForScheduleDateProvider.overrideWith((ref) => Stream.value(<MedicineLog>[])),
          allLogsProvider.overrideWith((ref) => Future.value(<MedicineLog>[])),
        ],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, child) => const MaterialApp(
            home: AuthGate(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Must show Sign In screen
    expect(find.byType(SignWithEmailInScreen), findsOneWidget);
    // Guest mode button must NOT exist
    expect(find.text('Continue Offline as Guest'), findsNothing);
    // Cannot directly access TopScreenView
    expect(find.byType(TopScreenView), findsNothing);
  });

  testWidgets('AuthGate forces UserProfileSetupView when profile is incomplete', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;

    final mockUser = MockFirebaseUser();
    when(() => mockUser.uid).thenReturn('user_123');
    when(() => mockUser.email).thenReturn('user@example.com');
    when(() => mockUser.displayName).thenReturn('User 123');

    final incompleteDriftUser = User(
      id: 1,
      name: 'User 123',
      age: 25,
      role: 'patient',
      isProfileCompleted: false,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(mockUser)),
          userProfileStreamProvider.overrideWith((ref) => Stream.value(incompleteDriftUser)),
          userProfileProvider.overrideWith((ref) => Future.value(incompleteDriftUser)),
          allMedicinesProvider.overrideWith((ref) => Stream.value(<MedicineWithSchedules>[])),
          todayMedicinesProvider.overrideWithValue(<MedicineWithSchedules>[]),
          todayLogsProvider.overrideWith((ref) => Stream.value(<MedicineLog>[])),
          logsForScheduleDateProvider.overrideWith((ref) => Stream.value(<MedicineLog>[])),
          allLogsProvider.overrideWith((ref) => Future.value(<MedicineLog>[])),
        ],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, child) => const MaterialApp(
            home: AuthGate(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Must show UserProfileSetupView for initial onboarding
    expect(find.byType(UserProfileSetupView), findsOneWidget);
    expect(find.text('Complete Profile'), findsOneWidget);
    expect(find.byType(TopScreenView), findsNothing);
  });

  testWidgets('AuthGate routes to TopScreenView when authenticated and profile completed', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;

    final mockUser = MockFirebaseUser();
    when(() => mockUser.uid).thenReturn('user_123');
    when(() => mockUser.email).thenReturn('user@example.com');
    when(() => mockUser.displayName).thenReturn('Jane Doe');

    final completedDriftUser = User(
      id: 1,
      name: 'Jane Doe',
      age: 28,
      role: 'patient',
      gender: 'Female',
      isProfileCompleted: true,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(mockUser)),
          userProfileStreamProvider.overrideWith((ref) => Stream.value(completedDriftUser)),
          userProfileProvider.overrideWith((ref) => Future.value(completedDriftUser)),
          allMedicinesProvider.overrideWith((ref) => Stream.value(<MedicineWithSchedules>[])),
          todayMedicinesProvider.overrideWithValue(<MedicineWithSchedules>[]),
          todayLogsProvider.overrideWith((ref) => Stream.value(<MedicineLog>[])),
          logsForScheduleDateProvider.overrideWith((ref) => Stream.value(<MedicineLog>[])),
          allLogsProvider.overrideWith((ref) => Future.value(<MedicineLog>[])),
        ],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, child) => const MaterialApp(
            home: AuthGate(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Must route to TopScreenView
    expect(find.byType(TopScreenView), findsOneWidget);
    expect(find.byType(SignWithEmailInScreen), findsNothing);
  });
}
