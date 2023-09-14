package com.ads.code;


import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RatingBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.applovin.mediation.MaxAd;
import com.applovin.mediation.MaxAdRevenueListener;
import com.applovin.mediation.MaxAdViewAdListener;
import com.applovin.mediation.MaxError;
import com.applovin.mediation.ads.MaxAdView;
import com.applovin.mediation.nativeAds.MaxNativeAdListener;
import com.applovin.mediation.nativeAds.MaxNativeAdLoader;
import com.applovin.mediation.nativeAds.MaxNativeAdView;
import com.applovin.mediation.nativeAds.MaxNativeAdViewBinder;
import com.facebook.ads.Ad;
import com.facebook.ads.AdError;
import com.facebook.ads.AdOptionsView;
import com.facebook.ads.AdSize;
import com.facebook.ads.AdView;
import com.facebook.ads.NativeAdLayout;
import com.facebook.ads.NativeAdListener;
import com.facebook.ads.NativeBannerAd;
import com.facebook.shimmer.ShimmerFrameLayout;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.nativead.MediaView;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdView;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class NativeAdvanceHelper {

    public void showNative(Activity activity, ImageView adsReplace, int adType, FrameLayout smallAdContainer, int smallVisiblity, FrameLayout mediumAdContainer, int mediumVisiblity, FrameLayout bigAdContainer, int bigVisiblity) {
        if (Constants.INSTANCE.getADSSHOW()) {
            if (adType == 0) {
                if (smallAdContainer != null) {
                    smallAdContainer.setVisibility(smallVisiblity);
                }
                if (mediumAdContainer != null) {
                    mediumAdContainer.setVisibility(mediumVisiblity);
                }
                if (bigAdContainer != null) {
                    bigAdContainer.setVisibility(bigVisiblity);
                }
                if (adsReplace != null) {
                    adsReplace.setVisibility(View.VISIBLE);
                }
            } else if (adType == 1) {
                if (mediumAdContainer != null) {
                    mediumAdContainer.setVisibility(mediumVisiblity);
                }
                if (bigAdContainer != null) {
                    bigAdContainer.setVisibility(bigVisiblity);
                }
                if (adsReplace != null) {
                    adsReplace.setVisibility(View.VISIBLE);
                }
                if (smallAdContainer != null) {
                    showNativeSmall(smallAdContainer, new NativeAdListenerClass() {

                        @Override
                        public void onAdLoaded() {

                        }

                        @Override
                        public void onAdFailedToLoad() {
                            if (Constants.INSTANCE.getIsFullyForceSmallNative()) {
                                forceFullyLoadNativeSmall(activity, smallAdContainer);
                            } else {
                                smallAdContainer.setVisibility(smallVisiblity);
                            }
                        }

                        @Override
                        public void onAdShow() {
                            if (Constants.INSTANCE.getNativeSmallAdsShowCount() != Constants.INSTANCE.getAdsArray().size()) {
                                if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeSmallAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                                    loadNativeSmall(activity);
                                } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeSmallAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                                    loadFaceBookNativeSmall(activity);
                                }
                            } else {
                                Constants.INSTANCE.setNativeSmallAdsShowCount(0);
                                if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeSmallAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                                    loadNativeSmall(activity);
                                } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeSmallAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                                    loadFaceBookNativeSmall(activity);
                                }
                            }
                        }
                    });
                }

            } else if (adType == 2) {
                if (smallAdContainer != null) {
                    smallAdContainer.setVisibility(smallVisiblity);
                }
                if (bigAdContainer != null) {
                    bigAdContainer.setVisibility(bigVisiblity);
                }
                if (adsReplace != null) {
                    adsReplace.setVisibility(View.VISIBLE);
                }
                if (mediumAdContainer != null) {
                    showNativeMedium(activity, mediumAdContainer, new NativeAdListenerClass() {
                        @Override
                        public void onAdLoaded() {

                        }

                        @Override
                        public void onAdFailedToLoad() {
                            if (Constants.INSTANCE.getIsFullyForceMediumNative()) {
                                forceFullyLoadNativeMedium(activity, mediumAdContainer);
                            } else {
                                mediumAdContainer.setVisibility(mediumVisiblity);
                            }
                        }

                        @Override
                        public void onAdShow() {
                            if (Constants.INSTANCE.getNativeMediumAdsShowCount() != Constants.INSTANCE.getAdsArray().size()) {
                                if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                                    loadNativeMedium(activity);
                                } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                                    loadFaceBookNativeMedium(activity);
                                }else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())){
                                    loadAppLovinMedium(activity);
                                }
                            } else {
                                Constants.INSTANCE.setNativeMediumAdsShowCount(0);
                                if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                                    loadNativeMedium(activity);
                                } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                                    loadFaceBookNativeMedium(activity);
                                }else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())){
                                    loadAppLovinMedium(activity);
                                }
                            }


                        }
                    });
                }

            } else if (adType == 3) {
                if (smallAdContainer != null) {
                    smallAdContainer.setVisibility(smallVisiblity);
                }
                if (mediumAdContainer != null) {
                    mediumAdContainer.setVisibility(mediumVisiblity);
                }
                if (bigAdContainer != null) {
                    showNativeBig(activity, bigAdContainer, new NativeAdListenerClass() {
                        @Override
                        public void onAdLoaded() {

                        }

                        @Override
                        public void onAdFailedToLoad() {
                            Log.e("TAG", "showbig onAdFailedToLoad: ");
                            if (Constants.INSTANCE.getIsFullyForceNative()) {
                                forceFullyLoadNativeBig(activity, bigAdContainer);
                            } else {
                                bigAdContainer.setVisibility(bigVisiblity);
                            }
                        }

                        @Override
                        public void onAdShow() {
                            Log.e("TAG", "showbig onAdShow: ");
                            if (Constants.INSTANCE.getNativeBigAdsShowCount() != Constants.INSTANCE.getAdsArray().size()) {
                                if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                                    loadNativeBig(activity);
                                } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                                    loadFacebookNativeBig(activity);
                                } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())) {
                                    loadApplovinNative(activity);
                                }
                            } else {
                                Constants.INSTANCE.setNativeBigAdsShowCount(0);
                                if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                                    loadNativeBig(activity);
                                } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                                    loadFacebookNativeBig(activity);
                                } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())) {
                                    loadApplovinNative(activity);
                                }
                            }
                        }
                    });
                }

            } else if (adType == 4) {


                if (smallAdContainer != null) {
                    showNativeSmall(smallAdContainer, new NativeAdListenerClass() {
                        @Override
                        public void onAdLoaded() {

                        }

                        @Override
                        public void onAdFailedToLoad() {
                            if (Constants.INSTANCE.getIsFullyForceSmallNative()) {
                                forceFullyLoadNativeSmall(activity, smallAdContainer);
                            } else {
                                smallAdContainer.setVisibility(smallVisiblity);
                            }
                        }

                        @Override
                        public void onAdShow() {
                            if (Constants.INSTANCE.getNativeSmallAdsShowCount() != Constants.INSTANCE.getAdsArray().size()) {
                                if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeSmallAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                                    loadNativeSmall(activity);
                                } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeSmallAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                                    loadFaceBookNativeSmall(activity);
                                }else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())){
                                    loadAppLovinNativeSmall(activity);
                                }
                            } else {
                                Constants.INSTANCE.setNativeSmallAdsShowCount(0);
                                if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeSmallAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                                    loadNativeSmall(activity);
                                } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeSmallAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                                    loadFaceBookNativeSmall(activity);
                                }else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())){
                                    loadAppLovinNativeSmall(activity);
                                }
                            }
                        }
                    });
                }
                if (bigAdContainer != null) {
                    showNativeBig(activity, bigAdContainer, new NativeAdListenerClass() {
                        @Override
                        public void onAdLoaded() {

                        }

                        @Override
                        public void onAdFailedToLoad() {
                            Log.e("TAG", "showbig onAdFailedToLoad: ");
                            if (Constants.INSTANCE.getIsFullyForceNative()) {
                                forceFullyLoadNativeBig(activity, bigAdContainer);
                            } else {
                                bigAdContainer.setVisibility(bigVisiblity);
                            }
                        }

                        @Override
                        public void onAdShow() {
                            Log.e("TAG", "showbig onAdShow: ");
                            if (Constants.INSTANCE.getNativeBigAdsShowCount() != Constants.INSTANCE.getAdsArray().size()) {
                                if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                                    loadNativeBig(activity);
                                } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                                    loadFacebookNativeBig(activity);
                                } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())) {
                                    loadApplovinNative(activity);
                                }
                            } else {
                                Constants.INSTANCE.setNativeBigAdsShowCount(0);
                                if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                                    loadNativeBig(activity);
                                } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                                    loadFacebookNativeBig(activity);
                                } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())) {
                                    loadApplovinNative(activity);
                                }
                            }

                        }
                    });
                }
                if (mediumAdContainer != null) {
                    showNativeMedium(activity, mediumAdContainer, new NativeAdListenerClass() {
                        @Override
                        public void onAdLoaded() {

                        }

                        @Override
                        public void onAdFailedToLoad() {
                            if (Constants.INSTANCE.getIsFullyForceSmallNative()) {
                                forceFullyLoadNativeMedium(activity, mediumAdContainer);
                            } else {
                                mediumAdContainer.setVisibility(mediumVisiblity);
                            }

                        }

                        @Override
                        public void onAdShow() {
                            if (Constants.INSTANCE.getNativeMediumAdsShowCount() != Constants.INSTANCE.getAdsArray().size()) {
                                if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                                    loadNativeMedium(activity);
                                } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                                    loadFaceBookNativeMedium(activity);
                                }else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())){
                                    loadAppLovinMedium(activity);
                                }
                            } else {
                                Constants.INSTANCE.setNativeMediumAdsShowCount(0);
                                if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                                    loadNativeMedium(activity);
                                } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                                    loadFaceBookNativeMedium(activity);
                                }else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())){
                                    loadAppLovinMedium(activity);
                                }
                            }
                        }
                    });
                }
            }
        } else {
            if (smallAdContainer != null) {
                smallAdContainer.setVisibility(smallVisiblity);
            }
            if (mediumAdContainer != null) {
                mediumAdContainer.setVisibility(mediumVisiblity);
            }
            if (bigAdContainer != null) {
                bigAdContainer.setVisibility(bigVisiblity);
            }
            if (adsReplace != null) {
                adsReplace.setVisibility(View.VISIBLE);
            }
        }
    }

    public void loadNativeSmall(Activity mContext) {
        if (Constants.INSTANCE.getADSSHOW()) {

            if (!Constants.INSTANCE.getIsOnlyForceFullyNativeSmall()) {

                if (Constants.INSTANCE.getIsNativeSmallLoad()) {

                    Constants.INSTANCE.setIsNativeSmallLoad(false);

                    if (Constants.INSTANCE.getNativeSmallAds() == null) {
                        AdLoader builder = new AdLoader.Builder(mContext, Objects.requireNonNull(Constants.INSTANCE.getNative_1())).forNativeAd(new NativeAd.OnNativeAdLoadedListener() {
                            @Override
                            public void onNativeAdLoaded(@NonNull @NotNull NativeAd nativeAd) {
                                Constants.INSTANCE.setAdSmallView((NativeAdView) mContext.getLayoutInflater().inflate(R.layout.layout_google_native_ad_small, null));
                                Constants.INSTANCE.setNativeSmallAds(nativeAd);
                                Constants.INSTANCE.setIsNativeSmallLoad(true);
                            }


                        }).withAdListener(new AdListener() {
                            @Override
                            public void onAdFailedToLoad(@NonNull @NotNull LoadAdError loadAdError) {
                                super.onAdFailedToLoad(loadAdError);
                                Constants.INSTANCE.setNativeSmallAds(null);
                                Constants.INSTANCE.setIsNativeSmallLoad(true);
                            }
                        }).build();

                        builder.loadAd(new AdRequest.Builder().build());
                    }

                } else {

                    if (Constants.INSTANCE.getIsNativeSmallOnlineCount() != 0) {
                        Constants.INSTANCE.setIsNativeSmallLoadCount(Constants.INSTANCE.getIsNativeSmallLoadCount() + 1);

                        if (Constants.INSTANCE.getIsNativeSmallLoadCount() >= Constants.INSTANCE.getIsNativeSmallOnlineCount()) {
                            Constants.INSTANCE.setIsNativeSmallLoad(true);
                            Constants.INSTANCE.setIsNativeSmallLoadCount(0);
                        }
                    }
                }
            }
        }
    }

    public void loadFaceBookNativeSmall(Activity mContext) {
        if (Constants.INSTANCE.getADSSHOW()) {
            if (!Constants.INSTANCE.getIsOnlyForceFullyNativeSmall()) {
                if (Constants.INSTANCE.getFaceBookAdView() == null) {
                    Constants.INSTANCE.setFaceBookAdView(new AdView(mContext, Constants.INSTANCE.getFaceBookBanner(), AdSize.BANNER_HEIGHT_90));
                    Constants.INSTANCE.getFaceBookAdView().loadAd();
                }
            }
        }
    }

    public void loadAppLovinNativeSmall(Activity mContext) {
        if (Constants.INSTANCE.getADSSHOW()) {
            if (!Constants.INSTANCE.getIsOnlyForceFullyNativeSmall()) {
                if (Constants.INSTANCE.getMaxAdView() == null) {
                    MaxAdView maxAdView = new MaxAdView(Constants.INSTANCE.getAppLovinBanner(), (Context) mContext);
                    maxAdView.setLayoutParams(new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, mContext.getResources().getDimensionPixelSize(com.intuit.sdp.R.dimen._50sdp)));
                    maxAdView.loadAd();
                    maxAdView.setListener(new MaxAdViewAdListener() {
                        public void onAdClicked(MaxAd maxAd) {
                        }

                        public void onAdCollapsed(MaxAd maxAd) {
                        }

                        public void onAdDisplayFailed(MaxAd maxAd, MaxError maxError) {
                        }


                        public void onAdDisplayed(MaxAd maxAd) {
                        }

                        public void onAdExpanded(MaxAd maxAd) {
                        }

                        public void onAdHidden(MaxAd maxAd) {
                        }

                        public void onAdLoaded(MaxAd maxAd) {
                            Constants.INSTANCE.setMaxAdView(maxAdView);
                        }

                        public void onAdLoadFailed(String str, MaxError maxError) {
                        }
                    });
                }
            }
        }
    }

    public void loadNativeMedium(Activity mContext) {
        if (Constants.INSTANCE.getADSSHOW()) {

            if (!Constants.INSTANCE.getIsOnlyForceFullyNativeMedium()) {

                if (Constants.INSTANCE.getIsNativeMediumLoad()) {

                    Constants.INSTANCE.setIsNativeMediumLoad(false);

                    if (Constants.INSTANCE.getNativeMediumAds() == null) {
                        AdLoader builder = new AdLoader.Builder(mContext, Objects.requireNonNull(Constants.INSTANCE.getNative_1())).forNativeAd(new NativeAd.OnNativeAdLoadedListener() {
                            @Override
                            public void onNativeAdLoaded(@NonNull @NotNull NativeAd nativeAd) {

                                Constants.INSTANCE.setAdMediumView((NativeAdView) mContext.getLayoutInflater().inflate(R.layout.layout_google_native_ad_medium, null));
                                Constants.INSTANCE.setNativeMediumAds(nativeAd);
                                Constants.INSTANCE.setIsNativeMediumLoad(true);

                            }


                        }).withAdListener(new AdListener() {
                            @Override
                            public void onAdFailedToLoad(@NonNull @NotNull LoadAdError loadAdError) {
                                super.onAdFailedToLoad(loadAdError);
                                Constants.INSTANCE.setNativeMediumAds(null);
                                Constants.INSTANCE.setIsNativeMediumLoad(true);
                                Log.e("TAG", "onAdFailedToLoad: " + loadAdError.getMessage());
                            }
                        }).build();

                        builder.loadAd(new AdRequest.Builder().build());
                    }

                } else {
                    if (Constants.INSTANCE.getIsNativeMediumOnlineCount() != 0) {
                        Constants.INSTANCE.setIsNativeMediumLoadCount(Constants.INSTANCE.getIsNativeMediumLoadCount() + 1);

                        if (Constants.INSTANCE.getIsNativeMediumLoadCount() >= Constants.INSTANCE.getIsNativeMediumOnlineCount()) {
                            Constants.INSTANCE.setIsNativeMediumLoad(true);
                            Constants.INSTANCE.setIsNativeMediumLoadCount(0);
                        }
                    }
                }

            }
        }


    }

    public void loadFaceBookNativeMedium(Activity mContext) {
        com.facebook.ads.NativeAd nativeBannerAd;
        if (Constants.INSTANCE.getADSSHOW()) {

            if (!Constants.INSTANCE.getIsOnlyForceFullyNativeMedium()) {


                nativeBannerAd = new com.facebook.ads.NativeAd(mContext, Constants.INSTANCE.getFaceBookMedium());
                NativeAdListener nativeAdListener = new NativeAdListener() {

                    @Override
                    public void onMediaDownloaded(Ad ad) {
                        // Native ad finished downloading all assets
                        Log.e("TAG", "Native ad finished downloading all assets.");
                    }

                    @Override
                    public void onError(Ad ad, AdError adError) {
                        // Native ad failed to load
                        Log.e("TAG", "Native ad failed to load: " + adError.getErrorMessage());
                    }

                    @Override
                    public void onAdLoaded(Ad ad) {
                        // Native ad is loaded and ready to be displayed
                        Log.d("TAG", "Native ad is loaded and ready to be displayed!");
                        Constants.INSTANCE.setFaceBookMediumAd(nativeBannerAd);
                    }

                    @Override
                    public void onAdClicked(Ad ad) {
                        // Native ad clicked
                        Log.d("TAG", "Native ad clicked!");
                    }

                    @Override
                    public void onLoggingImpression(Ad ad) {
                        // Native ad impression
                        Log.d("TAG", "Native ad impression logged!");
                    }
                };
                // load the ad
                nativeBannerAd.loadAd(
                        nativeBannerAd.buildLoadAdConfig()
                                .withAdListener(nativeAdListener)
                                .build());
            }
        }

    }

    public void loadAppLovinMedium(Activity mContext) {
        if (Constants.INSTANCE.getADSSHOW()) {

            if (!Constants.INSTANCE.getIsOnlyForceFullyNativeMedium()) {
                if (Constants.INSTANCE.getMaxApplovinNativeMediumAdView() == null) {
                    MaxNativeAdLoader nativeAdLoader = new MaxNativeAdLoader(Constants.INSTANCE.getAppLovinNative(), mContext);
                    nativeAdLoader.setRevenueListener(new MaxAdRevenueListener() {
                        public void onAdRevenuePaid(MaxAd maxAd) {
                        }
                    });
                    nativeAdLoader.setNativeAdListener(new MaxNativeAdListener() {
                        public void onNativeAdClicked(MaxAd maxAd) {
                        }

                        public void onNativeAdLoaded(MaxNativeAdView maxNativeAdView, MaxAd maxAd) {
                            Constants.INSTANCE.setMaxApplovinNativeMediumAdView(maxNativeAdView);
                        }

                        public void onNativeAdLoadFailed(String str, MaxError maxError) {
                        }
                    });


                    MaxNativeAdViewBinder binder = new MaxNativeAdViewBinder.Builder(R.layout.layout_applovin_native_ad_medium)
                            .setTitleTextViewId(R.id.title_text_view)
                            .setBodyTextViewId(R.id.body_text_view)
                            .setAdvertiserTextViewId(R.id.advertiser_textView)
                            .setIconImageViewId(R.id.icon_image_view)
                            .setMediaContentViewGroupId(R.id.media_view_container)
                            .setOptionsContentViewGroupId(R.id.ad_options_view)
                            .setCallToActionButtonId(R.id.cta_button)
                            .build();
                    nativeAdLoader.loadAd(new MaxNativeAdView(binder, mContext));
                }
            }
        }
    }

    private void inflateMediumAd(Activity mContext, com.facebook.ads.NativeAd nativeBannerAd, FrameLayout facboobkContainer) {
        nativeBannerAd.unregisterView();
        NativeAdLayout adView;
        adView = (NativeAdLayout) mContext.getLayoutInflater().inflate(R.layout.layout_facebook_native_ad_medium, null);
        facboobkContainer.addView(adView);
        NativeAdLayout nativeAdLayout = adView.findViewById(R.id.native_ad_container);
        // Add the AdChoices icon
        RelativeLayout adChoicesContainer = adView.findViewById(R.id.ad_choices_container);
        AdOptionsView adOptionsView = new AdOptionsView(mContext, nativeBannerAd, nativeAdLayout);
        adChoicesContainer.removeAllViews();
        adChoicesContainer.addView(adOptionsView, 0);

        // Create native UI using the ad metadata.
        TextView nativeAdTitle = adView.findViewById(R.id.native_ad_title);
        TextView nativeAdSocialContext = adView.findViewById(R.id.native_ad_social_context);
        TextView sponsoredLabel = adView.findViewById(R.id.native_ad_sponsored_label);
        com.facebook.ads.MediaView nativeAdMedia = adView.findViewById(R.id.native_ad_media);
        Button nativeAdCallToAction = adView.findViewById(R.id.native_ad_call_to_action);

        // Set the Text.
        nativeAdCallToAction.setText(nativeBannerAd.getAdCallToAction());
        nativeAdCallToAction.setVisibility(
                nativeBannerAd.hasCallToAction() ? View.VISIBLE : View.INVISIBLE);
        nativeAdTitle.setText(nativeBannerAd.getAdvertiserName());
        nativeAdSocialContext.setText(nativeBannerAd.getAdSocialContext());
        sponsoredLabel.setText(nativeBannerAd.getSponsoredTranslation());

        // Register the Title and CTA button to listen for clicks.
        List<View> clickableViews = new ArrayList<>();
        clickableViews.add(nativeAdTitle);
        clickableViews.add(nativeAdCallToAction);
        nativeBannerAd.registerViewForInteraction(adView,nativeAdMedia, clickableViews);
    }

    public void loadNativeBig(Activity mContext) {
        if (Constants.INSTANCE.getADSSHOW()) {

            if (!Constants.INSTANCE.getIsOnlyForceFullyNativeBig()) {

                if (Constants.INSTANCE.getIsNativeBigLoad()) {

                    Constants.INSTANCE.setIsNativeBigLoad(false);

                    if (Constants.INSTANCE.getNativeAds() == null) {
                        AdLoader builder = new AdLoader.Builder(mContext, Objects.requireNonNull(Constants.INSTANCE.getNative())).forNativeAd(new NativeAd.OnNativeAdLoadedListener() {
                            @Override
                            public void onNativeAdLoaded(@NonNull @NotNull NativeAd nativeAd) {
                                Log.e("TAG", "load onNativeAdLoaded: " + nativeAd);
                                Constants.INSTANCE.setAdView((NativeAdView) mContext.getLayoutInflater().inflate(R.layout.layout_google_native_ad, null));
                                Constants.INSTANCE.setNativeAds(nativeAd);
                                Constants.INSTANCE.setIsNativeBigLoad(true);
                            }


                        }).withAdListener(new AdListener() {
                            @Override
                            public void onAdFailedToLoad(@NonNull @NotNull LoadAdError loadAdError) {
                                super.onAdFailedToLoad(loadAdError);
                                Constants.INSTANCE.setNativeAds(null);
                                Constants.INSTANCE.setIsNativeBigLoad(true);
                                Log.e("TAG", "load onAdFailedToLoad: " + loadAdError.getMessage());
                            }
                        }).build();

                        builder.loadAd(new AdRequest.Builder().build());
                    }

                } else {
                    if (Constants.INSTANCE.getIsNativeBigOnlineCount() != 0) {
                        Constants.INSTANCE.setIsNativeBigLoadCount(Constants.INSTANCE.getIsNativeBigLoadCount() + 1);

                        if (Constants.INSTANCE.getIsNativeBigLoadCount() >= Constants.INSTANCE.getIsNativeBigOnlineCount()) {
                            Constants.INSTANCE.setIsNativeBigLoad(true);
                            Constants.INSTANCE.setIsNativeBigLoadCount(0);
                        }
                    }
                }

            }
        }
    }

    public void loadFacebookNativeBig(Activity mContext) {

        if (Constants.INSTANCE.getADSSHOW()) {

            if (!Constants.INSTANCE.getIsOnlyForceFullyNativeBig()) {
                if (Constants.INSTANCE.getFaceBookNativeAd() == null) {
                    com.facebook.ads.NativeAd nativeAd;
                    nativeAd = new com.facebook.ads.NativeAd(mContext, Constants.INSTANCE.getFaceBookNative());

                    NativeAdListener nativeAdListener = new NativeAdListener() {

                        @Override
                        public void onMediaDownloaded(Ad ad) {
                        }

                        @Override
                        public void onError(Ad ad, AdError adError) {
                        }

                        @Override
                        public void onAdLoaded(Ad ad) {
                            if (nativeAd == null || nativeAd != ad) {
                                return;
                            }
                            Constants.INSTANCE.setFaceBookNativeAd(nativeAd);
                        }

                        @Override
                        public void onAdClicked(Ad ad) {
                        }

                        @Override
                        public void onLoggingImpression(Ad ad) {
                        }
                    };
                    nativeAd.loadAd(nativeAd.buildLoadAdConfig().withAdListener(nativeAdListener).build());
                }

            }
        }
    }

    public void loadApplovinNative(Activity mContext) {
        if (Constants.INSTANCE.getADSSHOW()) {

            if (!Constants.INSTANCE.getIsOnlyForceFullyNativeBig()) {
                if (Constants.INSTANCE.getMaxApplovinNativeAdView() == null) {
                    MaxNativeAdLoader nativeAdLoader = new MaxNativeAdLoader(Constants.INSTANCE.getAppLovinNative(), mContext);
                    nativeAdLoader.setRevenueListener(new MaxAdRevenueListener() {
                        public void onAdRevenuePaid(MaxAd maxAd) {
                        }
                    });
                    nativeAdLoader.setNativeAdListener(new MaxNativeAdListener() {
                        public void onNativeAdClicked(MaxAd maxAd) {
                        }

                        public void onNativeAdLoaded(MaxNativeAdView maxNativeAdView, MaxAd maxAd) {
//                if (applovinLoadedNativeAd != null) {
//                    nativeAdLoader.destroy(applovinLoadedNativeAd);
//                }
//                applovinLoadedNativeAd = maxAd;
//                applovinNativeAd_preLoad = maxNativeAdView;
//
//                state_applovinNative = "Loaded";
                            Constants.INSTANCE.setMaxApplovinNativeAdView(maxNativeAdView);

                        }

                        public void onNativeAdLoadFailed(String str, MaxError maxError) {
                        }
                    });


                    MaxNativeAdViewBinder binder = new MaxNativeAdViewBinder.Builder(R.layout.layout_applovin_native)
                            .setTitleTextViewId(R.id.title_text_view)
                            .setBodyTextViewId(R.id.body_text_view)
                            .setAdvertiserTextViewId(R.id.advertiser_textView)
                            .setIconImageViewId(R.id.icon_image_view)
                            .setMediaContentViewGroupId(R.id.media_view_container)
                            .setOptionsContentViewGroupId(R.id.ad_options_view)
                            .setCallToActionButtonId(R.id.cta_button)
                            .build();
                    nativeAdLoader.loadAd(new MaxNativeAdView(binder, mContext));
                }
            }
        }
    }

    private void inflateAd(Activity mContext, com.facebook.ads.NativeAd nativeAd, FrameLayout facboobkContainer) {
        nativeAd.unregisterView();
        NativeAdLayout adView;
        adView = (NativeAdLayout) mContext.getLayoutInflater().inflate(R.layout.layout_facebook_native_ad, null);
        facboobkContainer.addView(adView);
        NativeAdLayout nativeAdLayout = adView.findViewById(R.id.native_ad_container);
        LinearLayout adChoicesContainer = adView.findViewById(R.id.ad_choices_container);
        AdOptionsView adOptionsView = new AdOptionsView(mContext, nativeAd, nativeAdLayout);
        adChoicesContainer.removeAllViews();
        adChoicesContainer.addView(adOptionsView, 0);
        com.facebook.ads.MediaView nativeAdIcon = adView.findViewById(R.id.native_ad_icon);
        TextView nativeAdTitle = adView.findViewById(R.id.native_ad_title);
        com.facebook.ads.MediaView nativeAdMedia = adView.findViewById(R.id.native_ad_media);
        TextView nativeAdSocialContext = adView.findViewById(R.id.native_ad_social_context);
        TextView nativeAdBody = adView.findViewById(R.id.native_ad_body);
        TextView sponsoredLabel = adView.findViewById(R.id.native_ad_sponsored_label);
        Button nativeAdCallToAction = adView.findViewById(R.id.native_ad_call_to_action);
        nativeAdTitle.setText(nativeAd.getAdvertiserName());
        nativeAdBody.setText(nativeAd.getAdBodyText());
        nativeAdSocialContext.setText(nativeAd.getAdSocialContext());
        nativeAdCallToAction.setVisibility(nativeAd.hasCallToAction() ? View.VISIBLE : View.INVISIBLE);
        nativeAdCallToAction.setText(nativeAd.getAdCallToAction());
        sponsoredLabel.setText(nativeAd.getSponsoredTranslation());
        List<View> clickableViews = new ArrayList<>();
        clickableViews.add(nativeAdTitle);
        clickableViews.add(nativeAdCallToAction);
        nativeAd.registerViewForInteraction(adView, nativeAdMedia, nativeAdIcon, clickableViews);
    }

    public void showNativeSmall(FrameLayout fAdContainer, NativeAdListenerClass nativeAdListener) {
        if (Constants.INSTANCE.getADSSHOW()) {
            if (Constants.INSTANCE.getAlterNativeAdsShow()) {
                if (Constants.INSTANCE.getNativeSmallAdsShowCount() != Constants.INSTANCE.getAdsArray().size()) {
                    if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeSmallAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                        if (Constants.INSTANCE.getNativeSmallAds() != null) {
                            fAdContainer.removeAllViews();
                            fAdContainer.addView(Constants.INSTANCE.getAdSmallView());
                            populateNativeAdView(Constants.INSTANCE.getNativeSmallAds(), Constants.INSTANCE.getAdSmallView(), nativeAdListener);
                            Constants.INSTANCE.setNativeSmallAds(null);
                            nativeAdListener.onAdShow();
                            Constants.INSTANCE.setNativeSmallAdsShowCount(Constants.INSTANCE.getNativeSmallAdsShowCount() + 1);
                        } else {
                            nativeAdListener.onAdFailedToLoad();
                        }
                    } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeSmallAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                        if (Constants.INSTANCE.getFaceBookAdView() != null) {
//                            fAdContainer.removeAllViews();
                            fAdContainer.addView(Constants.INSTANCE.getFaceBookAdView());
                            Constants.INSTANCE.setFaceBookAdView(null);
                            nativeAdListener.onAdShow();
                            Constants.INSTANCE.setNativeSmallAdsShowCount(Constants.INSTANCE.getNativeSmallAdsShowCount() + 1);
                        } else {
                            nativeAdListener.onAdFailedToLoad();
                        }
                    } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeSmallAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())) {
                        if (Constants.INSTANCE.getMaxAdView() != null) {
                            fAdContainer.addView(Constants.INSTANCE.getMaxAdView());
                            Constants.INSTANCE.setMaxAdView(null);
                            nativeAdListener.onAdShow();
                            Constants.INSTANCE.setNativeSmallAdsShowCount(Constants.INSTANCE.getNativeSmallAdsShowCount() + 1);
                        } else {
                            nativeAdListener.onAdFailedToLoad();
                        }
                    }

                } else {
                    Constants.INSTANCE.setNativeSmallAdsShowCount(0);
                    if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeSmallAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                        if (Constants.INSTANCE.getNativeSmallAds() != null) {
                            fAdContainer.removeAllViews();
                            fAdContainer.addView(Constants.INSTANCE.getAdSmallView());
                            populateNativeAdView(Constants.INSTANCE.getNativeSmallAds(), Constants.INSTANCE.getAdSmallView(), nativeAdListener);
                            Constants.INSTANCE.setNativeSmallAds(null);
                            nativeAdListener.onAdShow();
                            Constants.INSTANCE.setNativeSmallAdsShowCount(Constants.INSTANCE.getNativeSmallAdsShowCount() + 1);
                        } else {
                            nativeAdListener.onAdFailedToLoad();
                        }
                    } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeSmallAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                        if (Constants.INSTANCE.getFaceBookAdView() != null) {
//                            fAdContainer.removeAllViews();
                            fAdContainer.addView(Constants.INSTANCE.getFaceBookAdView());
                            Constants.INSTANCE.setFaceBookAdView(null);
                            nativeAdListener.onAdShow();
                            Constants.INSTANCE.setNativeSmallAdsShowCount(Constants.INSTANCE.getNativeSmallAdsShowCount() + 1);
                        } else {
                            nativeAdListener.onAdFailedToLoad();
                        }
                    }

                }
            } else {
                if (Constants.INSTANCE.getNativeSmallAds() != null) {
                    fAdContainer.removeAllViews();
                    fAdContainer.addView(Constants.INSTANCE.getAdSmallView());
                    populateNativeAdView(Constants.INSTANCE.getNativeSmallAds(), Constants.INSTANCE.getAdSmallView(), nativeAdListener);
                    Constants.INSTANCE.setNativeSmallAds(null);
                    nativeAdListener.onAdShow();
                } else {
                    nativeAdListener.onAdFailedToLoad();
                }
            }
        }
    }

    public void showNativeMedium(Activity activity, FrameLayout fAdContainer, NativeAdListenerClass nativeAdListener) {
        if (Constants.INSTANCE.getADSSHOW()) {
            if (Constants.INSTANCE.getAlterNativeAdsShow()) {
                if (Constants.INSTANCE.getNativeMediumAdsShowCount() != Constants.INSTANCE.getAdsArray().size()) {
                    if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                        if (Constants.INSTANCE.getNativeMediumAds() != null) {
                            fAdContainer.removeAllViews();
                            fAdContainer.addView(Constants.INSTANCE.getAdMediumView());
                            populateNativeAdView(Constants.INSTANCE.getNativeMediumAds(), Constants.INSTANCE.getAdMediumView(), nativeAdListener);
                            Constants.INSTANCE.setNativeMediumAds(null);
                            Constants.INSTANCE.setNativeMediumAdsShowCount(Constants.INSTANCE.getNativeMediumAdsShowCount() + 1);
                            nativeAdListener.onAdShow();
                        } else {
                            nativeAdListener.onAdFailedToLoad();
                        }
                    } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                        if (Constants.INSTANCE.getFaceBookMediumAd() != null) {
                            inflateMediumAd(activity, Constants.INSTANCE.getFaceBookMediumAd(), fAdContainer);
                            Constants.INSTANCE.setFaceBookMediumAd(null);
                            Constants.INSTANCE.setNativeMediumAdsShowCount(Constants.INSTANCE.getNativeMediumAdsShowCount() + 1);
                            nativeAdListener.onAdShow();
                        } else {
                            nativeAdListener.onAdFailedToLoad();
                        }
                    }else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())) {
                        if (Constants.INSTANCE.getMaxApplovinNativeMediumAdView() != null) {
                            fAdContainer.addView(Constants.INSTANCE.getMaxApplovinNativeMediumAdView());
                            Constants.INSTANCE.setMaxApplovinNativeMediumAdView(null);
                            Constants.INSTANCE.setNativeMediumAdsShowCount(Constants.INSTANCE.getNativeMediumAdsShowCount() + 1);
                            nativeAdListener.onAdShow();
                        } else {
                            nativeAdListener.onAdFailedToLoad();
                        }
                    }

                } else {
                    Constants.INSTANCE.setNativeMediumAdsShowCount(0);
                    if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                        if (Constants.INSTANCE.getNativeMediumAds() != null) {
                            fAdContainer.removeAllViews();
                            fAdContainer.addView(Constants.INSTANCE.getAdMediumView());
                            populateNativeAdView(Constants.INSTANCE.getNativeMediumAds(), Constants.INSTANCE.getAdMediumView(), nativeAdListener);
                            Constants.INSTANCE.setNativeMediumAds(null);
                            Constants.INSTANCE.setNativeMediumAdsShowCount(Constants.INSTANCE.getNativeMediumAdsShowCount() + 1);
                            nativeAdListener.onAdShow();
                        } else {
                            nativeAdListener.onAdFailedToLoad();
                        }
                    } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                        if (Constants.INSTANCE.getFaceBookMediumAd() != null) {
                            inflateMediumAd(activity, Constants.INSTANCE.getFaceBookMediumAd(), fAdContainer);
                            Constants.INSTANCE.setFaceBookMediumAd(null);
                            Constants.INSTANCE.setNativeMediumAdsShowCount(Constants.INSTANCE.getNativeMediumAdsShowCount() + 1);
                            nativeAdListener.onAdShow();
                        } else {
                            nativeAdListener.onAdFailedToLoad();
                        }
                    }else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())) {
                        if (Constants.INSTANCE.getMaxApplovinNativeMediumAdView() != null) {
                            fAdContainer.addView(Constants.INSTANCE.getMaxApplovinNativeMediumAdView());
                            Constants.INSTANCE.setMaxApplovinNativeMediumAdView(null);
                            Constants.INSTANCE.setNativeMediumAdsShowCount(Constants.INSTANCE.getNativeMediumAdsShowCount() + 1);
                            nativeAdListener.onAdShow();
                        } else {
                            nativeAdListener.onAdFailedToLoad();
                        }
                    }

                }
            } else {
                if (Constants.INSTANCE.getNativeMediumAds() != null) {
                    fAdContainer.removeAllViews();
                    fAdContainer.addView(Constants.INSTANCE.getAdMediumView());
                    populateNativeAdView(Constants.INSTANCE.getNativeMediumAds(), Constants.INSTANCE.getAdMediumView(), nativeAdListener);
                    Constants.INSTANCE.setNativeMediumAds(null);
                    nativeAdListener.onAdShow();
                } else {
                    nativeAdListener.onAdFailedToLoad();
                }
            }
        }
    }


    public void showNativeBig(Activity activity, FrameLayout fAdContainer, NativeAdListenerClass nativeAdListener) {
        if (Constants.INSTANCE.getADSSHOW()) {
            if (Constants.INSTANCE.getAlterNativeAdsShow()) {
                if (Constants.INSTANCE.getNativeBigAdsShowCount() != Constants.INSTANCE.getAdsArray().size()) {
                    if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                        if (Constants.INSTANCE.getNativeAds() != null) {
                            Log.e("TAG", "showNativeBig: " + Constants.INSTANCE.getNativeAds());
                            fAdContainer.removeAllViews();
                            fAdContainer.addView(Constants.INSTANCE.getAdView());
                            populateNativeAdView(Constants.INSTANCE.getNativeAds(), Constants.INSTANCE.getAdView(), nativeAdListener);
                            Constants.INSTANCE.setNativeAds(null);
                            Constants.INSTANCE.setNativeBigAdsShowCount(Constants.INSTANCE.getNativeBigAdsShowCount() + 1);
                            nativeAdListener.onAdShow();
                        } else {
                            nativeAdListener.onAdFailedToLoad();
                        }
                    } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                        if (Constants.INSTANCE.getFaceBookNativeAd() != null) {
                            inflateAd(activity, Constants.INSTANCE.getFaceBookNativeAd(), fAdContainer);
                            Constants.INSTANCE.setFaceBookNativeAd(null);
                            Constants.INSTANCE.setNativeBigAdsShowCount(Constants.INSTANCE.getNativeBigAdsShowCount() + 1);
                            nativeAdListener.onAdShow();
                        } else {
                            nativeAdListener.onAdFailedToLoad();
                        }
                    } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())) {
                        if (Constants.INSTANCE.getMaxApplovinNativeAdView() != null) {
                            fAdContainer.addView(Constants.INSTANCE.getMaxApplovinNativeAdView());
                            Constants.INSTANCE.setMaxApplovinNativeAdView(null);
                            Constants.INSTANCE.setNativeBigAdsShowCount(Constants.INSTANCE.getNativeBigAdsShowCount() + 1);
                            nativeAdListener.onAdShow();
                        } else {
                            nativeAdListener.onAdFailedToLoad();
                        }
                    }

                } else {
                    Constants.INSTANCE.setNativeBigAdsShowCount(0);
                    if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                        if (Constants.INSTANCE.getNativeAds() != null) {
                            Log.e("TAG", "showNativeBig: " + Constants.INSTANCE.getNativeAds());
                            fAdContainer.removeAllViews();
                            fAdContainer.addView(Constants.INSTANCE.getAdView());
                            populateNativeAdView(Constants.INSTANCE.getNativeAds(), Constants.INSTANCE.getAdView(), nativeAdListener);
                            Constants.INSTANCE.setNativeAds(null);
                            Constants.INSTANCE.setNativeBigAdsShowCount(Constants.INSTANCE.getNativeBigAdsShowCount() + 1);
                            nativeAdListener.onAdShow();
                        } else {
                            nativeAdListener.onAdFailedToLoad();
                        }
                    } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                        if (Constants.INSTANCE.getFaceBookNativeAd() != null) {
                            inflateAd(activity, Constants.INSTANCE.getFaceBookNativeAd(), fAdContainer);
                            Constants.INSTANCE.setFaceBookNativeAd(null);
                            Constants.INSTANCE.setNativeBigAdsShowCount(Constants.INSTANCE.getNativeBigAdsShowCount() + 1);
                            nativeAdListener.onAdShow();
                        } else {
                            nativeAdListener.onAdFailedToLoad();
                        }
                    } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())) {
                        if (Constants.INSTANCE.getMaxApplovinNativeAdView() != null) {
                            fAdContainer.addView(Constants.INSTANCE.getMaxApplovinNativeAdView());
                            Constants.INSTANCE.setMaxApplovinNativeAdView(null);
                            Constants.INSTANCE.setNativeBigAdsShowCount(Constants.INSTANCE.getNativeBigAdsShowCount() + 1);
                            nativeAdListener.onAdShow();
                        } else {
                            nativeAdListener.onAdFailedToLoad();
                        }
                    }

                }
            } else {
                if (Constants.INSTANCE.getNativeAds() != null) {
                    Log.e("TAG", "showNativeBig: " + Constants.INSTANCE.getNativeAds());
                    fAdContainer.removeAllViews();
                    fAdContainer.addView(Constants.INSTANCE.getAdView());
                    populateNativeAdView(Constants.INSTANCE.getNativeAds(), Constants.INSTANCE.getAdView(), nativeAdListener);
                    Constants.INSTANCE.setNativeAds(null);
                    nativeAdListener.onAdShow();
                } else {
                    nativeAdListener.onAdFailedToLoad();
                }
            }
        }
    }

    public void populateNativeAdView(NativeAd nativeAd, NativeAdView adView, NativeAdListenerClass nativeAdListener) {

        MediaView mediaView = adView.findViewById(R.id.ad_media);
        TextView headlineView = adView.findViewById(R.id.ad_headline);
        TextView bodyView = adView.findViewById(R.id.ad_body);
        TextView callToActionView = adView.findViewById(R.id.ad_call_to_action);
        ImageView iconView = adView.findViewById(R.id.ad_app_icon);
        TextView priceView = adView.findViewById(R.id.ad_price);
        RatingBar starRatingView = adView.findViewById(R.id.ad_stars);
        TextView storeView = adView.findViewById(R.id.ad_store);
        TextView advertiserView = adView.findViewById(R.id.ad_advertiser);


        headlineView.setText(nativeAd.getHeadline());
        adView.setHeadlineView(headlineView);

        if (nativeAd.getMediaContent() != null && mediaView != null) {
            mediaView.setMediaContent(nativeAd.getMediaContent());
            adView.setMediaView(mediaView);

        }

        if (nativeAd.getBody() == null && bodyView != null) {
            bodyView.setVisibility(View.INVISIBLE);
        } else if (bodyView != null) {
            bodyView.setVisibility(View.VISIBLE);

            bodyView.setText(nativeAd.getBody());
            adView.setBodyView(bodyView);
        }

        if (nativeAd.getCallToAction() == null && callToActionView != null) {
            callToActionView.setVisibility(View.INVISIBLE);
        } else if (callToActionView != null) {

            callToActionView.setVisibility(View.VISIBLE);

            callToActionView.setText(nativeAd.getCallToAction());
            adView.setCallToActionView(callToActionView);
        }

        if (nativeAd.getIcon() == null && iconView != null) {
            iconView.setVisibility(View.INVISIBLE);
        } else if (iconView != null) {
            iconView.setImageDrawable(nativeAd.getIcon().getDrawable());
            iconView.setVisibility(View.VISIBLE);
            adView.setIconView(iconView);

        }

        if (nativeAd.getPrice() == null && priceView != null) {
            priceView.setVisibility(View.INVISIBLE);
        } else if (priceView != null) {
            priceView.setVisibility(View.VISIBLE);

            priceView.setText(nativeAd.getPrice());
            adView.setPriceView(priceView);

        }

        if (nativeAd.getHeadline() == null && storeView != null) {
            storeView.setVisibility(View.INVISIBLE);
        } else if (storeView != null) {
            storeView.setVisibility(View.VISIBLE);
            storeView.setText(nativeAd.getHeadline());
            adView.setBodyView(storeView);
        }

//        if (nativeAd.getStore() == null && storeView != null) {
//            storeView.setVisibility(View.INVISIBLE);
//        } else if (storeView != null) {
//            storeView.setVisibility(View.VISIBLE);
//
//            storeView.setText(nativeAd.getStore());
//
//            adView.setStoreView(storeView);
//
//        }

        if (priceView != null) {
            priceView.setVisibility(View.GONE);
        }
//        if (storeView != null) {
//            storeView.setVisibility(View.GONE);
//        }

        if (nativeAd.getStarRating() == null && starRatingView != null) {
            starRatingView.setVisibility(View.INVISIBLE);
        } else if (starRatingView != null) {

            starRatingView.setRating(nativeAd.getStarRating().floatValue());

            starRatingView.setVisibility(View.VISIBLE);
            adView.setStarRatingView(starRatingView);
        }

        if (nativeAd.getAdvertiser() == null && advertiserView != null) {
            advertiserView.setVisibility(View.INVISIBLE);
        } else if (advertiserView != null) {

            advertiserView.setText(nativeAd.getAdvertiser());
            advertiserView.setVisibility(View.VISIBLE);
            adView.setAdvertiserView(advertiserView);
        }

        adView.setNativeAd(nativeAd);
    }

    public void forceFullyLoadNativeSmall(Activity mContext, FrameLayout fAdContainer) {
        if (Constants.INSTANCE.getADSSHOW()) {
            if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeSmallAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {

                View view = mContext.getLayoutInflater().inflate(R.layout.small_native_simmer_layout, null);
                ShimmerFrameLayout shimmerText = view.findViewById(R.id.shimmer_small_view_container);
                shimmerText.startShimmer();

                fAdContainer.addView(view);

                AdLoader builder = new AdLoader.Builder(mContext, Objects.requireNonNull(Constants.INSTANCE.getNative_1())).forNativeAd(new NativeAd.OnNativeAdLoadedListener() {
                    @Override
                    public void onNativeAdLoaded(@NonNull @NotNull NativeAd nativeAd) {

                        NativeAdView adView = (NativeAdView) mContext.getLayoutInflater().inflate(R.layout.layout_google_native_ad_small, null);

                        showNativeForcefully(nativeAd, adView);

                        fAdContainer.removeAllViews();
                        fAdContainer.addView(adView);
                        Constants.INSTANCE.setNativeSmallAdsShowCount(Constants.INSTANCE.getNativeSmallAdsShowCount() + 1);
                        loadNativeSmall(mContext);

                    }


                }).withAdListener(new AdListener() {
                    @Override
                    public void onAdFailedToLoad(@NonNull @NotNull LoadAdError loadAdError) {
                        super.onAdFailedToLoad(loadAdError);
                        Log.e("TAG", "onAdFailedToLoad: " + loadAdError.getMessage());
                        view.setVisibility(View.GONE);
                        fAdContainer.setVisibility(View.GONE);
                    }
                }).build();

                builder.loadAd(new AdRequest.Builder().build());
            } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeSmallAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                View view = mContext.getLayoutInflater().inflate(R.layout.small_native_simmer_layout, null);
                ShimmerFrameLayout shimmerText = view.findViewById(R.id.shimmer_small_view_container);
                shimmerText.startShimmer();

                fAdContainer.addView(view);
                AdView adFacebookView = new AdView(mContext, Constants.INSTANCE.getFaceBookBanner(), AdSize.BANNER_HEIGHT_90);
                adFacebookView.loadAd();
                fAdContainer.removeAllViews();
                fAdContainer.addView(adFacebookView);
                Constants.INSTANCE.setNativeSmallAdsShowCount(Constants.INSTANCE.getNativeSmallAdsShowCount() + 1);
            } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeSmallAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())) {
                View view = mContext.getLayoutInflater().inflate(R.layout.small_native_simmer_layout, null);
                ShimmerFrameLayout shimmerText = view.findViewById(R.id.shimmer_small_view_container);
                shimmerText.startShimmer();

                fAdContainer.addView(view);
                MaxAdView maxAdView = new MaxAdView(Constants.INSTANCE.getAppLovinBanner(), (Context) mContext);
                maxAdView.setLayoutParams(new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, mContext.getResources().getDimensionPixelSize(com.intuit.sdp.R.dimen._50sdp)));
                maxAdView.loadAd();
                maxAdView.setListener(new MaxAdViewAdListener() {
                    public void onAdClicked(MaxAd maxAd) {
                    }

                    public void onAdCollapsed(MaxAd maxAd) {
                    }

                    public void onAdDisplayFailed(MaxAd maxAd, MaxError maxError) {
                    }


                    public void onAdDisplayed(MaxAd maxAd) {
                    }

                    public void onAdExpanded(MaxAd maxAd) {
                    }

                    public void onAdHidden(MaxAd maxAd) {
                    }

                    public void onAdLoaded(MaxAd maxAd) {
                        fAdContainer.removeAllViews();
                        fAdContainer.addView(maxAdView);
                    }

                    public void onAdLoadFailed(String str, MaxError maxError) {

                    }
                });
                Constants.INSTANCE.setNativeSmallAdsShowCount(Constants.INSTANCE.getNativeSmallAdsShowCount() + 1);
            }

        }

    }

    public void forceFullyLoadNativeMedium(Activity mContext, FrameLayout fAdContainer) {

        if (Constants.INSTANCE.getADSSHOW()) {

            if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {

                View view = mContext.getLayoutInflater().inflate(R.layout.medium_native_simmer_layout, null);
                ShimmerFrameLayout shimmerText = view.findViewById(R.id.shimmer_small_view_container);
                shimmerText.startShimmer();

                fAdContainer.addView(view);
                AdLoader builder = new AdLoader.Builder(mContext, Objects.requireNonNull(Constants.INSTANCE.getNative_1())).forNativeAd(new NativeAd.OnNativeAdLoadedListener() {
                    @Override
                    public void onNativeAdLoaded(@NonNull @NotNull NativeAd nativeAd) {

                        NativeAdView adView = (NativeAdView) mContext.getLayoutInflater().inflate(R.layout.layout_google_native_ad_medium, null);

                        showNativeForcefully(nativeAd, adView);
                        Constants.INSTANCE.setNativeMediumAdsShowCount(Constants.INSTANCE.getNativeMediumAdsShowCount() + 1);
                        fAdContainer.removeAllViews();
                        fAdContainer.addView(adView);
                        loadNativeMedium(mContext);

                    }


                }).withAdListener(new AdListener() {
                    @Override
                    public void onAdFailedToLoad(@NonNull @NotNull LoadAdError loadAdError) {
                        super.onAdFailedToLoad(loadAdError);
                        Log.e("TAG", "onAdFailedToLoad: " + loadAdError.getMessage());
                        view.setVisibility(View.GONE);
                        fAdContainer.setVisibility(View.GONE);
                    }
                }).build();

                builder.loadAd(new AdRequest.Builder().build());

            } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                View view = mContext.getLayoutInflater().inflate(R.layout.medium_native_simmer_layout, null);
                ShimmerFrameLayout shimmerText = view.findViewById(R.id.shimmer_small_view_container);
                shimmerText.startShimmer();

                fAdContainer.addView(view);
                com.facebook.ads.NativeAd nativeBannerAd = new com.facebook.ads.NativeAd(mContext, Constants.INSTANCE.getFaceBookMedium());
                NativeAdListener nativeAdListener = new NativeAdListener() {

                    @Override
                    public void onMediaDownloaded(Ad ad) {
                        // Native ad finished downloading all assets
                        Log.e("TAG", "Native ad finished downloading all assets.");
                    }

                    @Override
                    public void onError(Ad ad, AdError adError) {
                        // Native ad failed to load
                        Log.e("TAG", "Native ad failed to load: " + adError.getErrorMessage());
                    }

                    @Override
                    public void onAdLoaded(Ad ad) {
                        // Native ad is loaded and ready to be displayed
                        Log.d("TAG", "Native ad is loaded and ready to be displayed!");
                        fAdContainer.removeAllViews();
                        inflateMediumAd(mContext, nativeBannerAd, fAdContainer);
                        Constants.INSTANCE.setNativeMediumAdsShowCount(Constants.INSTANCE.getNativeMediumAdsShowCount() + 1);
                    }

                    @Override
                    public void onAdClicked(Ad ad) {
                        // Native ad clicked
                        Log.d("TAG", "Native ad clicked!");
                    }

                    @Override
                    public void onLoggingImpression(Ad ad) {
                        // Native ad impression
                        Log.d("TAG", "Native ad impression logged!");
                    }
                };
                // load the ad
                nativeBannerAd.loadAd(
                        nativeBannerAd.buildLoadAdConfig()
                                .withAdListener(nativeAdListener)
                                .build());

            }else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeMediumAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())){
                View view = mContext.getLayoutInflater().inflate(R.layout.medium_native_simmer_layout, null);
                ShimmerFrameLayout shimmerText = view.findViewById(R.id.shimmer_small_view_container);
                shimmerText.startShimmer();

                fAdContainer.addView(view);
                MaxNativeAdLoader nativeAdLoader = new MaxNativeAdLoader(Constants.INSTANCE.getAppLovinNative(), mContext);
                nativeAdLoader.setRevenueListener(new MaxAdRevenueListener() {
                    public void onAdRevenuePaid(MaxAd maxAd) {
                    }
                });
                nativeAdLoader.setNativeAdListener(new MaxNativeAdListener() {
                    public void onNativeAdClicked(MaxAd maxAd) {
                    }

                    public void onNativeAdLoaded(MaxNativeAdView maxNativeAdView, MaxAd maxAd) {
//                if (applovinLoadedNativeAd != null) {
//                    nativeAdLoader.destroy(applovinLoadedNativeAd);
//                }
//                applovinLoadedNativeAd = maxAd;
//                applovinNativeAd_preLoad = maxNativeAdView;
//
//                state_applovinNative = "Loaded";
                        fAdContainer.removeAllViews();
                        fAdContainer.addView(maxNativeAdView);
                        Constants.INSTANCE.setNativeMediumAdsShowCount(Constants.INSTANCE.getNativeMediumAdsShowCount() + 1);
                        loadAppLovinMedium(mContext);

                    }

                    public void onNativeAdLoadFailed(String str, MaxError maxError) {
                    }
                });


                MaxNativeAdViewBinder binder = new MaxNativeAdViewBinder.Builder(R.layout.layout_applovin_native_ad_medium)
                        .setTitleTextViewId(R.id.title_text_view)
                        .setBodyTextViewId(R.id.body_text_view)
                        .setAdvertiserTextViewId(R.id.advertiser_textView)
                        .setIconImageViewId(R.id.icon_image_view)
                        .setMediaContentViewGroupId(R.id.media_view_container)
                        .setOptionsContentViewGroupId(R.id.ad_options_view)
                        .setCallToActionButtonId(R.id.cta_button)
                        .build();
                nativeAdLoader.loadAd(new MaxNativeAdView(binder, mContext));
            }

        }

    }


    public void forceFullyLoadNativeBig(Activity mContext, FrameLayout fAdContainer) {
        if (Constants.INSTANCE.getADSSHOW()) {
            if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getGoogle())) {
                View view = mContext.getLayoutInflater().inflate(R.layout.simmerlayout, null);
                ShimmerFrameLayout shimmerText = view.findViewById(R.id.shimmer_view_container);
                shimmerText.startShimmer();

                fAdContainer.addView(view);
                AdLoader builder = new AdLoader.Builder(mContext, Objects.requireNonNull(Constants.INSTANCE.getNative())).forNativeAd(new NativeAd.OnNativeAdLoadedListener() {
                    @Override
                    public void onNativeAdLoaded(@NonNull @NotNull NativeAd nativeAd) {
                        Log.e("TAG", "forcefully onNativeAdLoaded: " + nativeAd);
                        NativeAdView adView = (NativeAdView) mContext.getLayoutInflater().inflate(R.layout.layout_google_native_ad, null);
                        showNativeForcefully(nativeAd, adView);

                        fAdContainer.removeAllViews();
                        fAdContainer.addView(adView);
                        Constants.INSTANCE.setNativeBigAdsShowCount(Constants.INSTANCE.getNativeBigAdsShowCount() + 1);
                        loadNativeBig(mContext);

                    }


                }).withAdListener(new AdListener() {
                    @Override
                    public void onAdFailedToLoad(@NonNull @NotNull LoadAdError loadAdError) {
                        super.onAdFailedToLoad(loadAdError);
                        Log.e("TAG", "onAdFailedToLoad: " + loadAdError.getMessage());
                        view.setVisibility(View.GONE);
                        fAdContainer.setVisibility(View.GONE);
                    }
                }).build();

                builder.loadAd(new AdRequest.Builder().build());
            } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getFaceBook())) {
                View view = mContext.getLayoutInflater().inflate(R.layout.simmerlayout, null);
                ShimmerFrameLayout shimmerText = view.findViewById(R.id.shimmer_view_container);
                shimmerText.startShimmer();

                fAdContainer.addView(view);
                com.facebook.ads.NativeAd nativeAd;
                nativeAd = new com.facebook.ads.NativeAd(mContext, Constants.INSTANCE.getFaceBookNative());

                NativeAdListener nativeAdListener = new NativeAdListener() {

                    @Override
                    public void onMediaDownloaded(Ad ad) {
                    }

                    @Override
                    public void onError(Ad ad, AdError adError) {
                    }

                    @Override
                    public void onAdLoaded(Ad ad) {
                        if (nativeAd == null || nativeAd != ad) {
                            return;
                        }
                        fAdContainer.removeAllViews();
                        inflateAd(mContext, nativeAd, fAdContainer);
                        Constants.INSTANCE.setNativeBigAdsShowCount(Constants.INSTANCE.getNativeBigAdsShowCount() + 1);
                    }

                    @Override
                    public void onAdClicked(Ad ad) {
                    }

                    @Override
                    public void onLoggingImpression(Ad ad) {
                    }
                };
                nativeAd.loadAd(nativeAd.buildLoadAdConfig().withAdListener(nativeAdListener).build());

            } else if (Constants.INSTANCE.getAdsArray().get(Constants.INSTANCE.getNativeBigAdsShowCount()).equals(Constants.INSTANCE.getAppLovin())) {
                View view = mContext.getLayoutInflater().inflate(R.layout.simmerlayout, null);
                ShimmerFrameLayout shimmerText = view.findViewById(R.id.shimmer_view_container);
                shimmerText.startShimmer();

                fAdContainer.addView(view);
                MaxNativeAdLoader nativeAdLoader = new MaxNativeAdLoader(Constants.INSTANCE.getAppLovinNative(), mContext);

                nativeAdLoader.setRevenueListener(new MaxAdRevenueListener() {
                    public void onAdRevenuePaid(MaxAd maxAd) {
                    }
                });
                nativeAdLoader.setNativeAdListener(new MaxNativeAdListener() {
                    public void onNativeAdClicked(MaxAd maxAd) {
                    }

                    public void onNativeAdLoaded(MaxNativeAdView maxNativeAdView, MaxAd maxAd) {
                        fAdContainer.removeAllViews();
                        fAdContainer.addView(maxNativeAdView);
                        Constants.INSTANCE.setNativeBigAdsShowCount(Constants.INSTANCE.getNativeBigAdsShowCount() + 1);
                        loadApplovinNative(mContext);
                    }

                    public void onNativeAdLoadFailed(String str, MaxError maxError) {
                        Log.e("", "onNativeAdLoadFailed: ");
                    }
                });


                MaxNativeAdViewBinder binder = new MaxNativeAdViewBinder.Builder(R.layout.layout_applovin_native)
                        .setTitleTextViewId(R.id.title_text_view)
                        .setBodyTextViewId(R.id.body_text_view)
                        .setAdvertiserTextViewId(R.id.advertiser_textView)
                        .setIconImageViewId(R.id.icon_image_view)
                        .setMediaContentViewGroupId(R.id.media_view_container)
                        .setOptionsContentViewGroupId(R.id.ad_options_view)
                        .setCallToActionButtonId(R.id.cta_button)
                        .build();
                nativeAdLoader.loadAd(new MaxNativeAdView(binder, mContext));
            }
        }

    }

    public void showNativeForcefully(NativeAd nativeAd, NativeAdView adView) {
        Log.e("TAG", "forcefully showNativeForcefully: " + nativeAd);
        MediaView mediaView = adView.findViewById(R.id.ad_media);
        TextView headlineView = adView.findViewById(R.id.ad_headline);
        TextView bodyView = adView.findViewById(R.id.ad_body);
        TextView callToActionView = adView.findViewById(R.id.ad_call_to_action);
        ImageView iconView = adView.findViewById(R.id.ad_app_icon);
        TextView priceView = adView.findViewById(R.id.ad_price);
        RatingBar starRatingView = adView.findViewById(R.id.ad_stars);
        TextView storeView = adView.findViewById(R.id.ad_store);
        TextView advertiserView = adView.findViewById(R.id.ad_advertiser);


        headlineView.setText(nativeAd.getHeadline());
        adView.setHeadlineView(headlineView);

        if (nativeAd.getMediaContent() != null && mediaView != null) {
            mediaView.setMediaContent(nativeAd.getMediaContent());
            adView.setMediaView(mediaView);

        }

        if (nativeAd.getBody() == null && bodyView != null) {
            bodyView.setVisibility(View.GONE);
        } else if (bodyView != null) {
            bodyView.setVisibility(View.VISIBLE);

            bodyView.setText(nativeAd.getBody());
            adView.setBodyView(bodyView);
        }

        if (nativeAd.getCallToAction() == null && callToActionView != null) {
            callToActionView.setVisibility(View.INVISIBLE);
        } else if (callToActionView != null) {

            callToActionView.setVisibility(View.VISIBLE);

            callToActionView.setText(nativeAd.getCallToAction());
            adView.setCallToActionView(callToActionView);
        }

        if (nativeAd.getIcon() == null && iconView != null) {
            iconView.setVisibility(View.GONE);
        } else if (iconView != null) {
            iconView.setImageDrawable(nativeAd.getIcon().getDrawable());
            iconView.setVisibility(View.VISIBLE);
            adView.setIconView(iconView);

        }

        if (nativeAd.getPrice() == null && priceView != null) {
            priceView.setVisibility(View.INVISIBLE);
        } else if (priceView != null) {
            priceView.setVisibility(View.VISIBLE);

            priceView.setText(nativeAd.getPrice());
            adView.setPriceView(priceView);

        }

        if (nativeAd.getHeadline() == null && storeView != null) {
            storeView.setVisibility(View.INVISIBLE);
        } else if (storeView != null) {
            storeView.setVisibility(View.VISIBLE);
            storeView.setText(nativeAd.getHeadline());
            adView.setBodyView(storeView);
        }
//        if (nativeAd.getStore() == null && storeView != null) {
//            storeView.setVisibility(View.INVISIBLE);
//        } else if (storeView != null) {
//            storeView.setVisibility(View.VISIBLE);
//
//            storeView.setText(nativeAd.getStore());
//
//            adView.setStoreView(storeView);
//
//        }

        if (priceView != null) {
            priceView.setVisibility(View.GONE);
        }
//        if (storeView != null) {
//            storeView.setVisibility(View.GONE);
//        }

        if (nativeAd.getStarRating() == null && starRatingView != null) {
            starRatingView.setVisibility(View.INVISIBLE);
        } else if (starRatingView != null) {

            starRatingView.setRating(nativeAd.getStarRating().floatValue());

            starRatingView.setVisibility(View.VISIBLE);
            adView.setStarRatingView(starRatingView);
        }

        if (nativeAd.getAdvertiser() == null && advertiserView != null) {
            advertiserView.setVisibility(View.INVISIBLE);
        } else if (advertiserView != null) {

            advertiserView.setText(nativeAd.getAdvertiser());
            advertiserView.setVisibility(View.VISIBLE);
            adView.setAdvertiserView(advertiserView);
        }

        adView.setNativeAd(nativeAd);
    }

    interface NativeAdListenerClass {
        void onAdLoaded();

        void onAdFailedToLoad();

        void onAdShow();
    }
}
