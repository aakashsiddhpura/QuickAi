import 'dart:async';
import 'dart:io';

import 'package:ak_ads_plugin/ak_ads_plugin.dart';
import 'package:fl_app/ads/call_ads.dart';
import 'package:fl_app/controller/auth_controller.dart';
import 'package:fl_app/controller/setiing_controller.dart';
import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/res/assets_path.dart';
import 'package:fl_app/utils/navigation_utils/navigation.dart';
import 'package:fl_app/utils/navigation_utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'InApp Purchase/singletons_data.dart';
import 'ads/rewarded_ad.dart';
import 'controller/home_controller.dart';
import 'utils/size_utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AuthController authController = Get.put(AuthController());
  HomeController homeController = Get.put(HomeController());
  SettingController settingController = Get.put(SettingController());
  RewardedAdController rewardedAdController = Get.put(RewardedAdController(), permanent: true);

  bool _lottieVisible = false;
  bool _textVisible = false;
  @override
  void initState() {
    super.initState();
    settingController.getSettingData();
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _textVisible = true;
      });
    });
    Future.delayed(Duration(milliseconds: 600), () {
      setState(() {
        _lottieVisible = true;
      });
    });
    Future.delayed(Duration(seconds: 1), () {
      startTimeOut();
    });
  }

  Future<void> loadAdsData() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black87,
            child: Image.asset(
              AssetsPath.splashBgImg,
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(.7),
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.21, -0.98),
                end: Alignment(-0.21, 0.98),
                colors: [Color(0x7F7268EE), Color(0x000E094E)],
              ),
            ),
            child: Image.asset(
              AssetsPath.splashBg,
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(.5),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white.withOpacity(.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                    opacity: _lottieVisible ? 1.0 : 0.0, duration: const Duration(milliseconds: 800), child: Lottie.asset(AssetsPath.splashLoader)),
                AnimatedOpacity(
                  opacity: _textVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: const Text(
                    "ChatPix Ai",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40, color: AppColor.textColor),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> startTimeOut() async {
    await rewardedAdController.getAdsData();
    if (Platform.isAndroid) await CallAds().getApiResponse(adShow: !appData.entitlementIsActive.value);
    GetStorage storage = GetStorage();
    bool? newUser = storage.read("new_user");
    if (newUser == null) {
      storage.write("new_user", false);
    }

    Future.delayed(Duration(seconds: adsModel.aPPSETTINGS!.appAdShowStatus == "1" ? 1 : 3), () {
      Navigation.replace(authController.user.value.uid.isNotEmpty
          ? Routes.kMainScreen
          : newUser == false
              ? Routes.kLoginScreen
              : Routes.kIntroScreen);
    });
  }
}
