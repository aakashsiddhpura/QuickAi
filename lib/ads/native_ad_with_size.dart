import 'dart:io';

import 'package:fl_app/ads/big_native_view.dart';
import 'package:fl_app/ads/call_ads.dart';
import 'package:fl_app/ads/medium_native_view.dart';
import 'package:flutter/material.dart';

import '../InApp Purchase/singletons_data.dart';

class NativeAd extends StatefulWidget {
  const NativeAd({super.key});

  @override
  State<NativeAd> createState() => _NativeAdState();
}

class _NativeAdState extends State<NativeAd> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        //TODO 2nd: listen playerPointsToAdd
        valueListenable: appData.entitlementIsActive,
        builder: (BuildContext context, bool value, Widget? child) {
          if (value) {
            return SizedBox();
          } else {
            if (Platform.isAndroid) {
              if (adsModel.nativeAdSize == "big") {
                return PreBigNativeAd();
              } else {
                return PreMediumAd();
              }
            } else {
              return SizedBox();
            }
          }
        });
  }
}
