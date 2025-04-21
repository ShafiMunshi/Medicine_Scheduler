import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_app/constant/app_assets.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/repository/auth/auth_repository.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/viewmodels/viewmodels_auth.dart';
import 'package:medicine_app/screens/top_screen_view.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/sign_up_screen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
    final authController = Provider.of<AuthViewModels>(context, listen: false);
    return Scaffold(
      appBar: commonAppBarWidget(context,
          changeIcon: true, title: "", showLeadingIcon: false),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(12),
        child: authController.isLoading
            ? Center(child: CircularProgressIndicator())
            : CommonButton(
                buttonText: "Sign Up",
                width: MediaQuery.of(context).size.width,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    if (emailCont.text.isNotEmpty &&
                        passwordCont.text.isNotEmpty) {
                      // Get.offAll(() => TopScreenView());
                    }
                  }
                }),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Register', style: boldTextStyle(size: 24)),
              16.height,
              Row(
                children: [
                  Text("Already have an account?",
                      style:
                          secondaryTextStyle(size: 16, color: Colors.black87)),
                  TextButton(
                      onPressed: () {},
                      child: Text('Sign In',
                          style: boldTextStyle(color: Colors.blue)))
                ],
              ),
              28.height,
              AppTextField(
                textFieldType: TextFieldType.NAME,
                controller: emailCont,
                focus: emailfocus,
                nextFocus: passwordfocus,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'This field is empty';
                  }

                  return null;
                },
                decoration: inputDecoration(
                  context,
                  labelText: "Name",
                  // prefixIcon: ic_message.iconImage(size: 10).paddingAll(14),
                ),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.EMAIL,
                controller: emailCont,
                focus: emailfocus,
                nextFocus: passwordfocus,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'This field is empty';
                  } else if (!val.validateEmail()) {
                    return 'Email is not valid';
                  }

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

              20.verticalSpace,
              Row(
                children: [
                  Container(color: gray.withOpacity(0.2), height: 1).expand(),
                  12.width,
                  Text('Or sign in with email', style: secondaryTextStyle()),
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
