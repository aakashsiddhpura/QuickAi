package com.ads.code

import android.app.Activity
import com.google.android.gms.ads.AdError
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.FullScreenContentCallback
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.appopen.AppOpenAd
import com.google.android.gms.ads.appopen.AppOpenAd.AppOpenAdLoadCallback
import com.ads.code.R


class OpenInterAdHelper() {
    private var mActivity: Activity? = null
    constructor(mActivity: Activity?) : this() {
        this.mActivity = mActivity
    }


    fun ShowOpenInterAd( openAdShowListener: OpenAdShowListener) {
        OpenInterShow(object : OpenAdListener {
            override fun onAdLoaded() {}
            override fun onAdFailedToLoad() {
                if (Constants.IsFullyForceOpenInter) {
                    onAdLoadOpenInterForcefully(object :
                        OpenAdListener {
                        override fun onAdLoaded() {}
                        override fun onAdFailedToLoad() {
                            openAdShowListener.onAdComplete()
                        }

                        override fun onAdClosed() {
                            openAdShowListener.onAdComplete()
                        }
                    })
                } else {
                    openAdShowListener.onAdComplete()
                }
            }

            override fun onAdClosed() {
                openAdShowListener.onAdComplete()
            }
        })

    }

    fun ShowBackOpenInterAd( openAdShowListener: OpenAdShowListener) {
        BackOpenInterShow(object : OpenAdListener {
            override fun onAdLoaded() {}
            override fun onAdFailedToLoad() {
                if (Constants.IsFullyForceBackOpenInter) {
                    onAdLoadBackOpenInterForcefully(object :
                        OpenAdListener {
                        override fun onAdLoaded() {}
                        override fun onAdFailedToLoad() {
                            openAdShowListener.onAdComplete()
                        }

                        override fun onAdClosed() {
                            openAdShowListener.onAdComplete()
                        }
                    })
                } else {
                    openAdShowListener.onAdComplete()
                }
            }

            override fun onAdClosed() {
                openAdShowListener.onAdComplete()
            }
        })

    }



    fun OpenInterLoad() {

        if (!Constants.IsOnlyForceFullyOpen){

            if (Constants.IsOpenAdLoad){

                Constants.IsOpenAdLoad = false

                if (Constants.mAppOpenAd == null) {
                    var adRequest = AdRequest.Builder().build()
                    AppOpenAd.load(mActivity!!,
                        Constants.AppOpen,
                        adRequest,
                        AppOpenAd.APP_OPEN_AD_ORIENTATION_PORTRAIT,
                        object : AppOpenAdLoadCallback() {
                            override fun onAdLoaded(appOpenAd: AppOpenAd) {
                                super.onAdLoaded(appOpenAd)
                                Constants.mAppOpenAd = appOpenAd
                                Constants.IsOpenAdLoad = true
                            }

                            override fun onAdFailedToLoad(loadAdError: LoadAdError) {
                                super.onAdFailedToLoad(loadAdError)
                                Constants.mAppOpenAd = null
                                Constants.IsOpenAdLoad = true
                            }
                        })
                }

            }else{

                if (Constants.IsOpenOnlineCount != 0){
                    Constants.IsOpenLoadCount += 1

                    if (Constants.IsOpenLoadCount >= Constants.IsOpenOnlineCount){
                        Constants.IsOpenAdLoad = true
                        Constants.IsOpenLoadCount = 0
                    }
                }

            }
        }




    }

    fun OpenInterShow( adListener: OpenAdListener) {
        if (Constants.ADSSHOW) {
            if (Constants.mInterCount != Constants.APPINTERCOUNT) {
                Constants.mInterCount += 1
                adListener.onAdClosed()
            } else {
                if (Constants.mAppOpenAd != null) {
                    Constants.mInterCount = 0

                    Constants.mAppOpenAd!!.show(mActivity!!)
                    Constants.mAppOpenAd!!.fullScreenContentCallback =
                        object : FullScreenContentCallback() {
                            override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                                super.onAdFailedToShowFullScreenContent(adError)
                            }

                            override fun onAdShowedFullScreenContent() {
                                super.onAdShowedFullScreenContent()
                                Constants.mAppOpenAd = null
                                OpenInterLoad()
                            }

                            override fun onAdDismissedFullScreenContent() {
                                super.onAdDismissedFullScreenContent()

                                adListener.onAdClosed()
                            }
                            override fun onAdImpression() {
                                super.onAdImpression()
                            }
                        }

                } else {
                    adListener.onAdFailedToLoad()
                }
            }
        } else {
            adListener.onAdClosed()
        }
    }

    fun BackOpenInterShow( adListener: OpenAdListener) {
        if (Constants.ADSSHOW) {
            if (Constants.mBackInterCount != Constants.BACKINTERCOUNT) {
                Constants.mBackInterCount += 1
                adListener.onAdClosed()
            } else {
                if (Constants.mAppOpenAd != null) {
                    Constants.mBackInterCount = 0

                    Constants.mAppOpenAd!!.show(mActivity!!)
                    Constants.mAppOpenAd!!.fullScreenContentCallback =
                        object : FullScreenContentCallback() {
                            override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                                super.onAdFailedToShowFullScreenContent(adError)
                            }

                            override fun onAdShowedFullScreenContent() {
                                super.onAdShowedFullScreenContent()
                                Constants.mAppOpenAd = null
                                OpenInterLoad()
                            }

                            override fun onAdDismissedFullScreenContent() {
                                super.onAdDismissedFullScreenContent()



                                adListener.onAdClosed()
                            }
                            override fun onAdImpression() {
                                super.onAdImpression()
                            }
                        }

                } else {
                    adListener.onAdFailedToLoad()
                }
            }
        } else {
            adListener.onAdClosed()
        }
    }


    fun onAdLoadOpenInterForcefully( adListener: OpenAdListener) {
        var customProgressDialog = CustomProgressDialog(mActivity, R.style.progress_style)
        customProgressDialog.showDialog()
        var lAppOpenAd: AppOpenAd
        val adRequest = AdRequest.Builder().build()
        AppOpenAd.load(mActivity!!,
            Constants.AppOpen,
            adRequest,
            AppOpenAd.APP_OPEN_AD_ORIENTATION_PORTRAIT,
            object : AppOpenAdLoadCallback() {
                override fun onAdLoaded(appOpenAd: AppOpenAd) {
                    super.onAdLoaded(appOpenAd)
                    lAppOpenAd = appOpenAd
                    lAppOpenAd.show(mActivity!!)

                    lAppOpenAd.fullScreenContentCallback =
                        object : FullScreenContentCallback() {
                            override fun onAdDismissedFullScreenContent() {
                                super.onAdDismissedFullScreenContent()

                                Constants.mInterCount = 0
                                adListener.onAdClosed()
                            }

                            override fun onAdShowedFullScreenContent() {
                                super.onAdShowedFullScreenContent()
                                customProgressDialog.hideDialog()
                                OpenInterLoad()
                            }

                            override fun onAdFailedToShowFullScreenContent(p0: AdError) {
                                super.onAdFailedToShowFullScreenContent(p0)
                                Constants.mInterCount = 0
                                adListener.onAdFailedToLoad()
                            }
                        }
                }

                override fun onAdFailedToLoad(loadAdError: LoadAdError) {
                    super.onAdFailedToLoad(loadAdError)
                    customProgressDialog.hideDialog()
                    adListener.onAdFailedToLoad()
                }
            })

    }

    fun onAdLoadBackOpenInterForcefully( adListener: OpenAdListener) {
        var customProgressDialog = CustomProgressDialog(mActivity, R.style.progress_style)
        customProgressDialog.showDialog()
        var lAppOpenAd: AppOpenAd
        val adRequest = AdRequest.Builder().build()
        AppOpenAd.load(mActivity!!,
            Constants.AppOpen,
            adRequest,
            AppOpenAd.APP_OPEN_AD_ORIENTATION_PORTRAIT,
            object : AppOpenAdLoadCallback() {
                override fun onAdLoaded(appOpenAd: AppOpenAd) {
                    super.onAdLoaded(appOpenAd)
                    lAppOpenAd = appOpenAd
                    lAppOpenAd.show(mActivity!!)

                    lAppOpenAd.fullScreenContentCallback =
                        object : FullScreenContentCallback() {
                            override fun onAdDismissedFullScreenContent() {
                                super.onAdDismissedFullScreenContent()

                                Constants.mBackInterCount = 0
                                adListener.onAdClosed()
                            }

                            override fun onAdShowedFullScreenContent() {
                                super.onAdShowedFullScreenContent()
                                customProgressDialog.hideDialog()
                                OpenInterLoad()
                            }

                            override fun onAdFailedToShowFullScreenContent(p0: AdError) {
                                super.onAdFailedToShowFullScreenContent(p0)
                                Constants.mBackInterCount = 0
                                adListener.onAdFailedToLoad()
                            }
                        }
                }

                override fun onAdFailedToLoad(loadAdError: LoadAdError) {
                    super.onAdFailedToLoad(loadAdError)
                    customProgressDialog.hideDialog()
                    adListener.onAdFailedToLoad()
                }
            })

    }

    interface OpenAdListener {
        fun onAdLoaded() {}
        fun onAdFailedToLoad() {}
        fun onAdClosed() {}
    }

    interface OpenAdShowListener {
        fun onAdComplete()
    }
}