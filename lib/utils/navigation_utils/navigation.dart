import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ads/call_ads.dart';

class Navigation {
  static void push(Widget child, MaterialPageRoute materialPageRoute) {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.to<dynamic>(child);
  }

  static Future pushNamed(
    String routeName, {
    dynamic arg,
    Map<String, String>? params,
  }) async {
    // if (AdConstants.adsModel.showCustomAd == true) {
    //   CustomInter().showInter(routeName: routeName, arg: arg, params: params);
    // } else {
    await CallAds().callInterstitialAds().then((v) async {
      FocusManager.instance.primaryFocus?.unfocus();
      print(v);
      if (v == true) {
        return await Get.toNamed<dynamic>(
          routeName,
          arguments: arg,
          parameters: params,
        );
      }
    });
    // }
  }

  static void popAndPushNamed(
    String routeName, {
    dynamic arg,
    Map<String, String>? params,
  }) {
    ///to remove navigation tap screen only
    FocusManager.instance.primaryFocus?.unfocus();
    Get.offAndToNamed<dynamic>(routeName, arguments: arg, parameters: params);
  }

  static void leftToRight(Widget child) {
    Get.to<dynamic>(() => child, transition: Transition.leftToRight);
  }

  static void rightToLeft(Widget child) {
    Get.to<dynamic>(() => child, transition: Transition.rightToLeft);
  }

  static void replace(String routeName, {dynamic arguments}) {
    Get.offNamed<dynamic>(routeName, arguments: arguments);
  }

  static void pop() {
    FocusManager.instance.primaryFocus?.unfocus();
    // Get.back<dynamic>(result: data);
    Navigator.maybePop(Get.context!);
  }

  static void doublePop() {
    Get
      ..back<dynamic>()
      ..back<dynamic>();
  }

  static void removeAll(Widget child) {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.offAll<dynamic>(child);
  }

  static void popupUtil(String routeName) {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.until((route) => Get.currentRoute == routeName);
  }

  static void replaceAll(
    String routeName, {
    dynamic arg,
    Map<String, String>? params,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.offAllNamed(routeName, arguments: arg, parameters: params);
  }
}
