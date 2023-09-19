import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/utils/size_utils.dart';
import 'package:fl_app/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../res/strings_utils.dart';
import '../../widget/button.dart';
import '../../widget/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Forgot Password", centerTitle: true, showLeading: true),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeUtils.horizontalBlockSize * 5, vertical: SizeUtils.verticalBlockSize * 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Don’t worry ! it happens. Please Enter the Email address associated with your account.",
                    style: TextStyle(color: AppColor.textColor.withOpacity(.5), fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: SizeUtils.verticalBlockSize * 2,
                  ),
                  Text(
                    "We will email to reset your Password.",
                    style: TextStyle(color: AppColor.textColor.withOpacity(.5), fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  Obx(() {
                    return Form(
                      autovalidateMode: authController.submitted.value ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                      key: authController.forgotFormKey,
                      child: Padding(
                        padding: EdgeInsets.only(top: SizeUtils.verticalBlockSize * 3),
                        child: CustomTextField(
                          controller: authController.forgotPasswordC,
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
                    );
                  }),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: SizeUtils.verticalBlockSize * 3),
            child: CustomButton(
              onPressed: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                authController.submitted = true.obs;
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                if (authController.forgotFormKey.currentState!.validate()) {
                  authController.sendPasswordResetEmail(authController.forgotPasswordC.text);
                }
              },
              text: "Forgot Password",
            ),
          ),
        ],
      ),
    );
  }
}
