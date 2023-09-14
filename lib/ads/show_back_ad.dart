import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'call_ads.dart';

class AdWillPopScope extends StatefulWidget {
  final Widget child;

  AdWillPopScope({required this.child});

  @override
  _AdWillPopScopeState createState() => _AdWillPopScopeState();
}

class _AdWillPopScopeState extends State<AdWillPopScope> {
  bool _isBackPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showAdAndBack() async {
    if (adsModel.adsShow == true) {
      if (adsModel.backAdsShow == true) {
        // if (CallAds().adsModel.showCustomAd == true) {
        //   CustomInter().showInter();
        // } else {
        CallAds().callInterstitialAds().then((value) {
          Get.back();
        });
        // }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!_isBackPressed && adsModel.adsShow == true && adsModel.backAdsShow == true) {
          _isBackPressed = true;
          _showAdAndBack();
          return false;
        } else {
          return Future.value(true);
        }
      },
      child: widget.child,
    );
  }
}
