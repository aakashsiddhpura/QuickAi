package com.ads.code;

import android.app.Application;

public class MainApp extends Application {
    MainApp mainApp;
    @Override
    public void onCreate() {
        super.onCreate();
        mainApp= this;
        AppOpenManager appOpenManager = new AppOpenManager(mainApp,getApplicationContext());
        appOpenManager.fetchAd();
    }
}
