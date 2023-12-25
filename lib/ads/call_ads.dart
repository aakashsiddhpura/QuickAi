import 'dart:convert';

import 'package:ak_ads_plugin/ak_ads_plugin.dart';
import 'package:fl_app/ads/ads_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../main.dart';

bool isAd = false;
dynamic adResponse;
AdModel adModel = AdModel();

class CallAds {
  AkAdsPlugin akAdsPlugin = AkAdsPlugin();
  Future getApiResponse({bool? adShow}) async {
    try {
      adResponse = await akAdsPlugin.getApiResponse(arguments: {"ad_show": adShow});
      adModel = AdModel.fromJson(jsonDecode(adResponse));
      return adResponse;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to call open ad: '${e.message}'.");
      }
      return true;
    }
  }
}
