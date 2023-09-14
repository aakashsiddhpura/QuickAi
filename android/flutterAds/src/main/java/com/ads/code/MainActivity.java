package com.ads.code;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.applovin.mediation.MaxAd;
import com.applovin.mediation.MaxAdViewAdListener;
import com.applovin.mediation.MaxError;
import com.applovin.mediation.ads.MaxAdView;
import com.google.android.gms.ads.appopen.AppOpenAd;

import java.util.ArrayList;

public class MainActivity extends AppCompatActivity  {
    private OpenAdHelper mOpenAdHelper;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ArrayList<String> adsArray =new ArrayList<>();

        if (Constants.INSTANCE.getGoogleAdsShow()){
            adsArray.add(Constants.INSTANCE.getGoogle());
        }

        if (Constants.INSTANCE.getFaceBookAdsShow()){
            adsArray.add(Constants.INSTANCE.getFaceBook());
        }
        if (Constants.INSTANCE.getAppLovinAdsShow()){
            adsArray.add(Constants.INSTANCE.getAppLovin());
        }

        Constants.INSTANCE.setAdsArray(adsArray);
        mOpenAdHelper = new OpenAdHelper();
        if (Constants.INSTANCE.getFaceBookAdsShow()) {
            new InterstitialAdHelper(this).onFacebookAdLoad();
            new NativeAdvanceHelper().loadFaceBookNativeSmall(this);
            new NativeAdvanceHelper().loadFacebookNativeBig(this);
            new NativeAdvanceHelper().loadFaceBookNativeMedium(this);
        }
        if (Constants.INSTANCE.getIsOpenInterAdShow()) {
            new OpenInterAdHelper(this).OpenInterLoad();
        }
        if (Constants.INSTANCE.getGoogleAdsShow()) {
            new InterstitialAdHelper(this).onAdLoad();
            new NativeAdvanceHelper().loadNativeBig(this);
            new NativeAdvanceHelper().loadNativeMedium(this);
            new NativeAdvanceHelper().loadNativeSmall(this);
        }
        if (Constants.INSTANCE.getAppLovinAdsShow()){
            new InterstitialAdHelper(this).onAppLovinAdLoad();
            new NativeAdvanceHelper().loadAppLovinNativeSmall(this);
            new NativeAdvanceHelper().loadAppLovinMedium(this);
            new NativeAdvanceHelper().loadApplovinNative(this);
        }




    }

    private void nextActivity() {
//        startActivity(new Intent(MainActivity.this,MainActivity2.class));
    }
}