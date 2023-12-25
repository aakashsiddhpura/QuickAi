class AdModel {
  bool? sTATUS;
  String? mSG;
  APPSETTINGS? aPPSETTINGS;
  PLACEMENT? pLACEMENT;
  List<dynamic>? advertiseList;
  dynamic eXTRADATA;

  AdModel({this.sTATUS, this.mSG, this.aPPSETTINGS, this.pLACEMENT, this.advertiseList, this.eXTRADATA});

  AdModel.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    mSG = json['MSG'];
    aPPSETTINGS = json['APP_SETTINGS'] != null ? APPSETTINGS.fromJson(json['APP_SETTINGS']) : null;
    pLACEMENT = json['PLACEMENT'] != null ? PLACEMENT.fromJson(json['PLACEMENT']) : null;
    if (json['Advertise_List'] != null) {
      advertiseList = json['Advertise_List'];
    }
    eXTRADATA = json['EXTRA_DATA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['STATUS'] = sTATUS;
    data['MSG'] = mSG;
    if (aPPSETTINGS != null) {
      data['APP_SETTINGS'] = aPPSETTINGS!.toJson();
    }
    if (pLACEMENT != null) {
      data['PLACEMENT'] = pLACEMENT!.toJson();
    }
    if (advertiseList != null) {
      data['Advertise_List'] = advertiseList!.map((v) => v.toJson()).toList();
    }
    data['EXTRA_DATA'] = eXTRADATA;
    return data;
  }
}

class APPSETTINGS {
  String? appName;
  String? appAccountLink;
  String? appPackageName;
  String? appPrivacyPolicyLink;
  String? appUpdateAppDialogStatus;
  String? appVersionCode;
  String? appRedirectOtherAppStatus;
  String? appNewPackageName;
  String? appDialogBeforeAdShow;
  String? appAdShowStatus;
  String? appAppOpenAdStatus;
  String? appSplashAdType;
  String? appBackPressAdStatus;
  String? appBackPressAdType;
  String? appAdAnalysis;
  String? appAdPlatformSequence;
  String? appAlernateAdShow;
  String? appHowShowAdInterstitial;
  String? appAdPlatformSequenceInterstitial;
  String? appAlernateAdShowInterstitial;
  String? appHowShowAdNative;
  String? appAdPlatformSequenceNative;
  String? appAlernateAdShowNative;
  String? appHowShowAdBanner;
  String? appAdPlatformSequenceBanner;
  String? appAlernateAdShowBanner;
  String? appMainClickCntSwAd;
  String? appInnerClickCntSwAd;
  String? appBackPressAdLimit;
  String? appNativePreLoad;
  String? appBannerPreLoad;
  String? appNativeAdPlaceHolder;
  String? appBannerAdPlaceHolder;
  String? appAdPlaceHolderText;
  String? appNativeAdSize;
  String? appAdsButtonColor;
  String? appAdsButtonTextColor;
  String? adsNativeBgColor;
  String? apponResumeAd;
  String? appBigNativeBlink;
  String? appSmallNativeBlink;
  String? appAutoUrlonPage;
  String? appAutoPageUrl;
  String? appAllLinkShow;
  String? appBotMatch;
  String? appBotArea;
  String? appNativeBanner;
  String? appMultiNative;
  String? appUtmInstall;
  String? appUtmUrl;
  String? appUtmMatch;
  String? stopApp;
  String? appExitGameURL;
  String? appQuizHeaderShow;
  String? appAppopenInterstitialAd;
  String? appQuizHeaderUrl;
  String? appOpenAdsclick;
  String? appAutoPageUrlCount;
  String? appBackAdPlatform;
  String? exitDialog;
  String? exitScreen;
  String? appBot;
  String? appBotUrl;
  String? checkOtherIP;
  String? screen1;
  String? screen2;
  String? screen3;
  String? chatGptApikey;

  APPSETTINGS(
      {this.appName,
        this.appAccountLink,
        this.appPackageName,
        this.appPrivacyPolicyLink,
        this.appUpdateAppDialogStatus,
        this.appVersionCode,
        this.appRedirectOtherAppStatus,
        this.appNewPackageName,
        this.appDialogBeforeAdShow,
        this.appAdShowStatus,
        this.appAppOpenAdStatus,
        this.appSplashAdType,
        this.appBackPressAdStatus,
        this.appBackPressAdType,
        this.appAdAnalysis,
        this.appAdPlatformSequence,
        this.appAlernateAdShow,
        this.appHowShowAdInterstitial,
        this.appAdPlatformSequenceInterstitial,
        this.appAlernateAdShowInterstitial,
        this.appHowShowAdNative,
        this.appAdPlatformSequenceNative,
        this.appAlernateAdShowNative,
        this.appHowShowAdBanner,
        this.appAdPlatformSequenceBanner,
        this.appAlernateAdShowBanner,
        this.appMainClickCntSwAd,
        this.appInnerClickCntSwAd,
        this.appBackPressAdLimit,
        this.appNativePreLoad,
        this.appBannerPreLoad,
        this.appNativeAdPlaceHolder,
        this.appBannerAdPlaceHolder,
        this.appAdPlaceHolderText,
        this.appNativeAdSize,
        this.appAdsButtonColor,
        this.appAdsButtonTextColor,
        this.adsNativeBgColor,
        this.apponResumeAd,
        this.appBigNativeBlink,
        this.appSmallNativeBlink,
        this.appAutoUrlonPage,
        this.appAutoPageUrl,
        this.appAllLinkShow,
        this.appBotMatch,
        this.appBotArea,
        this.appNativeBanner,
        this.appMultiNative,
        this.appUtmInstall,
        this.appUtmUrl,
        this.appUtmMatch,
        this.stopApp,
        this.appExitGameURL,
        this.appQuizHeaderShow,
        this.appAppopenInterstitialAd,
        this.appQuizHeaderUrl,
        this.appOpenAdsclick,
        this.appAutoPageUrlCount,
        this.appBackAdPlatform,
        this.exitDialog,
        this.exitScreen,
        this.appBot,
        this.appBotUrl,
        this.checkOtherIP,
        this.screen1,
        this.screen2,
        this.screen3,
        this.chatGptApikey,
      });

  APPSETTINGS.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    appAccountLink = json['app_accountLink'];
    appPackageName = json['app_packageName'];
    appPrivacyPolicyLink = json['app_privacyPolicyLink'];
    appUpdateAppDialogStatus = json['app_updateAppDialogStatus'];
    appVersionCode = json['app_versionCode'];
    appRedirectOtherAppStatus = json['app_redirectOtherAppStatus'];
    appNewPackageName = json['app_newPackageName'];
    appDialogBeforeAdShow = json['app_dialogBeforeAdShow'];
    appAdShowStatus = json['app_adShowStatus'];
    appAppOpenAdStatus = json['app_AppOpenAdStatus'];
    appSplashAdType = json['app_splashAdType'];
    appBackPressAdStatus = json['app_backPressAdStatus'];
    appBackPressAdType = json['app_backPressAdType'];
    appAdAnalysis = json['app_ad_analysis'];
    appAdPlatformSequence = json['app_adPlatformSequence'];
    appAlernateAdShow = json['app_alernateAdShow'];
    appHowShowAdInterstitial = json['app_howShowAdInterstitial'];
    appAdPlatformSequenceInterstitial = json['app_adPlatformSequenceInterstitial'];
    appAlernateAdShowInterstitial = json['app_alernateAdShowInterstitial'];
    appHowShowAdNative = json['app_howShowAdNative'];
    appAdPlatformSequenceNative = json['app_adPlatformSequenceNative'];
    appAlernateAdShowNative = json['app_alernateAdShowNative'];
    appHowShowAdBanner = json['app_howShowAdBanner'];
    appAdPlatformSequenceBanner = json['app_adPlatformSequenceBanner'];
    appAlernateAdShowBanner = json['app_alernateAdShowBanner'];
    appMainClickCntSwAd = json['app_mainClickCntSwAd'];
    appInnerClickCntSwAd = json['app_innerClickCntSwAd'];
    appBackPressAdLimit = json['app_backPressAdLimit'];
    appNativePreLoad = json['appNativePreLoad'];
    appBannerPreLoad = json['appBannerPreLoad'];
    appNativeAdPlaceHolder = json['appNativeAdPlaceHolder'];
    appBannerAdPlaceHolder = json['appBannerAdPlaceHolder'];
    appAdPlaceHolderText = json['appAdPlaceHolderText'];
    appNativeAdSize = json['appNativeAdSize'];
    appAdsButtonColor = json['appAdsButtonColor'];
    appAdsButtonTextColor = json['appAdsButtonTextColor'];
    adsNativeBgColor = json['adsNativeBgColor'];
    apponResumeAd = json['apponResumeAd'];
    appBigNativeBlink = json['appBigNativeBlink'];
    appSmallNativeBlink = json['appSmallNativeBlink'];
    appAutoUrlonPage = json['appAutoUrlonPage'];
    appAutoPageUrl = json['appAutoPageUrl'];
    appAllLinkShow = json['appAllLinkShow'];
    appBotMatch = json['appBotMatch'];
    appBotArea = json['appBotArea'];
    appNativeBanner = json['appNativeBanner'];
    appMultiNative = json['appMultiNative'];
    appUtmInstall = json['appUtmInstall'];
    appUtmUrl = json['appUtmUrl'];
    appUtmMatch = json['appUtmMatch'];
    stopApp = json['StopApp'];
    appExitGameURL = json['appExitGameURL'];
    appQuizHeaderShow = json['appQuizHeaderShow'];
    appAppopenInterstitialAd = json['appAppopenInterstitialAd'];
    appQuizHeaderUrl = json['appQuizHeaderUrl'];
    appOpenAdsclick = json['appOpenAdsclick'];
    appAutoPageUrlCount = json['appAutoPageUrlCount'];
    appBackAdPlatform = json['appBackAdPlatform'];
    exitDialog = json['ExitDialog'];
    exitScreen = json['ExitScreen'];
    appBot = json['appBot'];
    appBotUrl = json['appBotUrl'];
    checkOtherIP = json['CheckOtherIP'];
    screen1 = json['Screen1'];
    screen2 = json['Screen2'];
    screen3 = json['Screen3'];
    chatGptApikey = json['chat_gpt_apikey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_name'] = appName;
    data['app_accountLink'] = appAccountLink;
    data['app_packageName'] = appPackageName;
    data['app_privacyPolicyLink'] = appPrivacyPolicyLink;
    data['app_updateAppDialogStatus'] = appUpdateAppDialogStatus;
    data['app_versionCode'] = appVersionCode;
    data['app_redirectOtherAppStatus'] = appRedirectOtherAppStatus;
    data['app_newPackageName'] = appNewPackageName;
    data['app_dialogBeforeAdShow'] = appDialogBeforeAdShow;
    data['app_adShowStatus'] = appAdShowStatus;
    data['app_AppOpenAdStatus'] = appAppOpenAdStatus;
    data['app_splashAdType'] = appSplashAdType;
    data['app_backPressAdStatus'] = appBackPressAdStatus;
    data['app_backPressAdType'] = appBackPressAdType;
    data['app_ad_analysis'] = appAdAnalysis;
    data['app_adPlatformSequence'] = appAdPlatformSequence;
    data['app_alernateAdShow'] = appAlernateAdShow;
    data['app_howShowAdInterstitial'] = appHowShowAdInterstitial;
    data['app_adPlatformSequenceInterstitial'] = appAdPlatformSequenceInterstitial;
    data['app_alernateAdShowInterstitial'] = appAlernateAdShowInterstitial;
    data['app_howShowAdNative'] = appHowShowAdNative;
    data['app_adPlatformSequenceNative'] = appAdPlatformSequenceNative;
    data['app_alernateAdShowNative'] = appAlernateAdShowNative;
    data['app_howShowAdBanner'] = appHowShowAdBanner;
    data['app_adPlatformSequenceBanner'] = appAdPlatformSequenceBanner;
    data['app_alernateAdShowBanner'] = appAlernateAdShowBanner;
    data['app_mainClickCntSwAd'] = appMainClickCntSwAd;
    data['app_innerClickCntSwAd'] = appInnerClickCntSwAd;
    data['app_backPressAdLimit'] = appBackPressAdLimit;
    data['appNativePreLoad'] = appNativePreLoad;
    data['appBannerPreLoad'] = appBannerPreLoad;
    data['appNativeAdPlaceHolder'] = appNativeAdPlaceHolder;
    data['appBannerAdPlaceHolder'] = appBannerAdPlaceHolder;
    data['appAdPlaceHolderText'] = appAdPlaceHolderText;
    data['appNativeAdSize'] = appNativeAdSize;
    data['appAdsButtonColor'] = appAdsButtonColor;
    data['appAdsButtonTextColor'] = appAdsButtonTextColor;
    data['adsNativeBgColor'] = adsNativeBgColor;
    data['apponResumeAd'] = apponResumeAd;
    data['appBigNativeBlink'] = appBigNativeBlink;
    data['appSmallNativeBlink'] = appSmallNativeBlink;
    data['appAutoUrlonPage'] = appAutoUrlonPage;
    data['appAutoPageUrl'] = appAutoPageUrl;
    data['appAllLinkShow'] = appAllLinkShow;
    data['appBotMatch'] = appBotMatch;
    data['appBotArea'] = appBotArea;
    data['appNativeBanner'] = appNativeBanner;
    data['appMultiNative'] = appMultiNative;
    data['appUtmInstall'] = appUtmInstall;
    data['appUtmUrl'] = appUtmUrl;
    data['appUtmMatch'] = appUtmMatch;
    data['StopApp'] = stopApp;
    data['appExitGameURL'] = appExitGameURL;
    data['appQuizHeaderShow'] = appQuizHeaderShow;
    data['appAppopenInterstitialAd'] = appAppopenInterstitialAd;
    data['appQuizHeaderUrl'] = appQuizHeaderUrl;
    data['appOpenAdsclick'] = appOpenAdsclick;
    data['appAutoPageUrlCount'] = appAutoPageUrlCount;
    data['appBackAdPlatform'] = appBackAdPlatform;
    data['ExitDialog'] = exitDialog;
    data['ExitScreen'] = exitScreen;
    data['appBot'] = appBot;
    data['appBotUrl'] = appBotUrl;
    data['CheckOtherIP'] = checkOtherIP;
    data['Screen1'] = screen1;
    data['Screen2'] = screen2;
    data['Screen3'] = screen3;
    data['chat_gpt_apikey'] = chatGptApikey;
    return data;
  }
}

class PLACEMENT {
  Admob? admob;
  Facebookaudiencenetwork? facebookaudiencenetwork;
  MyCustomAds? myCustomAds;
  Applovin? applovin;

  PLACEMENT({this.admob, this.facebookaudiencenetwork, this.myCustomAds, this.applovin});

  PLACEMENT.fromJson(Map<String, dynamic> json) {
    admob = json['Admob'] != null ? Admob.fromJson(json['Admob']) : null;
    facebookaudiencenetwork = json['Facebookaudiencenetwork'] != null ? Facebookaudiencenetwork.fromJson(json['Facebookaudiencenetwork']) : null;
    myCustomAds = json['MyCustomAds'] != null ? MyCustomAds.fromJson(json['MyCustomAds']) : null;
    applovin = json['Applovin'] != null ? Applovin.fromJson(json['Applovin']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (admob != null) {
      data['Admob'] = admob!.toJson();
    }
    if (facebookaudiencenetwork != null) {
      data['Facebookaudiencenetwork'] = facebookaudiencenetwork!.toJson();
    }
    if (myCustomAds != null) {
      data['MyCustomAds'] = myCustomAds!.toJson();
    }
    if (applovin != null) {
      data['Applovin'] = applovin!.toJson();
    }
    return data;
  }
}

class Admob {
  String? adShowAdStatus;
  String? adLoadAdIdsType;
  String? appID;
  String? banner1;
  String? interstitial1;
  String? native1;
  String? rewardedVideo1;
  String? rewardedInterstitial1;
  String? appOpen1;

  Admob(
      {this.adShowAdStatus,
        this.adLoadAdIdsType,
        this.appID,
        this.banner1,
        this.interstitial1,
        this.native1,
        this.rewardedVideo1,
        this.rewardedInterstitial1,
        this.appOpen1});

  Admob.fromJson(Map<String, dynamic> json) {
    adShowAdStatus = json['ad_showAdStatus'];
    adLoadAdIdsType = json['ad_loadAdIdsType'];
    appID = json['AppID'];
    banner1 = json['Banner1'];
    interstitial1 = json['Interstitial1'];
    native1 = json['Native1'];
    rewardedVideo1 = json['RewardedVideo1'];
    rewardedInterstitial1 = json['RewardedInterstitial1'];
    appOpen1 = json['AppOpen1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ad_showAdStatus'] = adShowAdStatus;
    data['ad_loadAdIdsType'] = adLoadAdIdsType;
    data['AppID'] = appID;
    data['Banner1'] = banner1;
    data['Interstitial1'] = interstitial1;
    data['Native1'] = native1;
    data['RewardedVideo1'] = rewardedVideo1;
    data['RewardedInterstitial1'] = rewardedInterstitial1;
    data['AppOpen1'] = appOpen1;
    return data;
  }
}

class Facebookaudiencenetwork {
  String? adShowAdStatus;
  String? adLoadAdIdsType;
  String? banner1;
  String? interstitial1;
  String? native1;
  String? rewardedVideo1;
  String? nativeBanner1;

  Facebookaudiencenetwork(
      {this.adShowAdStatus, this.adLoadAdIdsType, this.banner1, this.interstitial1, this.native1, this.rewardedVideo1, this.nativeBanner1});

  Facebookaudiencenetwork.fromJson(Map<String, dynamic> json) {
    adShowAdStatus = json['ad_showAdStatus'];
    adLoadAdIdsType = json['ad_loadAdIdsType'];
    banner1 = json['Banner1'];
    interstitial1 = json['Interstitial1'];
    native1 = json['Native1'];
    rewardedVideo1 = json['RewardedVideo1'];
    nativeBanner1 = json['NativeBanner1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ad_showAdStatus'] = adShowAdStatus;
    data['ad_loadAdIdsType'] = adLoadAdIdsType;
    data['Banner1'] = banner1;
    data['Interstitial1'] = interstitial1;
    data['Native1'] = native1;
    data['RewardedVideo1'] = rewardedVideo1;
    data['NativeBanner1'] = nativeBanner1;
    return data;
  }
}

class MyCustomAds {
  String? adShowAdStatus;
  String? adLoadAdIdsType;

  MyCustomAds({this.adShowAdStatus, this.adLoadAdIdsType});

  MyCustomAds.fromJson(Map<String, dynamic> json) {
    adShowAdStatus = json['ad_showAdStatus'];
    adLoadAdIdsType = json['ad_loadAdIdsType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ad_showAdStatus'] = adShowAdStatus;
    data['ad_loadAdIdsType'] = adLoadAdIdsType;
    return data;
  }
}

class Applovin {
  String? adShowAdStatus;
  String? adLoadAdIdsType;
  String? banner1;
  String? interstitial1;
  String? native1;

  Applovin({this.adShowAdStatus, this.adLoadAdIdsType, this.banner1, this.interstitial1, this.native1});

  Applovin.fromJson(Map<String, dynamic> json) {
    adShowAdStatus = json['ad_showAdStatus'];
    adLoadAdIdsType = json['ad_loadAdIdsType'];
    banner1 = json['Banner1'];
    interstitial1 = json['Interstitial1'];
    native1 = json['Native1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ad_showAdStatus'] = adShowAdStatus;
    data['ad_loadAdIdsType'] = adLoadAdIdsType;
    data['Banner1'] = banner1;
    data['Interstitial1'] = interstitial1;
    data['Native1'] = native1;
    return data;
  }
}
