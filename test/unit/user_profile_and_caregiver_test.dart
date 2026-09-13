import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_app/models/user_profile_model.dart';
import 'package:medicine_app/service/firestore_service.dart';

void main() {
  group('UserProfileModel serialization & deserialization', () {
    test('toMap and fromMap preserves all fields correctly', () {
      final original = UserProfileModel(
        uid: 'user_12345',
        name: 'Jane Doe',
        email: 'jane@example.com',
        gender: 'Female',
        age: 32,
        weight: 58.5,
        height: 165.0,
        avatarUrl: 'avatar_doctor_f',
        bloodGroup: 'B+',
        allergies: 'Penicillin, Peanuts',
        chronicConditions: 'Asthma',
        emergencyContact: 'John Doe: +1 555-0199',
        role: 'patient',
        linkingCode: 'MED-AB12CD',
        isProfileCompleted: true,
        linkedParentUids: ['parent_999'],
        monitoredPatientUids: [],
        updatedAt: DateTime(2026, 9, 14, 10, 0),
      );

      final map = original.toMap();
      final restored = UserProfileModel.fromMap(map, docId: 'user_12345');

      expect(restored.uid, 'user_12345');
      expect(restored.name, 'Jane Doe');
      expect(restored.email, 'jane@example.com');
      expect(restored.gender, 'Female');
      expect(restored.age, 32);
      expect(restored.weight, 58.5);
      expect(restored.height, 165.0);
      expect(restored.avatarUrl, 'avatar_doctor_f');
      expect(restored.bloodGroup, 'B+');
      expect(restored.allergies, 'Penicillin, Peanuts');
      expect(restored.chronicConditions, 'Asthma');
      expect(restored.emergencyContact, 'John Doe: +1 555-0199');
      expect(restored.role, 'patient');
      expect(restored.linkingCode, 'MED-AB12CD');
      expect(restored.isProfileCompleted, isTrue);
      expect(restored.linkedParentUids, ['parent_999']);
    });

    test('toUsersCompanion maps fields correctly for Drift', () {
      final profile = UserProfileModel(
        uid: 'fb_abc',
        name: 'Alex',
        email: 'alex@test.com',
        gender: 'Male',
        age: 28,
        weight: 72.0,
        height: 178.0,
        bloodGroup: 'O+',
        isProfileCompleted: true,
      );

      final companion = profile.toUsersCompanion();
      expect(companion.name.value, 'Alex');
      expect(companion.firebaseUid.value, 'fb_abc');
      expect(companion.gender.value, 'Male');
      expect(companion.age.value, 28);
      expect(companion.weight.value, 72.0);
      expect(companion.height.value, 178.0);
      expect(companion.bloodGroup.value, 'O+');
      expect(companion.isProfileCompleted.value, isTrue);
    });
  });

  group('PatientDailyStatus & Dose serialization', () {
    test('Correctly serializes and deserializes daily caregiver dose status', () {
      final doses = [
        const PatientMedicineDoseStatus(
          scheduleId: 1,
          medicineName: 'Amoxicillin',
          dosage: '500 mg',
          dayTimeName: 'Morning',
          timeString: '08:00',
          status: 'taken',
          actualTakenTime: '08:05 AM',
        ),
        const PatientMedicineDoseStatus(
          scheduleId: 2,
          medicineName: 'Vitamin D',
          dosage: '1000 IU',
          dayTimeName: 'Noon',
          timeString: '13:00',
          status: 'missed',
        ),
      ];

      final daily = PatientDailyStatus(
        patientUid: 'child_123',
        patientName: 'Tommy',
        dateString: '2026-09-14',
        totalScheduled: 2,
        totalTaken: 1,
        totalMissed: 1,
        totalPending: 0,
        adherenceRate: 50.0,
        doses: doses,
        lastUpdated: DateTime(2026, 9, 14, 14, 0),
      );

      final map = daily.toMap();
      final restored = PatientDailyStatus.fromMap(map);

      expect(restored.patientUid, 'child_123');
      expect(restored.patientName, 'Tommy');
      expect(restored.totalScheduled, 2);
      expect(restored.totalTaken, 1);
      expect(restored.totalMissed, 1);
      expect(restored.adherenceRate, 50.0);
      expect(restored.doses.length, 2);
      expect(restored.doses[0].medicineName, 'Amoxicillin');
      expect(restored.doses[0].status, 'taken');
      expect(restored.doses[0].actualTakenTime, '08:05 AM');
      expect(restored.doses[1].medicineName, 'Vitamin D');
      expect(restored.doses[1].status, 'missed');
    });
  });

  group('FirestoreService linking code generation', () {
    test('Generates valid 6-char linking code starting with MED-', () {
      final service = FirestoreService();
      final code = service.generateLinkingCode();

      expect(code.startsWith('MED-'), isTrue);
      expect(code.length, 10); // 'MED-' (4) + 6 chars = 10
      // Ensure code contains only uppercase letters and digits
      final codeSuffix = code.substring(4);
      expect(RegExp(r'^[A-Z0-9]{6}$').hasMatch(codeSuffix), isTrue);
    });

    test('Two generated linking codes are unique', () {
      final service = FirestoreService();
      final code1 = service.generateLinkingCode();
      final code2 = service.generateLinkingCode();

      expect(code1, isNot(equals(code2)));
    });
  });
}
