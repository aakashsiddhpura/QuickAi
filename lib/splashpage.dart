import 'dart:async';

import 'package:fl_app/ads/call_ads.dart';
import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/res/assets_path.dart';
import 'package:fl_app/utils/navigation_utils/navigation.dart';
import 'package:fl_app/utils/navigation_utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'utils/size_utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // VpnController vpnController = Get.put(VpnController());
  @override
  void initState() {
    super.initState();
    startTimeOut();
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
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.21, -0.98),
                end: Alignment(-0.21, 0.98),
                colors: [Color(0x7F7268EE), Color(0x000E094E)],
              ),
            ),
            child: Image.asset(
              AssetsPath.splashBg,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: SizeUtils.verticalBlockSize * 8,
            child: Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: AppColor.white,
                secondRingColor: AppColor.secondaryClr,
                thirdRingColor: AppColor.primaryClr,
                size: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> startTimeOut() async {
    await CallAds().getApiResponse();

    Future.delayed(Duration(seconds: adsModel.adsShow == true ? 0 : 3), () {
      // if (AdConstants.adsModel.showScreen?.b1 == true) {
      // Navigation.replaceAll(Routes.startPage);
      // } else if (AdConstants.adsModel.showScreen?.b2 == true) {
      //   Navigation.replaceAll(Routes.nextPage);
      // } else if (AdConstants.adsModel.showScreen?.b3 == true) {
      //   Navigation.replaceAll(Routes.continuePage);
      // } else {
      Navigation.replaceAll(Routes.kIntroScreen);
      // }
    });
  }
}
