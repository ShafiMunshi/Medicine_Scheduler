import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_app/constant/app_assets.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/app/screens/auth/sign_up_page.dart';
import 'package:medicine_app/app/viewmodels/viewmodels_auth.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SignWithEmailInScreen extends StatefulWidget {
  static const String routeName = '/sign_in_screen';
  @override
  _SignWithEmailInScreenState createState() => _SignWithEmailInScreenState();
}

class _SignWithEmailInScreenState extends State<SignWithEmailInScreen> {
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  FocusNode emailfocus = FocusNode();
  FocusNode passwordfocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.read<AuthViewModels>();
    return Scaffold(
      appBar: commonAppBarWidget(context,
          changeIcon: true, title: "", showLeadingIcon: false),
      bottomNavigationBar: authController.isLoading
          ? Center(child: CircularProgressIndicator())
          : CommonButton(
              buttonText: "Sign In",
              width: MediaQuery.of(context).size.width,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  if (emailCont.text.isNotEmpty &&
                      passwordCont.text.isNotEmpty) {
                    // authController.signIn(emailCont.text.trim(),
                    //     passwordCont.text.trim(), context);
                    // Get.offAll(() => TopScreenView());
                  }
                }
              }),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Log in ', style: boldTextStyle(size: 24)),
              16.height,
              Row(
                children: [
                  Text("Don't have an account?",
                      style:
                          secondaryTextStyle(size: 16, color: Colors.black87)),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpScreen.routeName);
                      },
                      child: Text('Sign up',
                          style: boldTextStyle(color: Colors.blue)))
                ],
              ),
              28.height,
              AppTextField(
                textFieldType: TextFieldType.EMAIL,
                controller: emailCont,
                focus: emailfocus,
                nextFocus: passwordfocus,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'This field is empty';
                  }
                  //  else if (!val.isEmail) {
                  //   return 'Email is not valid';
                  // }

                  return null;
                },
                decoration: inputDecoration(context,
                    labelText: "Email",
                    prefixIcon: ic_message.iconImage(size: 10).paddingAll(14)),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.PASSWORD,
                controller: passwordCont,
                focus: passwordfocus,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'This field is empty';
                  } else if (val.length < 4) {
                    return 'Password must have at least 5 length';
                  }

                  return null;
                },
                suffixPasswordVisibleWidget:
                    ic_show.iconImage(size: 10).paddingAll(14),
                suffixPasswordInvisibleWidget:
                    ic_hide.iconImage(size: 10).paddingAll(14),
                decoration: inputDecoration(context,
                    labelText: "Password",
                    prefixIcon: ic_lock.iconImage(size: 10).paddingAll(14)),
              ),
              // 8.height,
              TextButton(
                onPressed: () {
                  // ForgotPasswordScreen().launch(context);
                },
                child: Text('Forgot Password?',
                    style: primaryTextStyle(
                        color: AppColors.primaryColor, size: 14)),
              ),

              20.verticalSpace,
              Row(
                children: [
                  Container(color: gray.withOpacity(0.2), height: 1).expand(),
                  12.width,
                  Text('Or sign up with email', style: secondaryTextStyle()),
                  12.width,
                  Container(color: gray.withOpacity(0.2), height: 1).expand(),
                ],
              ),
              24.verticalSpace,
              commonSocialLoginButton(context),
            ],
          ).paddingAll(16),
        ),
      ),
    );
  }
}
