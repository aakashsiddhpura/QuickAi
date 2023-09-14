package com.ads.code;

import static androidx.lifecycle.Lifecycle.Event.ON_START;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.OnLifecycleEvent;
import androidx.lifecycle.ProcessLifecycleOwner;

import com.google.android.gms.ads.AdError;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.FullScreenContentCallback;
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.appopen.AppOpenAd;

import org.jetbrains.annotations.NotNull;

import java.util.Date;
import java.util.Objects;

public class AppOpenManager implements LifecycleObserver, Application.ActivityLifecycleCallbacks {

    private static final String LOG_TAG = "AppOpenManager";
    private static boolean isShowingAd = false;
    private MainApp myApplication;
    private AppOpenAd appOpenAd = null;
    private AppOpenAd.AppOpenAdLoadCallback loadCallback;
    private Activity currentActivity;
    private long loadTime = 0;


    /**
     * Constructor
     */
    public AppOpenManager(MainApp myApplication, Context activity) {
        this.myApplication = myApplication;
        this.myApplication.registerActivityLifecycleCallbacks(this);
        ProcessLifecycleOwner.get().getLifecycle().addObserver(this);
        /**/
    }

    /**
     * Shows the ad if one isn't already showing.
     */
    public void showAdIfAvailable() {
        // Only show ad if there is not already an app open ad currently showing
        // and an ad is available.
        if (Constants.INSTANCE.getADSSHOW()&& Constants.INSTANCE.getOnResumeAdShow()) {
            if (!isShowingAd && isAdAvailable()) {
                Log.e(LOG_TAG, "Will show ad.");
                appOpenAd.setFullScreenContentCallback(new FullScreenContentCallback() {
                    @Override
                    public void onAdFailedToShowFullScreenContent(@NonNull @NotNull AdError adError) {
                        super.onAdFailedToShowFullScreenContent(adError);
                        Log.e(LOG_TAG, "onAdFailedToShowFullScreenContent: SHOW"+adError.getMessage() );
                    }

                    @Override
                    public void onAdShowedFullScreenContent() {
                        super.onAdShowedFullScreenContent();
                        Log.e("TAG", "onAdShowedFullScreenContent: show" );
                                isShowingAd = true;
                    }

                    @Override
                    public void onAdDismissedFullScreenContent() {
                        super.onAdDismissedFullScreenContent();
                        // Set the reference to null so isAdAvailable() returns false.
                        AppOpenManager.this.appOpenAd = null;
                        isShowingAd = false;
                        fetchAd();
                    }

                    @Override
                    public void onAdImpression() {
                        super.onAdImpression();
                    }
                });

//                FullScreenContentCallback fullScreenContentCallback =
//                        new FullScreenContentCallback() {
//                            @Override
//                            public void onAdDismissedFullScreenContent() {
//                                // Set the reference to null so isAdAvailable() returns false.
//                                AppOpenManager.this.appOpenAd = null;
//                                isShowingAd = false;
//                                fetchAd();
//                            }
//
//                            @Override
//                            public void onAdFailedToShowFullScreenContent(AdError adError) {
//                                Log.e("TAG", "onAdFailedToShowFullScreenContent: show" );
//                            }
//
//                            @Override
//                            public void onAdShowedFullScreenContent() {
//                                Log.e("TAG", "onAdShowedFullScreenContent: show" );
//                                isShowingAd = true;
//                            }
//                        };
//                appOpenAd.setFullScreenContentCallback(fullScreenContentCallback);
                appOpenAd.show(currentActivity);

            } else {
                Log.e(LOG_TAG, "Can not show ad.");
                fetchAd();
                if (Constants.INSTANCE.getAppOpen() != "/6499/example/app-open"&& Constants.INSTANCE.getOnResumeAdShow()) {
                    AdRequest request = getAdRequest();
                    AppOpenAd.load(currentActivity, Objects.requireNonNull(Constants.INSTANCE.getAppOpen()), request, AppOpenAd.APP_OPEN_AD_ORIENTATION_PORTRAIT, new AppOpenAd.AppOpenAdLoadCallback() {
                        @Override
                        public void onAdLoaded(@NonNull @NotNull AppOpenAd appOpenAd) {
                            super.onAdLoaded(appOpenAd);
                            appOpenAd.setFullScreenContentCallback(new FullScreenContentCallback() {
                                @Override
                                public void onAdFailedToShowFullScreenContent(@NonNull @NotNull AdError adError) {
                                    super.onAdFailedToShowFullScreenContent(adError);
                                    Log.e(LOG_TAG, "onAdFailedToShowFullScreenContent: forcefully");
                                }

                                @Override
                                public void onAdShowedFullScreenContent() {
                                    super.onAdShowedFullScreenContent();
                                }

                                @Override
                                public void onAdDismissedFullScreenContent() {
                                    super.onAdDismissedFullScreenContent();
                                }

                                @Override
                                public void onAdImpression() {
                                    super.onAdImpression();
                                }
                            });
                            appOpenAd.show(currentActivity);

                        }

                        @Override
                        public void onAdFailedToLoad(@NonNull @NotNull LoadAdError loadAdError) {
                            super.onAdFailedToLoad(loadAdError);
                            Log.e(LOG_TAG, "onAdFailedToLoad: forcefully");
                        }
                    });

                }
            }
        }
    }

    /**
     * LifecycleObserver methods
     */
    @OnLifecycleEvent(ON_START)
    public void onStart() {

        if (currentActivity instanceof MainActivity) {

        } else {
            showAdIfAvailable();
            Log.e(LOG_TAG, "onStart");

        }
    }

    /**
     * Request an ad
     */
    public void fetchAd() {
        // Have unused ad, no need to fetch another.

        if (Constants.INSTANCE.getAppOpen() != "/6499/example/app-open" && Constants.INSTANCE.getOnResumeAdShow()) {

            if (isAdAvailable()) {
                return;
            }

            loadCallback =
                    new AppOpenAd.AppOpenAdLoadCallback() {
                        @Override
                        public void onAdLoaded(@NonNull AppOpenAd appOpenAd) {
                            super.onAdLoaded(appOpenAd);
                            AppOpenManager.this.appOpenAd = appOpenAd;
                            AppOpenManager.this.loadTime = (new Date()).getTime();
                        }

                        @Override
                        public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
                            super.onAdFailedToLoad(loadAdError);
                            Log.e(LOG_TAG, "failed to load");
                        }

                    };
            AdRequest request = getAdRequest();
            AppOpenAd.load(
                    myApplication, Constants.INSTANCE.getAppOpen(), request,
                    AppOpenAd.APP_OPEN_AD_ORIENTATION_PORTRAIT, loadCallback);

        }


    }

    /**
     * Creates and returns ad request.
     */
    private AdRequest getAdRequest() {
        return new AdRequest.Builder().build();
    }

    /**
     * Utility method to check if ad was loaded more than n hours ago.
     */
    private boolean wasLoadTimeLessThanNHoursAgo(long numHours) {
        long dateDifference = (new Date()).getTime() - this.loadTime;
        long numMilliSecondsPerHour = 3600000;
        return (dateDifference < (numMilliSecondsPerHour * numHours));
    }

    /**
     * Utility method that checks if ad exists and can be shown.
     */
    public boolean isAdAvailable() {
        return appOpenAd != null && wasLoadTimeLessThanNHoursAgo(4);
    }

    @Override
    public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {

    }

    @Override
    public void onActivityStarted(Activity activity) {
        currentActivity = activity;
    }

    @Override
    public void onActivityResumed(Activity activity) {
        currentActivity = activity;
    }

    @Override
    public void onActivityPaused(@NonNull Activity activity) {

    }

    @Override
    public void onActivityStopped(@NonNull Activity activity) {

    }

    @Override
    public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {

    }

    @Override
    public void onActivityDestroyed(Activity activity) {
        currentActivity = null;
    }


}
