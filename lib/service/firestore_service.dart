import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:medicine_app/models/user_profile_model.dart';

class FirestoreService {
  final FirebaseFirestore? _customFirestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _customFirestore = firestore;

  FirebaseFirestore get _firestore => _customFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCol =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _linkingCodesCol =>
      _firestore.collection('linking_codes');

  CollectionReference<Map<String, dynamic>> get _patientStatusesCol =>
      _firestore.collection('patient_statuses');

  /// Save or update user profile in Firestore
  Future<void> saveUserProfile(UserProfileModel profile) async {
    try {
      await _usersCol.doc(profile.uid).set(
            profile.toMap(),
            SetOptions(merge: true),
          );

      // If linking code is present, register in linking_codes directory
      if (profile.linkingCode != null && profile.linkingCode!.isNotEmpty) {
        await _linkingCodesCol.doc(profile.linkingCode!.toUpperCase()).set({
          'patientUid': profile.uid,
          'patientName': profile.name,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('Error saving user profile to Firestore: $e');
      rethrow;
    }
  }

  /// Fetch user profile once
  Future<UserProfileModel?> getUserProfile(String uid) async {
    try {
      final doc = await _usersCol.doc(uid).get();
      if (!doc.exists || doc.data() == null) return null;
      return UserProfileModel.fromMap(doc.data()!, docId: doc.id);
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      return null;
    }
  }

  /// Watch user profile in real-time
  Stream<UserProfileModel?> watchUserProfile(String uid) {
    return _usersCol.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      return UserProfileModel.fromMap(snapshot.data()!, docId: snapshot.id);
    });
  }

  /// Generates a unique 6-character linking code (e.g. MED-7K9A2B)
  String generateLinkingCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // omit ambiguous 0, 1, I, O
    final random = Random();
    final randomPart =
        List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
    return 'MED-$randomPart';
  }

  /// Link a parent to a patient using the 6-character linking code
  Future<UserProfileModel> linkParentToPatient({
    required String parentUid,
    required String linkingCode,
  }) async {
    final cleanCode = linkingCode.trim().toUpperCase();

    // 1. Check linking codes collection
    final codeDoc = await _linkingCodesCol.doc(cleanCode).get();
    String? patientUid;

    if (codeDoc.exists && codeDoc.data() != null) {
      patientUid = codeDoc.data()!['patientUid'] as String?;
    } else {
      // Fallback: query users directly
      final query = await _usersCol
          .where('linkingCode', isEqualTo: cleanCode)
          .limit(1)
          .get();
      if (query.docs.isNotEmpty) {
        patientUid = query.docs.first.id;
      }
    }

    if (patientUid == null || patientUid.isEmpty) {
      throw Exception('Invalid linking code. Please ask the patient to share their correct code from Settings.');
    }

    if (patientUid == parentUid) {
      throw Exception('You cannot link yourself as a caregiver.');
    }

    // 2. Update patient document to add parentUid
    await _usersCol.doc(patientUid).update({
      'linkedParentUids': FieldValue.arrayUnion([parentUid]),
    });

    // 3. Update parent document to add patientUid
    await _usersCol.doc(parentUid).set({
      'role': 'parent',
      'monitoredPatientUids': FieldValue.arrayUnion([patientUid]),
    }, SetOptions(merge: true));

    // 4. Return patient's profile
    final patientProfile = await getUserProfile(patientUid);
    if (patientProfile == null) {
      throw Exception('Patient profile not found.');
    }
    return patientProfile;
  }

  /// Unlink parent from patient
  Future<void> unlinkParentFromPatient({
    required String parentUid,
    required String patientUid,
  }) async {
    await _usersCol.doc(patientUid).update({
      'linkedParentUids': FieldValue.arrayRemove([parentUid]),
    });
    await _usersCol.doc(parentUid).update({
      'monitoredPatientUids': FieldValue.arrayRemove([patientUid]),
    });
  }

  /// Get list of profiles for monitored patients
  Future<List<UserProfileModel>> getProfilesByUids(List<String> uids) async {
    if (uids.isEmpty) return [];
    try {
      final List<UserProfileModel> profiles = [];
      for (final uid in uids) {
        final profile = await getUserProfile(uid);
        if (profile != null) profiles.add(profile);
      }
      return profiles;
    } catch (e) {
      debugPrint('Error fetching profiles by UIDs: $e');
      return [];
    }
  }

  /// Stream list of monitored patient profiles
  Stream<List<UserProfileModel>> watchMonitoredPatients(String parentUid) {
    return _usersCol.doc(parentUid).snapshots().asyncMap((doc) async {
      if (!doc.exists || doc.data() == null) return <UserProfileModel>[];
      final uids = (doc.data()!['monitoredPatientUids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      return await getProfilesByUids(uids);
    });
  }

  /// Sync patient's daily medication status so caregivers can monitor adherence
  Future<void> syncDailyStatus(PatientDailyStatus status) async {
    try {
      final docId = '${status.patientUid}_${status.dateString}';
      await _patientStatusesCol.doc(docId).set(
            status.toMap(),
            SetOptions(merge: true),
          );
    } catch (e) {
      debugPrint('Error syncing daily status to Firestore: $e');
    }
  }

  /// Watch patient's daily status in real-time (for caregiver live dashboard)
  Stream<PatientDailyStatus?> watchPatientDailyStatus({
    required String patientUid,
    required String dateString,
  }) {
    final docId = '${patientUid}_$dateString';
    return _patientStatusesCol.doc(docId).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      return PatientDailyStatus.fromMap(snapshot.data()!);
    });
  }
}
