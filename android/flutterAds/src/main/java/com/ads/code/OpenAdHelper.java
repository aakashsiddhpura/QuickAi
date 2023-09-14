package com.ads.code;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.AdError;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.FullScreenContentCallback;
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.appopen.AppOpenAd;import com.ads.code.Constants;

import org.jetbrains.annotations.NotNull;

import java.util.Objects;

public class OpenAdHelper {


    AppOpenAd mAppOpenAd = null;

    public void loadOpenAds(Activity mActivity,openAdListener adListener){

        if (Constants.INSTANCE.getADSSHOW()) {
            AdRequest adRequest = new AdRequest.Builder().build();

            AppOpenAd.load(mActivity, Objects.requireNonNull(Constants.INSTANCE.getAppOpen()), adRequest, AppOpenAd.APP_OPEN_AD_ORIENTATION_PORTRAIT, new AppOpenAd.AppOpenAdLoadCallback() {
                @Override
                public void onAdLoaded(@NonNull @NotNull AppOpenAd appOpenAd) {
                    super.onAdLoaded(appOpenAd);
                    mAppOpenAd = appOpenAd;
                    adListener.onAdLoaded(appOpenAd);

                    mAppOpenAd.setFullScreenContentCallback(new FullScreenContentCallback() {
                        @Override
                        public void onAdFailedToShowFullScreenContent(@NonNull @NotNull AdError adError) {
                            super.onAdFailedToShowFullScreenContent(adError);
                        }

                        @Override
                        public void onAdShowedFullScreenContent() {
                            super.onAdShowedFullScreenContent();
                            mAppOpenAd = null;
                        }

                        @Override
                        public void onAdDismissedFullScreenContent() {
                            super.onAdDismissedFullScreenContent();

                            adListener.onAdClosed();
                        }

                        @Override
                        public void onAdImpression() {
                            super.onAdImpression();
                        }
                    });

                }

                @Override
                public void onAdFailedToLoad(@NonNull @NotNull LoadAdError loadAdError) {
                    super.onAdFailedToLoad(loadAdError);
                    mAppOpenAd = null;
                    adListener.onAdFailedToLoad();
                }
            });
        }else {
            adListener.onAdClosed();
        }
    }


    public interface openAdListener{
        void onAdClosed();
        void onAdFailedToLoad();
        void onAdLoaded( AppOpenAd appOpenAd);
    }
}
