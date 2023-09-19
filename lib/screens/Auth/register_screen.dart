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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Obx(() {
                return Form(
                  autovalidateMode: authController.regSubmitted.value ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                  key: authController.regFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(),
                      Column(
                        children: [
                          const Text(
                            "Create Account",
                            style: TextStyle(color: AppColor.textColor, fontWeight: FontWeight.w600, fontSize: 32),
                          ),
                          const Text(
                            "Create to you new account",
                            style: TextStyle(color: AppColor.textColor35, fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: SizeUtils.horizontalBlockSize * 5, right: SizeUtils.horizontalBlockSize * 5, top: SizeUtils.verticalBlockSize * 4),
                            child: CustomTextField(
                              controller: authController.regDisplayNameC,
                              radius: 8,
                              inputFormatter: Validate.nameFormat,
                              hintText: "Enter Full Name",
                              disabledColor: AppColor.white.withOpacity(.1),
                              focusedColor: AppColor.white.withOpacity(.1),
                              enableColor: AppColor.white.withOpacity(.1),
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return Validate.nameEmptyValidator;
                                } else if (v.length < 3) {
                                  return Validate.nameLengthValidator;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: SizeUtils.horizontalBlockSize * 5, right: SizeUtils.horizontalBlockSize * 5, top: SizeUtils.verticalBlockSize * 2),
                            child: CustomTextField(
                              controller: authController.regEmailC,
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
                            padding: EdgeInsets.only(left: SizeUtils.horizontalBlockSize * 5, right: SizeUtils.horizontalBlockSize * 5, top: SizeUtils.verticalBlockSize * 2),
                            child: CustomTextField(
                              controller: authController.regPasswordC,
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
                        ],
                      ),
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
                  authController.regSubmitted = true.obs;
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  if (authController.regFormKey.currentState!.validate()) {
                    authController.registerWithEmailAndPassword(authController.regEmailC.text, authController.regPasswordC.text, authController.regDisplayNameC.text);
                    print("Login Success");
                  }
                },
                text: "Register Now",
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: SizeUtils.verticalBlockSize * 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 16, color: AppColor.textColor35, fontWeight: FontWeight.w400),
                    ),
                    TextButton(
                      onPressed: Get.back,
                      child: const Text(
                        "Login",
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
    );
  }
}
