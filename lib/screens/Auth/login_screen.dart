import 'package:fl_app/controller/auth_controller.dart';
import 'package:fl_app/res/assets_path.dart';
import 'package:fl_app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../res/app_colors.dart';
import '../../res/strings_utils.dart';
import '../../utils/navigation_utils/navigation.dart';
import '../../utils/navigation_utils/routes.dart';
import '../../utils/size_utils.dart';
import '../../widget/button.dart';
import '../../widget/toast_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Container(
        color: AppColor.backgroundColor,
        child: SafeArea(
          bottom: true,
          right: false,
          top: false,
          left: false,
          child: Scaffold(
            body: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: SizeUtils.verticalBlockSize * 5, right: SizeUtils.horizontalBlockSize * 2),
                    child: TextButton(
                      onPressed: () {
                        Navigation.replaceAll(Routes.kMainScreen);
                      },
                      child: const Text(
                        "SKIP",
                        style: TextStyle(color: AppColor.secondaryClr, fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    return Form(
                      autovalidateMode: authController.submitted.value ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                      key: authController.loginFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Welcome back!",
                            style: TextStyle(color: AppColor.textColor, fontWeight: FontWeight.w600, fontSize: 32),
                          ),
                          const Text(
                            "Glad to see you, Again!",
                            style: TextStyle(color: AppColor.textColor35, fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeUtils.horizontalBlockSize * 5,
                                right: SizeUtils.horizontalBlockSize * 5,
                                top: SizeUtils.verticalBlockSize * 4),
                            child: CustomTextField(
                              controller: authController.loginEmailC,
                              radius: 8,
                              inputFormatter: Validate.emailFormat,
                              hintText: "Enter email",
                              disabledColor: AppColor.white.withOpacity(.1),
                              focusedColor: AppColor.white.withOpacity(.1),
                              enableColor: AppColor.white.withOpacity(.1),
                              validator: (v) {
                                bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(v!);
                                if (v.isEmpty) {
                                  return Validate.emailEmptyValidator;
                                } else if (!emailValid) {
                                  return Validate.emailValidValidator;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeUtils.horizontalBlockSize * 5,
                                right: SizeUtils.horizontalBlockSize * 5,
                                top: SizeUtils.verticalBlockSize * 2),
                            child: CustomTextField(
                              controller: authController.loginPasswordC,
                              radius: 8,
                              hintText: "Enter password",
                              disabledColor: AppColor.white.withOpacity(.1),
                              focusedColor: AppColor.white.withOpacity(.1),
                              enableColor: AppColor.white.withOpacity(.1),
                              inputFormatter: Validate.passFormat,
                              keyboardType: TextInputType.visiblePassword,
                              isPassword: true,
                              textInputAction: TextInputAction.done,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return Validate.passwordEmptyValidator;
                                } else if (v.length < 6) {
                                  return Validate.passwordValidValidator;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: SizeUtils.horizontalBlockSize * 5),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                onPressed: () {
                                  Get.toNamed(Routes.kForgotPasswordScreen);
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(color: AppColor.textColor.withOpacity(.55), fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: SizeUtils.verticalBlockSize * 3),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: SizeUtils.horizontalBlockSize * 25,
                                      height: 1,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment(1.00, -0.04),
                                          end: Alignment(-1, 0.04),
                                          colors: [
                                            Color(0xFF909090).withOpacity(.5),
                                            Color(0xFF909090).withOpacity(.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "OR",
                                        style: TextStyle(color: AppColor.textColor.withOpacity(.55), fontWeight: FontWeight.w400, fontSize: 13),
                                      ),
                                    ),
                                    Container(
                                      width: SizeUtils.horizontalBlockSize * 25,
                                      height: 1,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment(1.00, -0.04),
                                          end: Alignment(-1, 0.04),
                                          colors: [
                                            Color(0xFF909090).withOpacity(.0),
                                            Color(0xFF909090).withOpacity(.5),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    authController.signInWithGoogle();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(.2),
                                      ),
                                    ),
                                    child: SvgPicture.asset(AssetsPath.googleIc),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
            bottomNavigationBar: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  CustomButton(
                    onPressed: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      authController.submitted = true.obs;
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      if (authController.loginFormKey.currentState!.validate()) {
                        authController.signInWithEmailAndPassword(authController.loginEmailC.text, authController.loginPasswordC.text);
                        print("Login Success");
                      }
                    },
                    text: "Login",
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: SizeUtils.verticalBlockSize * 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don’t have account?",
                          style: TextStyle(fontSize: 16, color: AppColor.textColor35, fontWeight: FontWeight.w400),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.kRegisterScreen);
                          },
                          child: const Text(
                            "Register Now",
                            style: TextStyle(color: AppColor.secondaryClr, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
