import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medicine_app/models/user_profile_model.dart';
import 'package:medicine_app/viewmodels/auth_viewmodel.dart';
import 'package:medicine_app/viewmodels/database_providers.dart';

/// Stream of patients monitored by the current user (if current user is a caregiver/parent)
final monitoredPatientsProvider = StreamProvider<List<UserProfileModel>>((ref) {
  final user = ref.watch(currentFirebaseUserProvider);
  if (user == null) return Stream.value([]);
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.watchMonitoredPatients(user.uid);
});

/// Stream of a patient's daily status on a given date (e.g. today 'yyyy-MM-dd')
final patientDailyStatusFamily =
    StreamProvider.family<PatientDailyStatus?, ({String patientUid, String dateString})>(
  (ref, arg) {
    final firestore = ref.watch(firestoreServiceProvider);
    return firestore.watchPatientDailyStatus(
      patientUid: arg.patientUid,
      dateString: arg.dateString,
    );
  },
);

/// State notifier for caregiver operations (linking, unlinking, syncing daily status)
final caregiverControllerProvider =
    StateNotifierProvider<CaregiverController, AsyncValue<void>>((ref) {
  return CaregiverController(ref);
});

class CaregiverController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  CaregiverController(this.ref) : super(const AsyncValue.data(null));

  /// Link a child/patient by code
  Future<UserProfileModel> linkPatient(String linkingCode) async {
    state = const AsyncValue.loading();
    try {
      final user = ref.read(currentFirebaseUserProvider);
      if (user == null) {
        throw Exception('Please sign in first to link a patient.');
      }
      final firestore = ref.read(firestoreServiceProvider);
      final patient = await firestore.linkParentToPatient(
        parentUid: user.uid,
        linkingCode: linkingCode,
      );
      state = const AsyncValue.data(null);
      return patient;
    } catch (e, st) {
      log('Error linking patient: $e\n$st');
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Unlink a child/patient
  Future<void> unlinkPatient(String patientUid) async {
    state = const AsyncValue.loading();
    try {
      final user = ref.read(currentFirebaseUserProvider);
      if (user == null) return;
      final firestore = ref.read(firestoreServiceProvider);
      await firestore.unlinkParentFromPatient(
        parentUid: user.uid,
        patientUid: patientUid,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      log('Error unlinking patient: $e\n$st');
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Sync local user's daily status to Firestore for caregivers
  Future<void> syncTodayStatusToFirestore([DateTime? date]) async {
    try {
      final user = ref.read(currentFirebaseUserProvider);
      if (user == null) return; // not logged in, no need to sync to cloud

      final targetDate = date ?? DateTime.now();
      final dateString = DateFormat('yyyy-MM-dd').format(targetDate);

      final medRepo = ref.read(medicineRepositoryProvider);
      final logRepo = ref.read(medicineLogRepositoryProvider);
      final userRepo = ref.read(userRepositoryProvider);

      final localUser = await userRepo.getUser();
      final patientName = localUser?.name ?? user.displayName ?? 'Patient';

      final medicines = await medRepo.getAllMedicines();
      final dayLogs = await logRepo.getLogsForDate(targetDate);

      final List<PatientMedicineDoseStatus> doses = [];
      int totalTaken = 0;
      int totalMissed = 0;
      int totalPending = 0;

      for (final med in medicines) {
        for (final sch in med.schedules) {
          // Find log for this schedule on targetDate
          final log = dayLogs.where((l) => l.scheduleId == sch.id).firstOrNull;

          String status = 'pending';
          String? takenTime;

          if (log != null) {
            if (log.status == 'taken') {
              status = 'taken';
              totalTaken++;
              if (log.actualTakenTime != null) {
                takenTime = DateFormat('hh:mm a').format(log.actualTakenTime!);
              }
            } else if (log.status == 'missed' || log.status == 'skipped') {
              status = 'missed';
              totalMissed++;
            }
          } else {
            // Check if schedule time has passed today
            final now = DateTime.now();
            final isToday = targetDate.year == now.year &&
                targetDate.month == now.month &&
                targetDate.day == now.day;
            if (isToday) {
              final schTime = DateTime(
                now.year,
                now.month,
                now.day,
                sch.hour,
                sch.minute,
              );
              if (now.isAfter(schTime.add(const Duration(minutes: 60)))) {
                // More than an hour late with no log -> missed
                status = 'missed';
                totalMissed++;
              } else {
                status = 'pending';
                totalPending++;
              }
            } else if (targetDate.isBefore(DateTime(now.year, now.month, now.day))) {
              status = 'missed';
              totalMissed++;
            } else {
              status = 'pending';
              totalPending++;
            }
          }

          doses.add(
            PatientMedicineDoseStatus(
              scheduleId: sch.id,
              medicineName: med.medicine.medicineName,
              dosage: '${med.medicine.dosage} ${med.medicine.dosageUnit}',
              dayTimeName: sch.dayTimeName,
              timeString: sch.timeString,
              status: status,
              actualTakenTime: takenTime,
            ),
          );
        }
      }

      final totalScheduled = doses.length;
      final adherenceRate =
          totalScheduled > 0 ? (totalTaken / totalScheduled) * 100.0 : 100.0;

      final dailyStatus = PatientDailyStatus(
        patientUid: user.uid,
        patientName: patientName,
        dateString: dateString,
        totalScheduled: totalScheduled,
        totalTaken: totalTaken,
        totalMissed: totalMissed,
        totalPending: totalPending,
        adherenceRate: adherenceRate,
        doses: doses,
        lastUpdated: DateTime.now(),
      );

      final firestore = ref.read(firestoreServiceProvider);
      await firestore.syncDailyStatus(dailyStatus);
    } catch (e) {
      log('Caregiver status sync exception: $e');
    }
  }
}
