import 'package:fl_app/controller/auth_controller.dart';
import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/utils/size_utils.dart';
import 'package:fl_app/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/analytics_controller.dart';
import '../../res/strings_utils.dart';
import '../../widget/button.dart';
import '../../widget/custom_textfield.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    // TODO: implement initState
    authController.editNameC.text = authController.user.value.displayName;
    AnalyticsService().setCurrentScreen(screenName: "EditProfile");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Edit Profile", showLeading: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeUtils.horizontalBlockSize * 4),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: authController.editFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeUtils.verticalBlockSize * 5,
                    ),
                    const Text(
                      "FullName",
                      style: TextStyle(color: AppColor.textColor70, fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: SizeUtils.verticalBlockSize * 1, bottom: SizeUtils.verticalBlockSize * 3),
                      child: CustomTextField(
                        controller: authController.editNameC,
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
                    const Text(
                      "Email",
                      style: TextStyle(color: AppColor.textColor70, fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: SizeUtils.verticalBlockSize * 1, bottom: SizeUtils.verticalBlockSize * 3),
                      child: CustomTextField(
                        controller: TextEditingController(text: authController.user.value.email),
                        radius: 8,
                        readOnly: true,
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
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeUtils.verticalBlockSize * 1, bottom: SizeUtils.verticalBlockSize * 4),
              child: CustomButton(
                onPressed: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  authController.submitted = true.obs;
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  if (authController.editFormKey.currentState!.validate()) {
                    authController.updateProfile();
                    print("Update Success");
                  }
                },
                text: "Update",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
