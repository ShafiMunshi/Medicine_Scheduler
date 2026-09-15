import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_app/models/user_profile_model.dart';
import 'package:medicine_app/service/auth_service.dart';
import 'package:medicine_app/service/firestore_service.dart';
import 'package:medicine_app/viewmodels/database_providers.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final authStateProvider = StreamProvider<fb.User?>((ref) {
  final auth = ref.watch(authServiceProvider);
  return auth.authStateChanges;
});

final currentFirebaseUserProvider = Provider<fb.User?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

final currentProfileStreamProvider = StreamProvider<UserProfileModel?>((ref) {
  final user = ref.watch(currentFirebaseUserProvider);
  if (user == null) return Stream.value(null);
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.watchUserProfile(user.uid);
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<fb.User?>>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AsyncValue<fb.User?>> {
  final Ref ref;

  AuthController(this.ref) : super(const AsyncValue.data(null));

  AuthService get _auth => ref.read(authServiceProvider);
  FirestoreService get _firestore => ref.read(firestoreServiceProvider);

  Future<fb.User?> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final cred = await _auth.signInWithGoogle();
      if (cred == null) {
        state = const AsyncValue.data(null);
        return null;
      }
      final user = cred.user;
      if (user != null) {
        await _syncProfileOnAuthSuccess(user);
      }
      state = AsyncValue.data(user);
      return user;
    } catch (e, st) {
      log('Google Sign-In Error: $e\n$st');
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<fb.User?> signInWithApple() async {
    state = const AsyncValue.loading();
    try {
      final cred = await _auth.signInWithApple();
      if (cred == null) {
        state = const AsyncValue.data(null);
        return null;
      }
      final user = cred.user;
      if (user != null) {
        await _syncProfileOnAuthSuccess(user);
      }
      state = AsyncValue.data(user);
      return user;
    } catch (e, st) {
      log('Apple Sign-In Error: $e\n$st');
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<fb.User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final cred = await _auth.signInWithEmail(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user != null) {
        await _syncProfileOnAuthSuccess(user);
      }
      state = AsyncValue.data(user);
      return user;
    } catch (e, st) {
      log('Email Sign-In Error: $e\n$st');
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<fb.User?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncValue.loading();
    try {
      final cred = await _auth.signUpWithEmail(
        email: email,
        password: password,
        displayName: name,
      );
      final user = cred.user;
      if (user != null) {
        await _syncProfileOnAuthSuccess(user, initialName: name);
      }
      state = AsyncValue.data(user);
      return user;
    } catch (e, st) {
      log('Email Sign-Up Error: $e\n$st');
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _auth.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      log('Sign-Out Error: $e\n$st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> _syncProfileOnAuthSuccess(
    fb.User user, {
    String? initialName,
  }) async {
    try {
      var profile = await _firestore.getUserProfile(user.uid);
      if (profile == null) {
        final code = _firestore.generateLinkingCode();
        profile = UserProfileModel(
          uid: user.uid,
          name: (initialName ?? user.displayName ?? 'User').trim().isEmpty
              ? 'User'
              : (initialName ?? user.displayName ?? 'User'),
          email: user.email,
          avatarUrl: user.photoURL,
          linkingCode: code,
          isProfileCompleted: false,
        );
        await _firestore.saveUserProfile(profile);
      }

      // Sync into local Drift database
      final userRepo = ref.read(userRepositoryProvider);
      await userRepo.syncFromProfileModel(profile.toUsersCompanion());
    } catch (e) {
      debugPrint('Profile sync error: $e');
    }
  }
}
