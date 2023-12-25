import 'dart:io';

import 'package:ak_ads_plugin/ads/native_ad_view.dart';
import 'package:flutter/material.dart';

import '../InApp Purchase/singletons_data.dart';


class BannerView extends StatefulWidget {
  final double? height;

  const BannerView({super.key, this.height});

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
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
              return NativeAdView(adSize: "small");
            } else {
              return SizedBox();
            }
          }
        });
  }

}
