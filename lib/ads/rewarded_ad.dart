import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:applovin_max/applovin_max.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:fl_app/controller/premium_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../InApp Purchase/singletons_data.dart';
import '../widget/loader.dart';

var notificationRewardCollected = ValueNotifier<bool>(false);

class RewardedAdController extends GetxController {
  PremiumController premiumController = Get.put(PremiumController());
  RewardedAd? _rewardedAd;
  String? admobReward;
  String? fbReward;
  String? appLovinReward;
  bool rewardCollected = false;
  bool adLoaded = false;
  Random random = Random();
  AdSettings? adSettings;

  Future<AdSettings?> getAdsData() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('ads').doc(Platform.isIOS ? "ios" : "android").get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        adSettings = AdSettings.fromJson(data);
        update();
        loadRewardedAds();
        return AdSettings.fromJson(data);
      }
    } catch (e) {
      print('Error getting ad settings: $e');
    }
    return null;
  }

  void setRandomAdId() {
    admobReward = adSettings!.googleRewardId;

    fbReward = adSettings!.fbRewardId;

    appLovinReward = adSettings!.applovinRewardId;
    update();
  }

  Future<void> loadRewardedAds() async {
    setRandomAdId();
    if (adSettings!.showAd == true) {
      if (adSettings!.rewardAdType == "google") {
        loadAdmobReward();
      } else if (adSettings!.rewardAdType == "facebook") {
        loadFBReward();
      } else if (adSettings!.rewardAdType == "applovin") {
        loadAppLovinReward();
      }
    }
  }

  /// Loads a rewarded ad.
  void loadAdmobReward() {
    RewardedAd.load(
        adUnitId: "$admobReward",
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            adLoaded = true;

            ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdShowedFullScreenContent: (ad) {},
                onAdImpression: (ad) {},
                onAdFailedToShowFullScreenContent: (ad, err) {
                  ad.dispose();
                  loadAdmobReward();
                  adLoaded = false;
                },
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                  loadAdmobReward();
                  adLoaded = false;
                },
                onAdClicked: (ad) {});

            _rewardedAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            adLoaded = false;
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  void loadFBReward() {
    FacebookRewardedVideoAd.loadRewardedVideoAd(
      placementId: '$fbReward',

      listener: (result, value) {
        if (result == RewardedVideoAdResult.VIDEO_COMPLETE) {
          rewardCollected = true;
          notificationRewardCollected.value = true;
          adLoaded = false;

          update();
          loadFBReward();
        }
        if (result == RewardedVideoAdResult.ERROR) {
          loadFBReward();
          adLoaded = false;
        }
        if (result == RewardedVideoAdResult.LOADED) {
          adLoaded = true;
        }
        if (result == RewardedVideoAdResult.VIDEO_CLOSED) {
          adLoaded = false;
        }
      },
    );
  }

  void loadAppLovinReward() {
    AppLovinMAX.setRewardedAdListener(
      RewardedAdListener(
        onAdLoadedCallback: (ad) {
          adLoaded = true;

          print('Rewarded ad loaded from ' + ad.networkName);
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          adLoaded = false;

          Future.delayed(Duration(seconds: 5), () {
            AppLovinMAX.loadRewardedAd("$appLovinReward");
          });
        },
        onAdDisplayedCallback: (ad) {},
        onAdDisplayFailedCallback: (ad, error) {},
        onAdClickedCallback: (ad) {},
        onAdHiddenCallback: (ad) {
          adLoaded = false;

          loadAppLovinReward();
        },
        onAdReceivedRewardCallback: (ad, reward) {
          loadAppLovinReward();
        },
      ),
    );
  }

  /// show reward ad
  Future<bool> showRewardAd() async {
    rewardCollected = false;
    notificationRewardCollected.value = false;

    if (adSettings!.showAd == true && appData.entitlementIsActive.value == false) {
      if (admobReward!.isNotEmpty && _rewardedAd != null && adLoaded) {
        Loader.sw();

        await _rewardedAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
          rewardCollected = true;
          notificationRewardCollected.value = true;

          update();
        });
        Loader.hd();
        return rewardCollected;
      } else if (fbReward!.isNotEmpty && adLoaded) {
        Loader.sw();

        await FacebookRewardedVideoAd.showRewardedVideoAd();
        Loader.hd();
        return rewardCollected;
      } else if (appLovinReward!.isNotEmpty && adLoaded) {
        bool isReady = (await AppLovinMAX.isRewardedAdReady("$appLovinReward"))!;

        if (isReady) {
          Loader.sw();

          AppLovinMAX.showRewardedAd("$appLovinReward");
          Loader.hd();
          return rewardCollected;
        } else {
          Loader.sw();

          loadAppLovinReward();
          Future.delayed(
            const Duration(milliseconds: 200),
            () => AppLovinMAX.showRewardedAd("$appLovinReward"),
          );
          Loader.hd();
          return rewardCollected;
        }
      }
    }
    return rewardCollected;
  }

  @override
  void onInit() {
    // loadRewardedAds();
    super.onInit();
  }

  @override
  // TODO: implement onDelete
  InternalFinalCallback<void> get onDelete => super.onDelete;
}

class AdSettings {
  final String applovinRewardId;
  final String fbRewardId;
  final String googleRewardId;
  final String rewardAdType;
  final bool showAd;

  AdSettings({
    required this.applovinRewardId,
    required this.fbRewardId,
    required this.googleRewardId,
    required this.rewardAdType,
    required this.showAd,
  });

  factory AdSettings.fromJson(Map<String, dynamic> json) {
    return AdSettings(
      applovinRewardId: json['applovin_reward_id'] ?? '',
      fbRewardId: json['fb_reward_id'] ?? '',
      googleRewardId: json['google_reward_id'] ?? '',
      rewardAdType: json['reward_ad_type'] ?? '',
      showAd: json['show_ad'] ?? false,
    );
  }
}
