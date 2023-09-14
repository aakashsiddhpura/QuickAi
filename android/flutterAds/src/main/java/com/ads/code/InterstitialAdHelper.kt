package com.ads.code;


import android.app.Activity
import android.util.Log
import com.ads.code.Constants.ISFULLYFORCEBACKADS
import com.ads.code.Constants.IsInterstitialLoad
import com.ads.code.Constants.IsInterstitialLoadCount
import com.ads.code.Constants.IsOnlyForceFullyInterstitial
import com.ads.code.Constants.appLovinInterstitial
import com.ads.code.Constants.faceBookInterstialListner
import com.ads.code.Constants.faceBookInterstitialAd
import com.ads.code.Constants.facebookAdListener
import com.ads.code.Constants.mBackInterCount
import com.ads.code.Constants.mInterCount
import com.ads.code.Constants.mInterstitialAd
import com.ads.code.Constants.maxInterstitialAd
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxAdListener
import com.applovin.mediation.MaxError
import com.applovin.mediation.ads.MaxInterstitialAd
import com.facebook.ads.Ad
import com.google.android.gms.ads.AdError
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.FullScreenContentCallback
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.interstitial.InterstitialAd
import com.google.android.gms.ads.interstitial.InterstitialAdLoadCallback


class InterstitialAdHelper {

    private var mActivity: Activity? = null
    lateinit var customProgressDialog: CustomProgressDialog


    constructor(mActivity: Activity?) {
        this.mActivity = mActivity
        customProgressDialog = CustomProgressDialog(mActivity, R.style.progress_style)
    }

    fun ShowInterAd(onAdCompleteListner: InterstitialAdShowListener) {
        if (Constants.IsOpenInterAdShow) {
            if (Constants.OpenADShow) {
                OpenInterAdHelper(mActivity).ShowOpenInterAd(object :
                    OpenInterAdHelper.OpenAdShowListener {
                    override fun onAdComplete() {
                        onAdCompleteListner.onAdComplete()
                        if (mInterCount == 0) {
                            Constants.OpenADShow = false
                        }
                    }
                })
            } else {
                onAdShow(object : InterstitialAdListener {
                    override fun onAdLoaded() {}
                    override fun onAdFailedToLoad() {
                        if (Constants.ISFULLYFORCEALLPLACEADS) {
                            onAdLoadForcefully(mActivity!!, object : InterstitialAdListener {
                                override fun onAdLoaded() {}
                                override fun onAdFailedToLoad() {
                                    if (mInterCount == 0) {
                                        Constants.OpenADShow = true
                                    }
                                    onAdCompleteListner.onAdComplete()
                                }

                                override fun onAdClosed() {
                                    if (mInterCount == 0) {
                                        Constants.OpenADShow = true
                                    }
                                    onAdCompleteListner.onAdComplete()
                                }
                            })
                        } else {
                            if (mInterCount == 0) {
                                Constants.OpenADShow = true
                            }
                            onAdCompleteListner.onAdComplete()
                        }
                    }

                    override fun onAdClosed() {
                        if (mInterCount == 0) {
                            Constants.OpenADShow = true
                        }
                        onAdCompleteListner.onAdComplete()
                    }
                })

            }

        } else {
            onAdShow(object : InterstitialAdListener {
                override fun onAdLoaded() {}
                override fun onAdFailedToLoad() {
                    if (Constants.ISFULLYFORCEALLPLACEADS) {
                        onAdLoadForcefully(mActivity!!, object : InterstitialAdListener {
                            override fun onAdLoaded() {}
                            override fun onAdFailedToLoad() {
                                onAdCompleteListner.onAdComplete()
                            }

                            override fun onAdClosed() {
                                onAdCompleteListner.onAdComplete()
                            }
                        })
                    } else {
                        onAdCompleteListner.onAdComplete()
                    }
                }

                override fun onAdClosed() {
                    onAdCompleteListner.onAdComplete()
                }
            })

        }
    }

    fun ShowBackInterAd(onAdCompleteListner: InterstitialAdShowListener) {
        if (Constants.IsBackOpenInterAdShow) {
            if (Constants.OpenADShow) {
                OpenInterAdHelper(mActivity).ShowBackOpenInterAd(object :
                    OpenInterAdHelper.OpenAdShowListener {
                    override fun onAdComplete() {
                        if (mBackInterCount == 0) {
                            Constants.OpenADShow = false
                        }
                        onAdCompleteListner.onAdComplete()
                    }
                })
            } else {
                backAdShow(object : InterstitialAdListener {
                    override fun onAdLoaded() {}
                    override fun onAdFailedToLoad() {
                        if (ISFULLYFORCEBACKADS) {
                            onAdLoadBackForcefully(
                                mActivity!!,
                                object : InterstitialAdListener {
                                    override fun onAdLoaded() {}
                                    override fun onAdFailedToLoad() {
                                        if (mBackInterCount == 0) {
                                            Constants.OpenADShow = true
                                        }
                                        onAdCompleteListner.onAdComplete()
                                    }

                                    override fun onAdClosed() {
                                        if (mBackInterCount == 0) {
                                            Constants.OpenADShow = true
                                        }
                                        onAdCompleteListner.onAdComplete()
                                    }
                                })
                        } else {
                            if (mBackInterCount == 0) {
                                Constants.OpenADShow = true
                            }
                            onAdCompleteListner.onAdComplete()
                        }
                    }

                    override fun onAdClosed() {
                        if (mBackInterCount == 0) {
                            Constants.OpenADShow = true
                        }
                        onAdCompleteListner.onAdComplete()
                    }
                })

            }

        } else {
            backAdShow(object : InterstitialAdListener {
                override fun onAdLoaded() {}
                override fun onAdFailedToLoad() {
                    if (ISFULLYFORCEBACKADS) {
                        onAdLoadBackForcefully(
                            mActivity!!,
                            object : InterstitialAdListener {
                                override fun onAdLoaded() {}
                                override fun onAdFailedToLoad() {
                                    onAdCompleteListner.onAdComplete()
                                }

                                override fun onAdClosed() {
                                    onAdCompleteListner.onAdComplete()
                                }
                            })
                    } else {
                        onAdCompleteListner.onAdComplete()
                    }
                }

                override fun onAdClosed() {
                    onAdCompleteListner.onAdComplete()
                }
            })
        }
    }


    fun onAdShow(interstitialAdListener: InterstitialAdListener) {
        if (Constants.ADSSHOW) {
            if (mInterCount != Constants.APPINTERCOUNT) {
                mInterCount += 1
                interstitialAdListener.onAdClosed()
            } else {
                if (Constants.AlterNativeAdsShow) {
                    if (Constants.AdsShowCount != Constants.AdsArray?.size) {
                        if (Constants.AdsArray!!.get(Constants.AdsShowCount).equals(Constants.Google)) {
                            if (mInterstitialAd != null) {
                                mInterCount = 0
                                mInterstitialAd!!.show(mActivity!!)
                                mInterstitialAd!!.fullScreenContentCallback =
                                    object : FullScreenContentCallback() {
                                        override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                                            super.onAdFailedToShowFullScreenContent(adError)
                                        }

                                        override fun onAdShowedFullScreenContent() {
                                            super.onAdShowedFullScreenContent()
                                            mInterstitialAd = null
                                            onAdLoad()
                                        }

                                        override fun onAdDismissedFullScreenContent() {
                                            super.onAdDismissedFullScreenContent()
                                            interstitialAdListener.onAdClosed()
                                            Constants.AdsShowCount++
                                        }
                                    }
                            } else {
                                interstitialAdListener.onAdFailedToLoad()
                            }

                        }
                        else if (Constants.AdsArray!!.get(Constants.AdsShowCount).equals(Constants.FaceBook)) {
                            if (faceBookInterstitialAd!!.isAdLoaded) {
                                mInterCount = 0
                                facebookAdListener = interstitialAdListener
                                faceBookInterstitialAd!!.show()


                            } else {
                                interstitialAdListener.onAdFailedToLoad()
                            }

                        }
                        else if (Constants.AdsArray!!.get(Constants.AdsShowCount).equals(Constants.AppLovin)) {
                            if (maxInterstitialAd != null) {
                                mInterCount = 0
                                maxInterstitialAd!!.setListener(object : MaxAdListener {
                                    override fun onAdClicked(maxAd: MaxAd) {}
                                    override fun onAdLoaded(maxAd: MaxAd) {

                                    }

                                    override fun onAdDisplayed(maxAd: MaxAd) {}
                                    override fun onAdHidden(maxAd: MaxAd) {
                                        Log.e("TAG", "onAdHidden: 1" )
                                        interstitialAdListener.onAdClosed()
                                        Constants.AdsShowCount++
                                    }

                                    override fun onAdLoadFailed(str: String, maxError: MaxError) {
                                    }
                                    override fun onAdDisplayFailed(maxAd: MaxAd, maxError: MaxError) {
                                        interstitialAdListener.onAdFailedToLoad()
                                    }
                                })
                                maxInterstitialAd!!.showAd()

                            } else {
                                interstitialAdListener.onAdFailedToLoad()
                            }

                        }


                    } else {
                        Constants.AdsShowCount = 0
                        if (Constants.AdsArray!!.get(Constants.AdsShowCount)
                                .equals(Constants.Google)
                        ) {
                            if (mInterstitialAd != null) {
                                mInterCount = 0
                                mInterstitialAd!!.show(mActivity!!)
                                mInterstitialAd!!.fullScreenContentCallback =
                                    object : FullScreenContentCallback() {
                                        override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                                            super.onAdFailedToShowFullScreenContent(adError)
                                        }

                                        override fun onAdShowedFullScreenContent() {
                                            super.onAdShowedFullScreenContent()
                                            mInterstitialAd = null
                                            onAdLoad()
                                        }

                                        override fun onAdDismissedFullScreenContent() {
                                            super.onAdDismissedFullScreenContent()
                                            interstitialAdListener.onAdClosed()
                                            Constants.AdsShowCount++
                                        }
                                    }
                            } else {
                                interstitialAdListener.onAdFailedToLoad()
                            }

                        } else if (Constants.AdsArray!!.get(Constants.AdsShowCount)
                                .equals(Constants.FaceBook)
                        ) {
                            if (faceBookInterstitialAd!!.isAdLoaded) {
                                mInterCount = 0
                                facebookAdListener = interstitialAdListener
                                faceBookInterstitialAd!!.show()


                            } else {
                                interstitialAdListener.onAdFailedToLoad()
                            }

                        } else if (Constants.AdsArray!!.get(Constants.AdsShowCount)
                                .equals(Constants.AppLovin)
                        ) {
                            if (maxInterstitialAd != null) {
                                mInterCount = 0
                                maxInterstitialAd!!.setListener(object : MaxAdListener {
                                    override fun onAdClicked(maxAd: MaxAd) {}
                                    override fun onAdLoaded(maxAd: MaxAd) {

                                    }

                                    override fun onAdDisplayed(maxAd: MaxAd) {}
                                    override fun onAdHidden(maxAd: MaxAd) {
                                        Log.e("TAG", "onAdHidden: 2" )
                                        interstitialAdListener.onAdClosed()
                                        Constants.AdsShowCount++
                                    }

                                    override fun onAdLoadFailed(str: String, maxError: MaxError) {
                                    }
                                    override fun onAdDisplayFailed(maxAd: MaxAd, maxError: MaxError) {
                                        interstitialAdListener.onAdFailedToLoad()
                                    }
                                })
                                maxInterstitialAd!!.showAd()

                            } else {
                                interstitialAdListener.onAdFailedToLoad()
                            }

                        }

                    }
                } else {
                    if (mInterstitialAd != null) {
                        mInterCount = 0
                        mInterstitialAd!!.show(mActivity!!)
                        mInterstitialAd!!.fullScreenContentCallback =
                            object : FullScreenContentCallback() {
                                override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                                    super.onAdFailedToShowFullScreenContent(adError)
                                }

                                override fun onAdShowedFullScreenContent() {
                                    super.onAdShowedFullScreenContent()
                                    mInterstitialAd = null
                                    onAdLoad()
                                }

                                override fun onAdDismissedFullScreenContent() {
                                    super.onAdDismissedFullScreenContent()
                                    interstitialAdListener.onAdClosed()
                                }
                            }
                    } else {
                        interstitialAdListener.onAdFailedToLoad()
                    }

                }
            }
        } else {
            interstitialAdListener.onAdClosed()
        }

    }

    fun backAdShow(interstitialAdListener: InterstitialAdListener) {
        if (Constants.ADSSHOW) {
            if (Constants.BACKADSSHOW) {
                if (mBackInterCount != Constants.BACKINTERCOUNT) {
                    mBackInterCount += 1
                    interstitialAdListener.onAdClosed()
                } else {

                    if (Constants.AlterNativeAdsShow) {
                        if (Constants.AdsShowCount != Constants.AdsArray?.size) {
                            if (Constants.AdsArray!!.get(Constants.AdsShowCount)
                                    .equals(Constants.Google)
                            ) {
                                if (mInterstitialAd != null) {
                                    mBackInterCount = 0
                                    mInterstitialAd?.show(mActivity!!)
                                    mInterstitialAd!!.fullScreenContentCallback =
                                        object : FullScreenContentCallback() {
                                            override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                                                super.onAdFailedToShowFullScreenContent(adError)
                                            }

                                            override fun onAdShowedFullScreenContent() {
                                                super.onAdShowedFullScreenContent()
                                                mInterstitialAd = null
                                                onAdLoad()
                                            }

                                            override fun onAdDismissedFullScreenContent() {
                                                super.onAdDismissedFullScreenContent()
                                                Constants.AdsShowCount++
                                                interstitialAdListener.onAdClosed()
                                            }
                                        }
                                } else {
                                    interstitialAdListener.onAdFailedToLoad()
                                }

                            } else if (Constants.AdsArray!!.get(Constants.AdsShowCount)
                                    .equals(Constants.FaceBook)
                            ) {
                                if (faceBookInterstitialAd!!.isAdLoaded) {
                                    mBackInterCount = 0
                                    facebookAdListener = interstitialAdListener
                                    faceBookInterstitialAd!!.show()


                                } else {
                                    interstitialAdListener.onAdFailedToLoad()
                                }

                            }else if (Constants.AdsArray!!.get(Constants.AdsShowCount)
                                    .equals(Constants.AppLovin)
                            ) {
                                if (maxInterstitialAd != null) {
                                    mInterCount = 0
                                    maxInterstitialAd!!.showAd()
                                    maxInterstitialAd!!.setListener(object : MaxAdListener {
                                        override fun onAdClicked(maxAd: MaxAd) {}
                                        override fun onAdLoaded(maxAd: MaxAd) {

                                        }

                                        override fun onAdDisplayed(maxAd: MaxAd) {}
                                        override fun onAdHidden(maxAd: MaxAd) {
                                            Log.e("TAG", "onAdHidden: 3" )
                                            interstitialAdListener.onAdClosed()
                                            Constants.AdsShowCount++
                                        }

                                        override fun onAdLoadFailed(str: String, maxError: MaxError) {
                                        }
                                        override fun onAdDisplayFailed(maxAd: MaxAd, maxError: MaxError) {
                                            interstitialAdListener.onAdFailedToLoad()
                                        }
                                    })

                                } else {
                                    interstitialAdListener.onAdFailedToLoad()
                                }

                            }

                        } else {
                            Constants.AdsShowCount = 0
                            if (Constants.AdsArray!!.get(Constants.AdsShowCount)
                                    .equals(Constants.Google)
                            ) {
                                if (mInterstitialAd != null) {
                                    mBackInterCount = 0
                                    mInterstitialAd?.show(mActivity!!)
                                    mInterstitialAd!!.fullScreenContentCallback =
                                        object : FullScreenContentCallback() {
                                            override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                                                super.onAdFailedToShowFullScreenContent(adError)
                                            }

                                            override fun onAdShowedFullScreenContent() {
                                                super.onAdShowedFullScreenContent()
                                                mInterstitialAd = null
                                                onAdLoad()
                                            }

                                            override fun onAdDismissedFullScreenContent() {
                                                super.onAdDismissedFullScreenContent()
                                                Constants.AdsShowCount++
                                                interstitialAdListener.onAdClosed()
                                            }
                                        }
                                } else {
                                    interstitialAdListener.onAdFailedToLoad()
                                }

                            } else if (Constants.AdsArray!!.get(Constants.AdsShowCount)
                                    .equals(Constants.FaceBook)
                            ) {
                                if (faceBookInterstitialAd!!.isAdLoaded) {
                                    mBackInterCount = 0
                                    facebookAdListener = interstitialAdListener
                                    faceBookInterstitialAd!!.show()


                                } else {
                                    interstitialAdListener.onAdFailedToLoad()
                                }

                            }else if (Constants.AdsArray!!.get(Constants.AdsShowCount)
                                    .equals(Constants.AppLovin)
                            ) {
                                if (maxInterstitialAd != null) {
                                    mInterCount = 0
                                    maxInterstitialAd!!.showAd()
                                    maxInterstitialAd!!.setListener(object : MaxAdListener {
                                        override fun onAdClicked(maxAd: MaxAd) {}
                                        override fun onAdLoaded(maxAd: MaxAd) {

                                        }

                                        override fun onAdDisplayed(maxAd: MaxAd) {}
                                        override fun onAdHidden(maxAd: MaxAd) {
                                            Log.e("TAG", "onAdHidden: 4" )
                                            interstitialAdListener.onAdClosed()
                                            Constants.AdsShowCount++
                                        }

                                        override fun onAdLoadFailed(str: String, maxError: MaxError) {
                                        }
                                        override fun onAdDisplayFailed(maxAd: MaxAd, maxError: MaxError) {
                                            interstitialAdListener.onAdFailedToLoad()
                                        }
                                    })

                                } else {
                                    interstitialAdListener.onAdFailedToLoad()
                                }

                            }


                        }
                    } else {
                        if (mInterstitialAd != null) {
                            mBackInterCount = 0
                            mInterstitialAd!!.show(mActivity!!)
                            mInterstitialAd!!.fullScreenContentCallback =
                                object : FullScreenContentCallback() {
                                    override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                                        super.onAdFailedToShowFullScreenContent(adError)
                                    }

                                    override fun onAdShowedFullScreenContent() {
                                        super.onAdShowedFullScreenContent()
                                        mInterstitialAd = null
                                        onAdLoad()
                                    }

                                    override fun onAdDismissedFullScreenContent() {
                                        super.onAdDismissedFullScreenContent()
                                        interstitialAdListener.onAdClosed()
                                    }
                                }
                        } else {
                            interstitialAdListener.onAdFailedToLoad()
                        }

                    }
                }
            } else {
                interstitialAdListener.onAdClosed()
            }
        } else {
            interstitialAdListener.onAdClosed()
        }


    }


    fun onAdLoad() {

        if (!IsOnlyForceFullyInterstitial) {

            if (IsInterstitialLoad) {

                IsInterstitialLoad = false

                if (mInterstitialAd == null) {

                    val adRequest = AdRequest.Builder().build()
                    InterstitialAd.load(mActivity!!, Constants.Interstitial, adRequest,
                        object : InterstitialAdLoadCallback() {
                            override fun onAdLoaded(interstitialAd: InterstitialAd) {
                                super.onAdLoaded(interstitialAd)
                                IsInterstitialLoad = true
                                mInterstitialAd = interstitialAd
                                Log.e("TAG11", "onAdLoaded: ")

                            }


                            override fun onAdFailedToLoad(loadAdError: LoadAdError) {
                                super.onAdFailedToLoad(loadAdError)
                                Log.e("TAG11", "onAdFailedToLoad: ")
                                IsInterstitialLoad = true
                                mInterstitialAd = null
                            }

                        })
                }
            } else {
                if (Constants.IsInterstitialOnlineCount != 0) {
                    IsInterstitialLoadCount += 1

                    if (IsInterstitialLoadCount >= Constants.IsInterstitialOnlineCount) {
                        IsInterstitialLoad = true
                        IsInterstitialLoadCount = 0
                    }
                }
            }
        }


    }

    fun onFacebookAdLoad() {
        AudienceNetworkInitializeHelper.initialize(mActivity)
        faceBookInterstitialAd =
            com.facebook.ads.InterstitialAd(mActivity, Constants.faceBookInterstitial)
        if (!IsOnlyForceFullyInterstitial) {

            if (!faceBookInterstitialAd!!.isAdLoaded) {
                faceBookInterstialListner = object : com.facebook.ads.InterstitialAdListener {
                    override fun onInterstitialDisplayed(ad: Ad?) {
                        Log.e("TAG", "Interstitial ad displayed.")
                    }

                    override fun onInterstitialDismissed(ad: Ad?) {
                        Log.e("TAG", "Interstitial ad dismissed.")
                        Constants.AdsShowCount++
                        if (facebookAdListener != null) {
                            facebookAdListener!!.onAdClosed()
                        }
                        onFacebookAdLoad()
                    }

                    override fun onError(ad: Ad?, adError: com.facebook.ads.AdError) {
                        Log.e("TAG", "Interstitial ad failed to load: " + adError.getErrorMessage())
                    }

                    override fun onAdLoaded(ad: Ad?) {
                        Log.d("TAG", "Interstitial ad is loaded and ready to be displayed!")
                    }

                    override fun onAdClicked(ad: Ad?) {
                        Log.d("TAG", "Interstitial ad clicked!")
                    }

                    override fun onLoggingImpression(ad: Ad?) {
                        Log.d("TAG", "Interstitial ad impression logged!")
                    }
                }

                faceBookInterstitialAd!!.loadAd(
                    faceBookInterstitialAd!!.buildLoadAdConfig()
                        .withAdListener(faceBookInterstialListner)
                        .build()
                )
            }
        }
    }

    fun onAppLovinAdLoad() {
        if (!IsOnlyForceFullyInterstitial) {

            if (maxInterstitialAd == null) {
                val applovinInterstitialAd = MaxInterstitialAd(appLovinInterstitial, mActivity)
                applovinInterstitialAd.setListener(object : MaxAdListener {
                    override fun onAdClicked(maxAd: MaxAd) {}
                    override fun onAdLoaded(maxAd: MaxAd) {

                        maxInterstitialAd = applovinInterstitialAd

                    }

                    override fun onAdDisplayed(maxAd: MaxAd) {}
                    override fun onAdHidden(maxAd: MaxAd) {
                        Log.e("TAG", "onAdHidden: 5" )
                    }

                    override fun onAdLoadFailed(str: String, maxError: MaxError) {}
                    override fun onAdDisplayFailed(maxAd: MaxAd, maxError: MaxError) {}
                })
                applovinInterstitialAd.loadAd()
            }
        }
    }


    fun onAdLoadForcefully(activity: Activity, interstitialAdListener: InterstitialAdListener) {
        customProgressDialog.showDialog()
        if (Constants.AlterNativeAdsShow) {
            if (Constants.AdsArray!!.get(Constants.AdsShowCount).equals(Constants.Google)) {
                var lInterstitialAd: InterstitialAd
                val adRequest = AdRequest.Builder().build()
                InterstitialAd.load(mActivity!!, Constants.Interstitial, adRequest,
                    object : InterstitialAdLoadCallback() {
                        override fun onAdLoaded(interstitialAd: InterstitialAd) {
                            super.onAdLoaded(interstitialAd)
                            lInterstitialAd = interstitialAd
                            lInterstitialAd.show(mActivity!!)
                            lInterstitialAd.fullScreenContentCallback =
                                object : FullScreenContentCallback() {
                                    override fun onAdDismissedFullScreenContent() {
                                        super.onAdDismissedFullScreenContent()
                                        Constants.AdsShowCount++
                                        mInterCount = 0
                                        interstitialAdListener.onAdClosed()
                                    }

                                    override fun onAdShowedFullScreenContent() {
                                        super.onAdShowedFullScreenContent()
                                        onAdLoad()
                                        customProgressDialog.hideDialog()
                                    }

                                    override fun onAdFailedToShowFullScreenContent(p0: AdError) {
                                        super.onAdFailedToShowFullScreenContent(p0)
                                        mInterCount = 0
                                        interstitialAdListener.onAdFailedToLoad()
                                    }
                                }
                        }

                        override fun onAdFailedToLoad(loadAdError: LoadAdError) {
                            super.onAdFailedToLoad(loadAdError)
                            customProgressDialog.hideDialog()
                            interstitialAdListener.onAdFailedToLoad()

                        }
                    })
            }
            else if (Constants.AdsArray!!.get(Constants.AdsShowCount).equals(Constants.FaceBook)
            ) {
                var mFaceBookInterstitialAd =
                    com.facebook.ads.InterstitialAd(mActivity, Constants.faceBookInterstitial)
                var mFaceBookInterstialListner = object : com.facebook.ads.InterstitialAdListener {
                    override fun onInterstitialDisplayed(ad: Ad?) {
                        // Interstitial ad displayed callback
                        Log.e("TAG", "Interstitial ad displayed.")
                        onFacebookAdLoad()
                        customProgressDialog.hideDialog()
                    }

                    override fun onInterstitialDismissed(ad: Ad?) {
                        // Interstitial dismissed callback
                        Log.e("TAG", "Interstitial ad dismissed.")
                        Constants.AdsShowCount++
                        mInterCount = 0
                        interstitialAdListener.onAdClosed()

                    }

                    override fun onError(ad: Ad?, adError: com.facebook.ads.AdError) {
                        // Ad error callback
                        Log.e("TAG", "Interstitial ad failed to load: " + adError.getErrorMessage())
                    }

                    override fun onAdLoaded(ad: Ad?) {
                        // Interstitial ad is loaded and ready to be displayed
                        Log.d("TAG", "Interstitial ad is loaded and ready to be displayed!")
                        // Show the ad
                        mFaceBookInterstitialAd.show()
                    }

                    override fun onAdClicked(ad: Ad?) {
                        // Ad clicked callback
                        Log.d("TAG", "Interstitial ad clicked!")
                    }

                    override fun onLoggingImpression(ad: Ad?) {
                        // Ad impression logged callback
                        Log.d("TAG", "Interstitial ad impression logged!")
                    }
                }
                AudienceNetworkInitializeHelper.initialize(mActivity)

                mFaceBookInterstitialAd.loadAd(
                    mFaceBookInterstitialAd.buildLoadAdConfig()
                        .withAdListener(mFaceBookInterstialListner)
                        .build()
                )
            }
            else if(Constants.AdsArray!!.get(Constants.AdsShowCount).equals(Constants.AppLovin)){
                val applovinInterstitialAd = MaxInterstitialAd(appLovinInterstitial, mActivity)
                applovinInterstitialAd.setListener(object : MaxAdListener {
                    override fun onAdClicked(maxAd: MaxAd) {}
                    override fun onAdLoaded(maxAd: MaxAd) {
                        applovinInterstitialAd.showAd()
                    }

                    override fun onAdDisplayed(maxAd: MaxAd) {
                        onAppLovinAdLoad()
                        customProgressDialog.hideDialog()
                    }
                    override fun onAdHidden(maxAd: MaxAd) {
                        Log.e("TAG", "onAdHidden: 6" )
                        Constants.AdsShowCount++
                        mInterCount = 0
                        interstitialAdListener.onAdClosed()
                    }

                    override fun onAdLoadFailed(str: String, maxError: MaxError) {}
                    override fun onAdDisplayFailed(maxAd: MaxAd, maxError: MaxError) {}
                })
                applovinInterstitialAd.loadAd()
            }
        } else {
            var lInterstitialAd: InterstitialAd
            val adRequest = AdRequest.Builder().build()
            InterstitialAd.load(mActivity!!, Constants.Interstitial, adRequest,
                object : InterstitialAdLoadCallback() {
                    override fun onAdLoaded(interstitialAd: InterstitialAd) {
                        super.onAdLoaded(interstitialAd)
                        lInterstitialAd = interstitialAd
                        lInterstitialAd.show(mActivity!!)
                        lInterstitialAd.fullScreenContentCallback =
                            object : FullScreenContentCallback() {
                                override fun onAdDismissedFullScreenContent() {
                                    super.onAdDismissedFullScreenContent()
                                    mInterCount = 0
                                    interstitialAdListener.onAdClosed()
                                }

                                override fun onAdShowedFullScreenContent() {
                                    super.onAdShowedFullScreenContent()
                                    onAdLoad()
                                    customProgressDialog.hideDialog()
                                }

                                override fun onAdFailedToShowFullScreenContent(p0: AdError) {
                                    super.onAdFailedToShowFullScreenContent(p0)
                                    mInterCount = 0
                                    interstitialAdListener.onAdFailedToLoad()
                                }
                            }
                    }

                    override fun onAdFailedToLoad(loadAdError: LoadAdError) {
                        super.onAdFailedToLoad(loadAdError)
                        customProgressDialog.hideDialog()
                        interstitialAdListener.onAdFailedToLoad()

                    }
                })
        }
    }


    fun onAdLoadBackForcefully(activity: Activity, interstitialAdListener: InterstitialAdListener) {
        customProgressDialog.showDialog()
        if (Constants.AlterNativeAdsShow) {
            if (Constants.AdsArray!!.get(Constants.AdsShowCount).equals(Constants.Google)) {
                var lInterstitialAd: InterstitialAd
                val adRequest = AdRequest.Builder().build()
                InterstitialAd.load(mActivity!!, Constants.Interstitial, adRequest,
                    object : InterstitialAdLoadCallback() {
                        override fun onAdLoaded(interstitialAd: InterstitialAd) {
                            super.onAdLoaded(interstitialAd)
                            lInterstitialAd = interstitialAd
                            lInterstitialAd.show(mActivity!!)

                            lInterstitialAd.fullScreenContentCallback =
                                object : FullScreenContentCallback() {
                                    override fun onAdDismissedFullScreenContent() {
                                        super.onAdDismissedFullScreenContent()
                                        Constants.AdsShowCount++
                                        mBackInterCount = 0
                                        interstitialAdListener.onAdClosed()
                                    }

                                    override fun onAdShowedFullScreenContent() {
                                        super.onAdShowedFullScreenContent()
                                        customProgressDialog.hideDialog()
                                        onAdLoad()
                                    }

                                    override fun onAdFailedToShowFullScreenContent(p0: AdError) {
                                        super.onAdFailedToShowFullScreenContent(p0)
                                        mBackInterCount = 0
                                        interstitialAdListener.onAdFailedToLoad()
                                    }
                                }
                        }

                        override fun onAdFailedToLoad(loadAdError: LoadAdError) {
                            super.onAdFailedToLoad(loadAdError)
                            customProgressDialog.hideDialog()
                            interstitialAdListener.onAdFailedToLoad()
                        }
                    })
            } else if (Constants.AdsArray!!.get(Constants.AdsShowCount)
                    .equals(Constants.FaceBook)
            ) {
                var mFaceBookInterstitialAd =
                    com.facebook.ads.InterstitialAd(mActivity, Constants.faceBookInterstitial)
                var mFaceBookInterstialListner = object : com.facebook.ads.InterstitialAdListener {
                    override fun onInterstitialDisplayed(ad: Ad?) {
                        // Interstitial ad displayed callback
                        Log.e("TAG", "Interstitial ad displayed.")
                        onFacebookAdLoad()
                        customProgressDialog.hideDialog()
                    }

                    override fun onInterstitialDismissed(ad: Ad?) {
                        // Interstitial dismissed callback
                        Log.e("TAG", "Interstitial ad dismissed.")
                        Constants.AdsShowCount++
                        mBackInterCount = 0
                        interstitialAdListener.onAdClosed()

                    }

                    override fun onError(ad: Ad?, adError: com.facebook.ads.AdError) {
                        // Ad error callback
                        Log.e("TAG", "Interstitial ad failed to load: " + adError.getErrorMessage())
                    }

                    override fun onAdLoaded(ad: Ad?) {
                        // Interstitial ad is loaded and ready to be displayed
                        Log.d("TAG", "Interstitial ad is loaded and ready to be displayed!")
                        // Show the ad
                        mFaceBookInterstitialAd.show()
                    }

                    override fun onAdClicked(ad: Ad?) {
                        // Ad clicked callback
                        Log.d("TAG", "Interstitial ad clicked!")
                    }

                    override fun onLoggingImpression(ad: Ad?) {
                        // Ad impression logged callback
                        Log.d("TAG", "Interstitial ad impression logged!")
                    }
                }
                AudienceNetworkInitializeHelper.initialize(mActivity)

                mFaceBookInterstitialAd.loadAd(
                    mFaceBookInterstitialAd.buildLoadAdConfig()
                        .withAdListener(mFaceBookInterstialListner)
                        .build()
                )
            }else if(Constants.AdsArray!!.get(Constants.AdsShowCount).equals(Constants.AppLovin)){
                val applovinInterstitialAd = MaxInterstitialAd(appLovinInterstitial, mActivity)
                applovinInterstitialAd.setListener(object : MaxAdListener {
                    override fun onAdClicked(maxAd: MaxAd) {}
                    override fun onAdLoaded(maxAd: MaxAd) {
                        applovinInterstitialAd.showAd()
                    }

                    override fun onAdDisplayed(maxAd: MaxAd) {
                        onAppLovinAdLoad()
                        customProgressDialog.hideDialog()
                    }
                    override fun onAdHidden(maxAd: MaxAd) {
                        Log.e("TAG", "onAdHidden: 7" )
                        Constants.AdsShowCount++
                        mInterCount = 0
                        interstitialAdListener.onAdClosed()
                    }

                    override fun onAdLoadFailed(str: String, maxError: MaxError) {}
                    override fun onAdDisplayFailed(maxAd: MaxAd, maxError: MaxError) {}
                })
                applovinInterstitialAd.loadAd()
            }
        } else {
            var lInterstitialAd: InterstitialAd
            val adRequest = AdRequest.Builder().build()
            InterstitialAd.load(mActivity!!, Constants.Interstitial, adRequest,
                object : InterstitialAdLoadCallback() {
                    override fun onAdLoaded(interstitialAd: InterstitialAd) {
                        super.onAdLoaded(interstitialAd)
                        lInterstitialAd = interstitialAd
                        lInterstitialAd.show(mActivity!!)

                        lInterstitialAd.fullScreenContentCallback =
                            object : FullScreenContentCallback() {
                                override fun onAdDismissedFullScreenContent() {
                                    super.onAdDismissedFullScreenContent()
                                    mBackInterCount = 0
                                    interstitialAdListener.onAdClosed()
                                }

                                override fun onAdShowedFullScreenContent() {
                                    super.onAdShowedFullScreenContent()
                                    customProgressDialog.hideDialog()
                                    onAdLoad()
                                }

                                override fun onAdFailedToShowFullScreenContent(p0: AdError) {
                                    super.onAdFailedToShowFullScreenContent(p0)
                                    mBackInterCount = 0
                                    interstitialAdListener.onAdFailedToLoad()
                                }
                            }
                    }

                    override fun onAdFailedToLoad(loadAdError: LoadAdError) {
                        super.onAdFailedToLoad(loadAdError)
                        customProgressDialog.hideDialog()
                        interstitialAdListener.onAdFailedToLoad()
                    }

                })
        }
    }


    interface InterstitialAdListener {
        fun onAdLoaded() {}
        fun onAdFailedToLoad() {}
        fun onAdClosed() {}

    }

    interface InterstitialAdShowListener {
        fun onAdComplete()
    }
}
