import 'package:fl_app/ads/rewarded_ad.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../res/app_colors.dart';
import '../screens/premium_screen/premium_screen.dart';
import '../utils/size_utils.dart';
import '../widget/button.dart';

enum FreeCount {
  assistantFreeCount,
  characterFreeCount,
  imageFreeCount,
}

class PremiumController extends GetxController {
  static final _box = GetStorage();

  RxInt assistantFreeCount = 2.obs;
  RxInt characterFreeCount = 2.obs;
  RxInt imageFreeCount = 2.obs;

  void setFreeCountIfNull() {
    if (_box.read(FreeCount.assistantFreeCount.toString()) == null) {
      _box.write(FreeCount.assistantFreeCount.toString(), 2);
    }
    if (_box.read(FreeCount.characterFreeCount.toString()) == null) {
      _box.write(FreeCount.characterFreeCount.toString(), 2);
    }
    if (_box.read(FreeCount.imageFreeCount.toString()) == null) {
      _box.write(FreeCount.imageFreeCount.toString(), 2);
    }
  }

  Future<void> readAndSetFreeCount() async {
    assistantFreeCount.value = await _box.read(FreeCount.assistantFreeCount.toString());
    characterFreeCount.value = await _box.read(FreeCount.characterFreeCount.toString());
    imageFreeCount.value = await _box.read(FreeCount.imageFreeCount.toString());
    update();
  }

  void incrementCount() {
    _box.write(FreeCount.assistantFreeCount.toString(), assistantFreeCount.value + 1);
    _box.write(FreeCount.characterFreeCount.toString(), characterFreeCount.value + 1);
    _box.write(FreeCount.imageFreeCount.toString(), imageFreeCount.value + 1);
    readAndSetFreeCount();
  }

  void useCount({FreeCount? useType}) {
    if (useType == FreeCount.assistantFreeCount) {
      _box.write(FreeCount.assistantFreeCount.toString(), assistantFreeCount.value - 1);
      readAndSetFreeCount();
    }
    if (useType == FreeCount.characterFreeCount) {
      _box.write(FreeCount.characterFreeCount.toString(), characterFreeCount.value - 1);
      readAndSetFreeCount();
    }
    if (useType == FreeCount.imageFreeCount) {
      _box.write(FreeCount.imageFreeCount.toString(), imageFreeCount.value - 1);
      readAndSetFreeCount();
    }
  }

  void openPremiumDialog() {
    Get.dialog(PremiumScreen());
  }

  void rewardAdDialog({required Function()? onPressed}) {
    Get.defaultDialog(
      title: "Watch Video to increase your limit",
      titlePadding: EdgeInsets.all(10),
      content: SizedBox(),
      confirm: CustomButton(width: SizeUtils.horizontalBlockSize * 35, height: SizeUtils.horizontalBlockSize * 12, onPressed: onPressed, text: "YES"),
      cancel: CustomButton(
          width: SizeUtils.horizontalBlockSize * 35,
          buttonColor: AppColor.inActiveButton,
          height: SizeUtils.horizontalBlockSize * 12,
          onPressed: Get.back,
          text: "NO"),
    );
  }

  @override
  void onInit() {
    setFreeCountIfNull();
    super.onInit();
  }
}
