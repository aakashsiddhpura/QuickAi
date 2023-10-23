import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_app/controller/auth_controller.dart';
import 'package:fl_app/controller/premium_controller.dart';
import 'package:fl_app/controller/setiing_controller.dart';
import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/screens/Setting/custom_web_view.dart';
import 'package:fl_app/utils/navigation_utils/navigation.dart';
import 'package:fl_app/utils/navigation_utils/routes.dart';
import 'package:fl_app/widget/button.dart';
import 'package:fl_app/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';

import '../../controller/analytics_controller.dart';
import '../../res/assets_path.dart';
import '../../res/strings_utils.dart';
import '../../utils/size_utils.dart';
import '../../widget/bottom_sheets.dart';
import '../premium_screen/premium_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  AuthController authController = Get.put(AuthController());
  final InAppReview _inAppReview = InAppReview.instance;
  SettingController settingController = Get.put(SettingController());
  PremiumController premiumController = Get.put(PremiumController());

  @override
  void initState() {
    settingController.getSettingData();
    AnalyticsService().setCurrentScreen(screenName: "SettingScreen");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Setting", leadingWith: 0),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeUtils.horizontalBlockSize * 4, vertical: SizeUtils.verticalBlockSize * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return authController.user.value.uid.isNotEmpty
                  ? ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      tileColor: AppColor.bottomBarClr,
                      leading: Image.asset(AssetsPath.profileAvatar),
                      title: Text(
                        authController.user.value.displayName,
                        style: TextStyle(color: AppColor.textColor, fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      subtitle: Text(
                        authController.user.value.email,
                        maxLines: 1,
                        style: TextStyle(
                            color: AppColor.textColor.withOpacity(.6), fontWeight: FontWeight.w400, fontSize: 15, overflow: TextOverflow.ellipsis),
                      ),
                      trailing: InkResponse(
                        onTap: () {
                          Navigation.pushNamed(Routes.kEditProfile);
                        },
                        radius: 20,
                        child: Icon(
                          Icons.edit,
                          color: AppColor.white.withOpacity(.5),
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        children: [
                          Image.asset(
                            AssetsPath.profileAvatar,
                            width: SizeUtils.horizontalBlockSize * 30,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigation.replaceAll(Routes.kLoginScreen);
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  shadows: [Shadow(color: AppColor.textColor, offset: Offset(0, -4))],
                                  color: Colors.transparent,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColor.textColor,
                                  decorationThickness: 1,
                                  decorationStyle: TextDecorationStyle.solid,
                                ),
                              ))
                        ],
                      ),
                    );
            }),
            Padding(
              padding: EdgeInsets.only(top: SizeUtils.verticalBlockSize * 2.5),
              child: Text(
                "Settings",
                style: TextStyle(color: AppColor.textColor.withOpacity(.6), fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (authController.user.value.uid.isNotEmpty)
                      settingTile(
                        title: "History",
                        icon: AssetsPath.historyIc,
                        iconColor: AppColor.white.withOpacity(.6),
                        onTap: () {
                          Navigation.pushNamed(Routes.kHistoryScreen);
                        },
                      ),
                    settingTile(
                        title: "Manage Subscriptions",
                        icon: AssetsPath.manageSubIc,
                        onTap: () {
                          premiumController.manageSubscription();
                        }),
                    settingTile(
                        title: "Rate App",
                        icon: AssetsPath.starIc,
                        onTap: () async {
                          if (await _inAppReview.isAvailable()) {
                            _inAppReview.requestReview();
                          }
                        }),
                    settingTile(
                        title: "Share App with Friends",
                        icon: AssetsPath.shareIc,
                        onTap: () async {
                          await Share.share(
                            "🤖 AI Chat & Image Creation 🖼️\n\nChat with a ChatPix AI and create stunning images in one app.\n\n🗨️ Engage in dynamic conversations.\n🎨 Generate unique artworks effortlessly.\n\n\nUnlock the power of AI today!\n\n👉 Get it now: https://play.google.com/store/apps/details?id=${AppString.kPackageName}",
                          );
                        },
                        iconColor: AppColor.white.withOpacity(.6)),
                    settingTile(
                        title: "Privacy Policy",
                        icon: AssetsPath.privacyPolicyIc,
                        onTap: () {
                          if (settingController.privacyPolicy != null && settingController.privacyPolicy != "") {
                            Get.to<dynamic>(CustomWebView(url: settingController.privacyPolicy, pageName: "Privacy Policy"));
                          }
                        }),
                    settingTile(
                        title: "Terms & Conditions",
                        icon: AssetsPath.termsIc,
                        onTap: () {
                          if (settingController.termsAndCondition != null && settingController.termsAndCondition != "") {
                            Get.to<dynamic>(CustomWebView(url: settingController.termsAndCondition, pageName: "Terms & Conditions"));
                          }
                        }),
                    settingTile(
                        title: "FAQs",
                        icon: AssetsPath.faqsIc,
                        onTap: () {
                          if (settingController.faqS != null && settingController.faqS != "") {
                            Get.to<dynamic>(CustomWebView(url: settingController.faqS, pageName: "FAQs"));
                          }
                        }),
                    if (authController.user.value.uid.isNotEmpty)
                      settingTile(
                          title: "Forgot Password",
                          icon: AssetsPath.forgotPwdIc,
                          onTap: () {
                            Navigation.pushNamed(Routes.kForgotPasswordScreen);
                          }),
                    if (authController.user.value.uid.isNotEmpty)
                      settingTile(
                          title: "Delete Account",
                          icon: AssetsPath.deleteIc,
                          onTap: () {
                            settingBottomSheet(
                                title: "Delete Account",
                                description: "Are you sure you want to delete your account?",
                                onTapYes: authController.deleteAccount);
                          }),
                    settingTile(
                        title: authController.user.value.uid.isNotEmpty ? "Logout" : "Login",
                        icon: AssetsPath.logoutIc,
                        onTap: () {
                          if (authController.user.value.uid.isNotEmpty) {
                            settingBottomSheet(
                                title: "Log Out", description: "Are you sure you want to log out your account?", onTapYes: authController.signOut);
                          } else {
                            Navigation.replaceAll(Routes.kLoginScreen);
                          }
                        }),
                    SizedBox(
                      height: SizeUtils.verticalBlockSize * 1,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: SizeUtils.verticalBlockSize * 7,
      ),
    );
  }

  Widget settingTile({required String title, required String icon, required void Function()? onTap, Color? iconColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeUtils.verticalBlockSize * .8),
      child: Material(
        surfaceTintColor: Colors.transparent,
        color: Colors.transparent,
        child: ListTile(
          selectedTileColor: AppColor.bottomBarClr,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          tileColor: AppColor.bottomBarClr,
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: CircleAvatar(
              backgroundColor: AppColor.imageBgClr,
              maxRadius: 25,
              child: SvgPicture.asset(
                icon,
                width: 22,
                height: 22,
                color: iconColor,
              ),
            ),
          ),
          onTap: onTap,
          title: Text(
            title,
            style: TextStyle(color: AppColor.textColor.withOpacity(.5), fontWeight: FontWeight.w400, fontSize: 16),
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 22),
            child: SvgPicture.asset(
              AssetsPath.nextArrowIc,
              height: 18,
              width: 18,
            ),
          ),
        ),
      ),
    );
  }
}
