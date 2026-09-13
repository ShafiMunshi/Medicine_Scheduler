import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/screens/auth/sign_up_page.dart';
import 'package:medicine_app/screens/top_screen_view.dart';
import 'package:nb_utils/nb_utils.dart';

class SignWithEmailInScreen extends StatefulWidget {
  static const String routeName = '/sign_in_screen';
  const SignWithEmailInScreen({super.key});

  @override
  State<SignWithEmailInScreen> createState() => _SignWithEmailInScreenState();
}

class _SignWithEmailInScreenState extends State<SignWithEmailInScreen> {
  final emailCont = TextEditingController();
  final passwordCont = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final emailfocus = FocusNode();
  final passwordfocus = FocusNode();

  @override
  void dispose() {
    emailCont.dispose();
    passwordCont.dispose();
    emailfocus.dispose();
    passwordfocus.dispose();
    super.dispose();
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
      bottomNavigationBar: CommonButton(
        buttonText: "Sign In",
        width: MediaQuery.of(context).size.width,
        onTap: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pushReplacementNamed(context, TopScreenView.routeName);
          }
        },
      ).paddingAll(12),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.verticalSpace,
                const Text(
                  "Sign In",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                10.verticalSpace,
                const Text(
                  "Access your scheduled medications offline anytime",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                30.verticalSpace,
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
                20.verticalSpace,
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
}
