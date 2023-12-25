import 'package:fl_app/screens/Setting/manage_subscription_plan.dart';
import 'package:fl_app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../InApp Purchase/constant.dart';
import '../InApp Purchase/native_dialog.dart';
import '../InApp Purchase/singletons_data.dart';
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
    // _box.write(FreeCount.imageFreeCount.toString(), imageFreeCount.value + 1);
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
    buySubscription();
    // Get.dialog(PremiumScreen());
  }

  Future<void> initPlatformState() async {
    appData.appUserID.value = await Purchases.appUserID;

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      appData.appUserID.value = await Purchases.appUserID;

      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      EntitlementInfo? entitlement = customerInfo.entitlements.all[entitlementID];
      appData.entitlementIsActive.value = entitlement?.isActive ?? false;

      update();
    });
  }

  void buySubscription() async {
    Loader.sw();
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.all[entitlementID] != null && customerInfo.entitlements.all[entitlementID]?.isActive == true) {
      Loader.hd();

      /// user subscribed already
    } else {
      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();

        Loader.hd();
      } on PlatformException catch (e) {
        Loader.hd();
        await showDialog(context: Get.context!, builder: (BuildContext context) => ShowDialogToDismiss(title: "Error", content: e.message ?? "Unknown error", buttonText: 'OK'));
      }
      if (offerings == null || offerings.current == null) {
        // offerings are empty, show a message to your user
      } else {
        // current offering is available, show paywall

        Get.dialog(PremiumScreen(
          offering: offerings.current!,
        ));
      }
    }
  }

  Future<void> manageSubscription() async {
    Loader.sw();
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    Offerings? offerings;
    try {
      offerings = await Purchases.getOfferings();

      Loader.hd();
    } on PlatformException catch (e) {
      Loader.hd();
      await showDialog(context: Get.context!, builder: (BuildContext context) => ShowDialogToDismiss(title: "Error", content: e.message ?? "Unknown error", buttonText: 'OK'));
    }
    if (offerings == null || offerings.current == null) {
      // offerings are empty, show a message to your user
    } else {
      // current offering is available, show paywall
      Get.to(ManageSubscription(
        offering: offerings.current!,
      ));
    }
  }

  void rewardAdDialog({required Function()? onPressed}) {
    Get.defaultDialog(
      title: "Watch Video to increase your limit",
      titlePadding: EdgeInsets.all(10),
      content: SizedBox(),
      confirm: CustomButton(width: SizeUtils.horizontalBlockSize * 35, height: SizeUtils.horizontalBlockSize * 12, onPressed: onPressed, text: "YES"),
      cancel: CustomButton(width: SizeUtils.horizontalBlockSize * 35, buttonColor: AppColor.inActiveButton, height: SizeUtils.horizontalBlockSize * 12, onPressed: Get.back, text: "NO"),
    );
  }

  @override
  void onInit() {
    initPlatformState();
    setFreeCountIfNull();
    super.onInit();
  }
}
