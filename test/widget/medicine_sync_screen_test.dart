import 'package:drift/native.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/screens/sync/medicine_sync_screen.dart';
import 'package:medicine_app/viewmodels/auth_viewmodel.dart';
import 'package:medicine_app/viewmodels/database_providers.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseUser extends Mock implements fb.User {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late MockFirebaseUser mockUser;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    mockUser = MockFirebaseUser();
    when(() => mockUser.uid).thenReturn('user_sync_test');
    when(() => mockUser.email).thenReturn('sync@example.com');
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('MedicineSyncScreen renders initial sync loading state', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          currentFirebaseUserProvider.overrideWithValue(mockUser),
        ],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, child) => const MaterialApp(
            home: MedicineSyncScreen(isFromSettings: true),
          ),
        ),
      ),
    );

    // Initial frame
    await tester.pump();

    // Verify title and loading elements exist
    expect(find.text('Cloud Medicine Sync'), findsOneWidget);
    expect(find.byType(MedicineSyncScreen), findsOneWidget);
  });
}
