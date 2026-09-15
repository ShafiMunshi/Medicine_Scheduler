import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_app/constant/app_assets.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/screens/auth/sign_up_page.dart';
import 'package:medicine_app/screens/profile/user_profile_setup_view.dart';
import 'package:medicine_app/screens/top_screen_view.dart';
import 'package:medicine_app/viewmodels/auth_viewmodel.dart';
import 'package:medicine_app/viewmodels/database_providers.dart';
import 'package:nb_utils/nb_utils.dart';

class SignWithEmailInScreen extends ConsumerStatefulWidget {
  static const String routeName = '/sign_in_screen';
  const SignWithEmailInScreen({super.key});

  @override
  ConsumerState<SignWithEmailInScreen> createState() =>
      _SignWithEmailInScreenState();
}

class _SignWithEmailInScreenState extends ConsumerState<SignWithEmailInScreen> {
  final emailCont = TextEditingController();
  final passwordCont = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final emailfocus = FocusNode();
  final passwordfocus = FocusNode();

  bool _isSigningIn = false;

  @override
  void dispose() {
    emailCont.dispose();
    passwordCont.dispose();
    emailfocus.dispose();
    passwordfocus.dispose();
    super.dispose();
  }

  Future<void> _handlePostAuthNavigation() async {
    final userRepo = ref.read(userRepositoryProvider);
    final localUser = await userRepo.getUser();
    final isCompleted = localUser?.isProfileCompleted ?? false;

    if (!mounted) return;

    if (!isCompleted) {
      Navigator.pushReplacementNamed(
        context,
        UserProfileSetupView.routeName,
      );
    } else {
      Navigator.pushReplacementNamed(context, TopScreenView.routeName);
    }
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSigningIn = true);

    try {
      final user = await ref.read(authControllerProvider.notifier).signInWithEmail(
            email: emailCont.text.trim(),
            password: passwordCont.text.trim(),
          );
      if (user != null) {
        toast('Signed in as ${user.email ?? user.displayName}');
        await _handlePostAuthNavigation();
      }
    } catch (e) {
      toast('Sign-In Error: $e');
    } finally {
      if (mounted) setState(() => _isSigningIn = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isSigningIn = true);
    try {
      final user =
          await ref.read(authControllerProvider.notifier).signInWithGoogle();
      if (user != null) {
        toast('Signed in with Google: ${user.displayName ?? user.email}');
        await _handlePostAuthNavigation();
      }
    } catch (e) {
      toast('Google Sign-In Error: $e');
    } finally {
      if (mounted) setState(() => _isSigningIn = false);
    }
  }

  Future<void> _signInWithApple() async {
    setState(() => _isSigningIn = true);
    try {
      final user =
          await ref.read(authControllerProvider.notifier).signInWithApple();
      if (user != null) {
        toast('Signed in with Apple');
        await _handlePostAuthNavigation();
      }
    } catch (e) {
      toast('Apple Sign-In Error: $e');
    } finally {
      if (mounted) setState(() => _isSigningIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        changeIcon: true,
        title: "",
        showLeadingIcon: false,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: CommonButton(
            buttonText: _isSigningIn ? "Signing In..." : "Sign In",
            width: MediaQuery.of(context).size.width,
            onTap: _isSigningIn ? null : _signInWithEmail,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.verticalSpace,
                const Text(
                  "Welcome Back 👋",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                8.verticalSpace,
                const Text(
                  "Sign in to synchronize your reminders and keep caregivers updated.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                24.verticalSpace,

                // Social Sign In Buttons (Google & Apple)
                _buildSocialButton(
                  iconAsset: google_logo,
                  label: "Continue with Google",
                  onTap: _isSigningIn ? null : _signInWithGoogle,
                ),
                12.verticalSpace,
                _buildSocialButton(
                  iconAsset: apple_logo,
                  label: "Continue with Apple",
                  onTap: _isSigningIn ? null : _signInWithApple,
                ),
                20.verticalSpace,

                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "OR USE EMAIL",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                20.verticalSpace,

                AppTextField(
                  textFieldType: TextFieldType.EMAIL,
                  controller: emailCont,
                  focus: emailfocus,
                  nextFocus: passwordfocus,
                  decoration: inputDecoration(
                    context,
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
                16.verticalSpace,
                AppTextField(
                  textFieldType: TextFieldType.PASSWORD,
                  controller: passwordCont,
                  focus: passwordfocus,
                  decoration: inputDecoration(
                    context,
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                ),
                24.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SignUpScreen.routeName);
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String iconAsset,
    required String label,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconAsset,
              height: 22,
              width: 22,
              errorBuilder: (_, __, ___) => const Icon(Icons.login, size: 22),
            ),
            12.horizontalSpace,
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
