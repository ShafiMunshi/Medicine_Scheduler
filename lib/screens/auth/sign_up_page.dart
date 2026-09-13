import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_app/constant/app_assets.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/screens/profile/user_profile_setup_view.dart';
import 'package:medicine_app/viewmodels/auth_viewmodel.dart';
import 'package:nb_utils/nb_utils.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  static const String routeName = '/sign_up_screen';
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final emailCont = TextEditingController();
  final passwordCont = TextEditingController();
  final nameCont = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  bool _isSigningUp = false;

  @override
  void dispose() {
    emailCont.dispose();
    passwordCont.dispose();
    nameCont.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSigningUp = true);

    try {
      final user = await ref.read(authControllerProvider.notifier).signUpWithEmail(
            email: emailCont.text.trim(),
            password: passwordCont.text.trim(),
            name: nameCont.text.trim(),
          );
      if (user != null && mounted) {
        toast('Account created successfully!');
        Navigator.pushReplacementNamed(
          context,
          UserProfileSetupView.routeName,
        );
      }
    } catch (e) {
      toast('Sign-Up Error: $e');
    } finally {
      if (mounted) setState(() => _isSigningUp = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isSigningUp = true);
    try {
      final user =
          await ref.read(authControllerProvider.notifier).signInWithGoogle();
      if (user != null && mounted) {
        Navigator.pushReplacementNamed(
          context,
          UserProfileSetupView.routeName,
        );
      }
    } catch (e) {
      toast('Google Sign-In Error: $e');
    } finally {
      if (mounted) setState(() => _isSigningUp = false);
    }
  }

  Future<void> _signInWithApple() async {
    setState(() => _isSigningUp = true);
    try {
      final user =
          await ref.read(authControllerProvider.notifier).signInWithApple();
      if (user != null && mounted) {
        Navigator.pushReplacementNamed(
          context,
          UserProfileSetupView.routeName,
        );
      }
    } catch (e) {
      toast('Apple Sign-In Error: $e');
    } finally {
      if (mounted) setState(() => _isSigningUp = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        changeIcon: true,
        title: "",
        showLeadingIcon: true,
      ),
      bottomNavigationBar: SafeArea(
        child: CommonButton(
          buttonText: _isSigningUp ? "Creating Account..." : "Create Account & Continue",
          width: MediaQuery.of(context).size.width,
          onTap: _isSigningUp ? null : _signUpWithEmail,
        ).paddingAll(16),
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
                  "Create Account",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                8.verticalSpace,
                const Text(
                  "Keep your medicine reminders safe offline and let family stay in sync.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                24.verticalSpace,

                // Social Buttons
                _buildSocialButton(
                  iconAsset: google_logo,
                  label: "Sign up with Google",
                  onTap: _isSigningUp ? null : _signInWithGoogle,
                ),
                12.verticalSpace,
                _buildSocialButton(
                  iconAsset: apple_logo,
                  label: "Sign up with Apple",
                  onTap: _isSigningUp ? null : _signInWithApple,
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
                  textFieldType: TextFieldType.NAME,
                  controller: nameCont,
                  focus: nameFocus,
                  nextFocus: emailFocus,
                  decoration: inputDecoration(
                    context,
                    labelText: "Full Name",
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                16.verticalSpace,
                AppTextField(
                  textFieldType: TextFieldType.EMAIL,
                  controller: emailCont,
                  focus: emailFocus,
                  nextFocus: passwordFocus,
                  decoration: inputDecoration(
                    context,
                    labelText: "Email Address",
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
                16.verticalSpace,
                AppTextField(
                  textFieldType: TextFieldType.PASSWORD,
                  controller: passwordCont,
                  focus: passwordFocus,
                  decoration: inputDecoration(
                    context,
                    labelText: "Password (min 6 chars)",
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                ),
                24.verticalSpace,
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
