import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_app/screens/auth/sign_in_page.dart';
import 'package:medicine_app/screens/profile/user_profile_setup_view.dart';
import 'package:medicine_app/screens/top_screen_view.dart';
import 'package:medicine_app/viewmodels/auth_viewmodel.dart';
import 'package:medicine_app/viewmodels/profile_viewmodel.dart';

/// AuthGate strictly enforces mandatory authentication.
/// No guest or unauthenticated access is allowed.
/// If unauthenticated -> SignWithEmailInScreen.
/// If authenticated but profile incomplete -> UserProfileSetupView.
/// If authenticated and profile completed -> TopScreenView.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // Mandatory Authentication: Must sign in or sign up
          return const SignWithEmailInScreen();
        }

        // Check whether the authenticated user has completed their profile
        final profileAsync = ref.watch(userProfileStreamProvider);
        return profileAsync.when(
          data: (profile) {
            if (profile == null || !profile.isProfileCompleted) {
              return const UserProfileSetupView(isInitialSetup: true);
            }
            return const TopScreenView();
          },
          loading: () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, __) => const TopScreenView(),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const SignWithEmailInScreen(),
    );
  }
}
