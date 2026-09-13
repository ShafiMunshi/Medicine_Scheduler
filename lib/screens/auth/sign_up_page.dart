import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/screens/top_screen_view.dart';
import 'package:nb_utils/nb_utils.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/sign_up_screen';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailCont = TextEditingController();
  final passwordCont = TextEditingController();
  final nameCont = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        changeIcon: true,
        title: "",
        showLeadingIcon: true,
      ),
      bottomNavigationBar: CommonButton(
        buttonText: "Sign Up",
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
                  "Create Account",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                10.verticalSpace,
                const Text(
                  "Keep your medicine reminders safe and offline",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                30.verticalSpace,
                AppTextField(
                  textFieldType: TextFieldType.NAME,
                  controller: nameCont,
                  focus: nameFocus,
                  nextFocus: emailFocus,
                  decoration: inputDecoration(
                    context,
                    labelText: "Name",
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
                    labelText: "Email",
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
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
