import 'dart:convert';

import 'package:fl_app/ads/ads_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../main.dart';

bool isAd = false;
dynamic adResponse;
AdsModel adsModel = AdsModel();

class CallAds {
  Future getApiResponse() async {
    try {
      adResponse = await platform.invokeMethod('adResponse');
      adsModel = AdsModel.fromJson(jsonDecode(adResponse));
      return adResponse;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to call open ad: '${e.message}'.");
      }
      return true;
    }
  }

  Future callAppOpenAds() async {
    try {
      await platform.invokeMethod('ADOpen');
      return true;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to call open ad: '${e.message}'.");
      }
      return true;
    }
  }

  Future<bool> callInterstitialAds() async {
    try {
      return await platform.invokeMethod('Interstitial');
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to call interstitial ad: '${e.message}'.");
      }
      return true;
    }
  }

  Future<bool> callBackAds() async {
    try {
      return await platform.invokeMethod('backAd');
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to call interstitial ad: '${e.message}'.");
      }
      return true;
    }
  }

  Future callCloseInterstitialAds() async {
    try {
      await platform.invokeMethod('CloseInterstitial');
      return true;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to get battery level: '${e.message}'.");
      }
      return true;
    }
  }

  adsONorOFf() async {
    try {
      var result = await platform.invokeMethod('isAD');
      isAd = result;
    } on PlatformException catch (e) {
      isAd = false;
    }
  }
}
