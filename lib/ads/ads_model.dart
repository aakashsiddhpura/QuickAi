class AdsModel {
  bool? backAdsShow;
  bool? splashAdShow;
  bool? adsShow;
  bool? splashOpenAdShow;
  bool? onResumeAdShow;
  String? googleIntertital;
  String? googleAppOpenAd;
  String? googleNative;
  String? googleBanner;
  String? facebookInterstitial;
  String? facebookBanner;
  String? facebookMediumNative;
  String? facebookNative;
  String? applovinInterstitial;
  String? applovinBanner;
  String? applovinNative;
  int? appInterCount;
  int? backInterCount;
  bool? isFullyForceOpenInter;
  bool? isFullyForceBackOpenInter;
  bool? isOpenInterAdShow;
  bool? isBackOpenInterAdShow;
  bool? isFullyForceAllPlaceAds;
  bool? isFullyForceBackAds;
  bool? isFullyForceNative;
  bool? isFullyForceMediumNative;
  bool? isFullyForceSmallNative;
  int? isInterOnlineLoadCount;
  int? isOpenOnlineLoadCount;
  int? isNativeBigOnlineLoadCount;
  int? isNativeMediumOnlineLoadCount;
  int? isNativeSmallOnlineLoadCount;
  bool? isOnlyForceFullyInterstitial;
  bool? isOnlyForceFullyOpen;
  bool? isOnlyForceFullyNativeBig;
  bool? isOnlyForceFullyNativeMedium;
  bool? isOnlyForceFullyNativeSmall;
  bool? googleAdsShow;
  bool? faceBookAdsShow;
  bool? apploinAdsShow;
  bool? alterNativeAdsShow;
  bool? gameAdsShow;
  List<String>? gameAdsUrl;
  String? nativeAdSize;
  bool? multiNative;
  bool? showScreen1;
  bool? showScreen2;
  bool? showScreen3;
  int? version;

  AdsModel(
      {this.backAdsShow,
      this.splashAdShow,
      this.adsShow,
      this.splashOpenAdShow,
      this.onResumeAdShow,
      this.googleIntertital,
      this.googleAppOpenAd,
      this.googleNative,
      this.googleBanner,
      this.facebookInterstitial,
      this.facebookBanner,
      this.facebookMediumNative,
      this.facebookNative,
      this.applovinInterstitial,
      this.applovinBanner,
      this.applovinNative,
      this.appInterCount,
      this.backInterCount,
      this.isFullyForceOpenInter,
      this.isFullyForceBackOpenInter,
      this.isOpenInterAdShow,
      this.isBackOpenInterAdShow,
      this.isFullyForceAllPlaceAds,
      this.isFullyForceBackAds,
      this.isFullyForceNative,
      this.isFullyForceMediumNative,
      this.isFullyForceSmallNative,
      this.isInterOnlineLoadCount,
      this.isOpenOnlineLoadCount,
      this.isNativeBigOnlineLoadCount,
      this.isNativeMediumOnlineLoadCount,
      this.isNativeSmallOnlineLoadCount,
      this.isOnlyForceFullyInterstitial,
      this.isOnlyForceFullyOpen,
      this.isOnlyForceFullyNativeBig,
      this.isOnlyForceFullyNativeMedium,
      this.isOnlyForceFullyNativeSmall,
      this.googleAdsShow,
      this.faceBookAdsShow,
      this.apploinAdsShow,
      this.alterNativeAdsShow,
      this.gameAdsShow,
      this.nativeAdSize,
      this.multiNative,
      this.showScreen1,
      this.showScreen2,
      this.showScreen3,
      this.version,
      this.gameAdsUrl});

  AdsModel.fromJson(Map<String, dynamic> json) {
    backAdsShow = json['back_ads_show'];
    splashAdShow = json['splash_ad_show'];
    adsShow = json['ads_show'];
    splashOpenAdShow = json['splash_open_ad_show'];
    onResumeAdShow = json['on_resume_ad_show'];
    googleIntertital = json['google_intertital'];
    googleAppOpenAd = json['google_appOpenAd'];
    googleNative = json['google_native'];
    googleBanner = json['google_banner'];
    facebookInterstitial = json['facebook_interstitial'];
    facebookBanner = json['facebook_banner'];
    facebookMediumNative = json['facebook_medium_native'];
    facebookNative = json['facebook_native'];
    applovinInterstitial = json['applovin_interstitial'];
    applovinBanner = json['applovin_banner'];
    applovinNative = json['applovin_native'];
    appInterCount = json['app_inter_Count'];
    backInterCount = json['back_inter_Count'];
    isFullyForceOpenInter = json['is_fully_force_open_inter'];
    isFullyForceBackOpenInter = json['is_fully_force_back_open_inter'];
    isOpenInterAdShow = json['is_open_inter_ad_show'];
    isBackOpenInterAdShow = json['is_back_open_inter_ad_show'];
    isFullyForceAllPlaceAds = json['is_fully_force_all_place_ads'];
    isFullyForceBackAds = json['is_fully_force_back_ads'];
    isFullyForceNative = json['is_fully_force_native'];
    isFullyForceMediumNative = json['is_fully_force_medium_native'];
    isFullyForceSmallNative = json['is_fully_force_small_native'];
    isInterOnlineLoadCount = json['is_inter_online_load_count'];
    isOpenOnlineLoadCount = json['is_open_online_load_count'];
    isNativeBigOnlineLoadCount = json['is_nativeBig_online_load_count'];
    isNativeMediumOnlineLoadCount = json['is_nativeMedium_online_load_count'];
    isNativeSmallOnlineLoadCount = json['is_nativeSmall_online_load_count'];
    isOnlyForceFullyInterstitial = json['is_only_force_fully_interstitial'];
    isOnlyForceFullyOpen = json['is_only_force_fully_open'];
    isOnlyForceFullyNativeBig = json['is_only_force_fully_nativeBig'];
    isOnlyForceFullyNativeMedium = json['is_only_force_fully_nativeMedium'];
    isOnlyForceFullyNativeSmall = json['is_only_force_fully_nativeSmall'];
    googleAdsShow = json['google_ads_show'];
    faceBookAdsShow = json['face_book_ads_show'];
    apploinAdsShow = json['apploin_ads_show'];
    alterNativeAdsShow = json['alter_native_ads_show'];
    gameAdsShow = json['game_ads_show'];
    gameAdsUrl = json['game_ads_url'].cast<String>();
    nativeAdSize = json['native_ad_size'];
    multiNative = json['multi_native'];
    showScreen1 = json['show_screen_1'];
    showScreen2 = json['show_screen_2'];
    showScreen3 = json['show_screen_3'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['back_ads_show'] = backAdsShow;
    data['splash_ad_show'] = splashAdShow;
    data['ads_show'] = adsShow;
    data['splash_open_ad_show'] = splashOpenAdShow;
    data['on_resume_ad_show'] = onResumeAdShow;
    data['google_intertital'] = googleIntertital;
    data['google_appOpenAd'] = googleAppOpenAd;
    data['google_native'] = googleNative;
    data['google_banner'] = googleBanner;
    data['facebook_interstitial'] = facebookInterstitial;
    data['facebook_banner'] = facebookBanner;
    data['facebook_medium_native'] = facebookMediumNative;
    data['facebook_native'] = facebookNative;
    data['applovin_interstitial'] = applovinInterstitial;
    data['applovin_banner'] = applovinBanner;
    data['applovin_native'] = applovinNative;
    data['app_inter_Count'] = appInterCount;
    data['back_inter_Count'] = backInterCount;
    data['is_fully_force_open_inter'] = isFullyForceOpenInter;
    data['is_fully_force_back_open_inter'] = isFullyForceBackOpenInter;
    data['is_open_inter_ad_show'] = isOpenInterAdShow;
    data['is_back_open_inter_ad_show'] = isBackOpenInterAdShow;
    data['is_fully_force_all_place_ads'] = isFullyForceAllPlaceAds;
    data['is_fully_force_back_ads'] = isFullyForceBackAds;
    data['is_fully_force_native'] = isFullyForceNative;
    data['is_fully_force_medium_native'] = isFullyForceMediumNative;
    data['is_fully_force_small_native'] = isFullyForceSmallNative;
    data['is_inter_online_load_count'] = isInterOnlineLoadCount;
    data['is_open_online_load_count'] = isOpenOnlineLoadCount;
    data['is_nativeBig_online_load_count'] = isNativeBigOnlineLoadCount;
    data['is_nativeMedium_online_load_count'] = isNativeMediumOnlineLoadCount;
    data['is_nativeSmall_online_load_count'] = isNativeSmallOnlineLoadCount;
    data['is_only_force_fully_interstitial'] = isOnlyForceFullyInterstitial;
    data['is_only_force_fully_open'] = isOnlyForceFullyOpen;
    data['is_only_force_fully_nativeBig'] = isOnlyForceFullyNativeBig;
    data['is_only_force_fully_nativeMedium'] = isOnlyForceFullyNativeMedium;
    data['is_only_force_fully_nativeSmall'] = isOnlyForceFullyNativeSmall;
    data['google_ads_show'] = googleAdsShow;
    data['face_book_ads_show'] = faceBookAdsShow;
    data['apploin_ads_show'] = apploinAdsShow;
    data['alter_native_ads_show'] = alterNativeAdsShow;
    data['game_ads_show'] = gameAdsShow;
    data['game_ads_url'] = gameAdsUrl;
    data['native_ad_size'] = nativeAdSize;
    data['native_ad_size'] = nativeAdSize;
    data['multi_native'] = multiNative;
    data['show_screen_1'] = showScreen1;
    data['show_screen_2'] = showScreen2;
    data['show_screen_3'] = showScreen3;
    data['version'] = version;
    return data;
  }
}
