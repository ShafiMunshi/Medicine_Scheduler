import 'dart:developer';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/models/user_profile_model.dart';
import 'package:medicine_app/viewmodels/auth_viewmodel.dart';
import 'package:medicine_app/viewmodels/database_providers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

final userProfileProvider = FutureProvider<User?>((ref) async {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getUser();
});

final userProfileStreamProvider = StreamProvider<User?>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.watchUser();
});

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<void>>((ref) {
  return ProfileController(ref);
});

class ProfileController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  ProfileController(this.ref) : super(const AsyncValue.data(null));

  Future<void> updateProfileImage(XFile file) async {
    state = const AsyncValue.loading();
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final ext = p.extension(file.path);
      final newPath = p.join(appDir.path, 'profile_${DateTime.now().millisecondsSinceEpoch}$ext');
      await File(file.path).copy(newPath);

      final repo = ref.read(userRepositoryProvider);
      await repo.updateProfileImage(newPath);

      // Also sync avatar to Firestore if user is authenticated
      final fbUser = ref.read(currentFirebaseUserProvider);
      if (fbUser != null) {
        final firestore = ref.read(firestoreServiceProvider);
        final existing = await firestore.getUserProfile(fbUser.uid);
        if (existing != null) {
          await firestore.saveUserProfile(existing.copyWith(avatarUrl: newPath));
        }
      }

      ref.invalidate(userProfileProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      log('Error updating profile image: $e\n$st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setAvatarPreset(String avatarKey) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.updateProfileImage(avatarKey);

      final fbUser = ref.read(currentFirebaseUserProvider);
      if (fbUser != null) {
        final firestore = ref.read(firestoreServiceProvider);
        final existing = await firestore.getUserProfile(fbUser.uid);
        if (existing != null) {
          await firestore.saveUserProfile(existing.copyWith(avatarUrl: avatarKey));
        }
      }

      ref.invalidate(userProfileProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      log('Error setting avatar preset: $e\n$st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> saveFullProfile({
    required String name,
    required String gender,
    required int age,
    double? weight,
    double? height,
    String? avatarUrl,
    String? bloodGroup,
    String? allergies,
    String? chronicConditions,
    String? emergencyContact,
    String role = 'patient',
  }) async {
    state = const AsyncValue.loading();
    try {
      final fbUser = ref.read(currentFirebaseUserProvider);
      final firestore = ref.read(firestoreServiceProvider);
      final repo = ref.read(userRepositoryProvider);

      String? linkingCode;
      if (fbUser != null) {
        final existing = await firestore.getUserProfile(fbUser.uid);
        linkingCode = existing?.linkingCode ?? firestore.generateLinkingCode();

        final profile = UserProfileModel(
          uid: fbUser.uid,
          name: name,
          email: fbUser.email,
          gender: gender,
          age: age,
          weight: weight,
          height: height,
          avatarUrl: avatarUrl,
          bloodGroup: bloodGroup,
          allergies: allergies,
          chronicConditions: chronicConditions,
          emergencyContact: emergencyContact,
          role: role,
          linkingCode: linkingCode,
          isProfileCompleted: true,
          linkedParentUids: existing?.linkedParentUids ?? const [],
          monitoredPatientUids: existing?.monitoredPatientUids ?? const [],
        );

        await firestore.saveUserProfile(profile);
      }

      // Save to Drift local database
      await repo.syncFromProfileModel(
        UsersCompanion(
          name: Value(name),
          gender: Value(gender),
          age: Value(age),
          weight: Value(weight),
          height: Value(height),
          bloodGroup: Value(bloodGroup),
          allergies: Value(allergies),
          chronicConditions: Value(chronicConditions),
          emergencyContact: Value(emergencyContact),
          imagePath: avatarUrl != null ? Value(avatarUrl) : const Value.absent(),
          role: Value(role),
          linkingCode: linkingCode != null ? Value(linkingCode) : const Value.absent(),
          firebaseUid: fbUser != null ? Value(fbUser.uid) : const Value.absent(),
          isProfileCompleted: const Value(true),
        ),
      );

      ref.invalidate(userProfileProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      log('Error saving full profile: $e\n$st');
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateProfileInfo({
    required String name,
    required int age,
    String? gender,
    String? email,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.saveUser(
        UsersCompanion(
          name: Value(name),
          age: Value(age),
          gender: Value(gender),
          email: Value(email),
        ),
      );
      ref.invalidate(userProfileProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      log('Error updating profile info: $e\n$st');
      state = AsyncValue.error(e, st);
    }
  }
}
