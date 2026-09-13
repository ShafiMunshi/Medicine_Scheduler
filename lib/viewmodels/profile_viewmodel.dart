import 'dart:developer';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/viewmodels/database_providers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

final userProfileProvider = FutureProvider<User?>((ref) async {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getUser();
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

      ref.invalidate(userProfileProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      log('Error updating profile image: $e\n$st');
      state = AsyncValue.error(e, st);
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
