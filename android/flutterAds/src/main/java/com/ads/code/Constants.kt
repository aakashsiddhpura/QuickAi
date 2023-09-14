package com.ads.code;

import com.applovin.mediation.ads.MaxAdView
import com.applovin.mediation.ads.MaxInterstitialAd
import com.applovin.mediation.nativeAds.MaxNativeAdView
import com.facebook.ads.AdView
import com.facebook.ads.InterstitialAdListener
import com.google.android.gms.ads.appopen.AppOpenAd
import com.google.android.gms.ads.interstitial.InterstitialAd
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import org.json.JSONArray

object Constants {

    var  mInterCount = 0
    var mBackInterCount = 0
    var mInterstitialAd: InterstitialAd? = null
    var mAppOpenAd: AppOpenAd? = null
    var adView: NativeAdView? = null
    var nativeAds: NativeAd? = null
    var adMediumView: NativeAdView? = null
    var nativeMediumAds: NativeAd? = null
    var adSmallView: NativeAdView? = null
    var nativeSmallAds: NativeAd? = null

    var IsInterstitialLoad:Boolean =true
    var IsFacebookInterstitialLoad:Boolean =true
    var IsOpenAdLoad:Boolean =true
    var IsNativeBigLoad:Boolean =true
    var IsNativeMediumLoad:Boolean =true
    var IsNativeSmallLoad:Boolean =true

    var IsInterstitialLoadCount:Int =0
    var IsOpenLoadCount:Int =0
    var IsNativeBigLoadCount:Int =0
    var IsNativeMediumLoadCount:Int =0
    var IsNativeSmallLoadCount:Int =0

    var IsInterstitialOnlineCount:Int =1
    var IsOpenOnlineCount:Int =1
    var IsNativeBigOnlineCount:Int =1
    var IsNativeMediumOnlineCount:Int =1
    var IsNativeSmallOnlineCount:Int =1

    var IsOnlyForceFullyInterstitial:Boolean =false
    var IsOnlyForceFullyOpen:Boolean =false
    var IsOnlyForceFullyNativeBig:Boolean =false
    var IsOnlyForceFullyNativeMedium:Boolean =false
    var IsOnlyForceFullyNativeSmall:Boolean =false

    var IsFullyForceOpenInter: Boolean = false
    var IsFullyForceBackOpenInter: Boolean = false

    var IsOpenInterAdShow : Boolean = false
    var IsBackOpenInterAdShow : Boolean = false
    var OpenADShow : Boolean = true

    var IsFullyForceNative: Boolean = true
    var IsFullyForceSmallNative: Boolean = true
    var IsFullyForceMediumNative: Boolean = true

    var Interstitial: String = "/6499/example/interstitial"
    var Native: String = "/6499/example/native"
    var Native_1: String = "/6499/example/native"
    var AppOpen: String = "/6499/example/app-open"
    var SplashOpenAdShow: Boolean = true
    var OnResumeAdShow: Boolean = true

    // New Meditation

    var GoogleAdsShow = true
    var FaceBookAdsShow = false
    var AppLovinAdsShow = true

    var AlterNativeAdsShow = true

    var Google = "google"
    var FaceBook = "facebook"
    var AppLovin = "applovin"

    var AdsArray : ArrayList<String>? = null

    var AdsShowCount = 0
    var NativeSmallAdsShowCount = 0
    var NativeMediumAdsShowCount = 0
    var NativeBigAdsShowCount = 0

    // Facebook
    var faceBookInterstitialAd : com.facebook.ads.InterstitialAd? = null
    var faceBookInterstialListner : InterstitialAdListener? = null
    var facebookAdListener: InterstitialAdHelper.InterstitialAdListener? = null
    var faceBookInterstitial: String = "IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID"
    var faceBookBanner : String ="IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID"
    var faceBookMedium : String ="IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID"
    var faceBookNative : String ="IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID"
    var faceBookAdView : AdView? = null
    var faceBookNativeAd : com.facebook.ads.NativeAd? = null
    var faceBookMediumAd : com.facebook.ads.NativeAd? = null
    //AppLovin
    var appLovinInterstitial : String ="ea51571071640bce"
    var appLovinBanner : String ="bc2527d81eac5b24"
    var appLovinNative : String ="5afa13359bfa5c14"
    var maxAdView : MaxAdView? = null
    var maxInterstitialAd : MaxInterstitialAd? = null
    var maxApplovinNativeAdView : MaxNativeAdView? = null
    var maxApplovinNativeMediumAdView : MaxNativeAdView? = null
    //Game
    var GameAdShow : Boolean = false
    var GameAdUrl : JSONArray = JSONArray()
    var GameAdCount : Int = 0
    //refrral
    var installTrack : Boolean = false
    var matchTrackUrl : Boolean = false
    var trackUrl : JSONArray = JSONArray()

    var APPINTERCOUNT: Int = 100
    var BACKINTERCOUNT: Int = 100
    var ISFULLYFORCEALLPLACEADS: Boolean = true
    var ISFULLYFORCEBACKADS: Boolean = true
    var BACKADSSHOW: Boolean = true
    var SPLASHADSHOW: Boolean = true
    var ADSSHOW: Boolean = true


}