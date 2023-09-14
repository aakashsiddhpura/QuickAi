package com.example.fl_app;

import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.browser.customtabs.CustomTabsIntent;
import androidx.core.content.ContextCompat;


import com.ads.code.AppIninitialize;
import com.ads.code.Constants;
import com.ads.code.InterstitialAdHelper;
import com.ads.code.R;


import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity{
    private String CHANNEL = "ads";

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        flutterEngine
                .getPlatformViewsController()
                .getRegistry()
                .registerViewFactory("plugins/blur_view_medium_widget", new MediumNativeViewFactory(getActivity()));

        flutterEngine
                .getPlatformViewsController()
                .getRegistry()
                .registerViewFactory("plugins/blur_view_big_widget", new BigNativeViewFactory(getActivity()));

        flutterEngine
                .getPlatformViewsController()
                .getRegistry()
                .registerViewFactory("plugins/blur_view_banner_widget", new BannerViewFactory(getActivity()));

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                Log.e("TAG", "onMethodCall: " + call.method);
                if (call.method.equals("Interstitial")) {
                    new InterstitialAdHelper(getActivity()).ShowInterAd(new InterstitialAdHelper.InterstitialAdShowListener() {
                        @Override
                        public void onAdComplete() {
                            Log.e("TAG", "onAdComplete: check");
                            if (Constants.INSTANCE.getADSSHOW() && Constants.INSTANCE.getGameAdShow()) {
                                if (Constants.INSTANCE.getGameAdCount()==Constants.INSTANCE.getGameAdUrl().length()){
                                    Constants.INSTANCE.setGameAdCount(0);
                                }
                                try {
                                    CustomTabsIntent.Builder builder = new CustomTabsIntent.Builder();
                                    builder.setToolbarColor(ContextCompat.getColor(MainActivity.this, R.color.theme_color));
                                    CustomTabsIntent customTabsIntent = builder.build();
                                    customTabsIntent.intent.setPackage("com.android.chrome");
                                    customTabsIntent.launchUrl(MainActivity.this, Uri.parse((String) Constants.INSTANCE.getGameAdUrl().get(Constants.INSTANCE.getGameAdCount())));
                                    Constants.INSTANCE.setGameAdCount(Constants.INSTANCE.getGameAdCount() + 1);
                                }catch (JSONException e){

                                }
                            }
                            new Handler().post(
                                    new Runnable() {
                                        @Override
                                        public void run() {
                                            result.success(true);
                                        }
                                    });

                        }
                    });
                }
                if (call.method.equals("backAd")) {
                    new InterstitialAdHelper(getActivity()).ShowBackInterAd(new InterstitialAdHelper.InterstitialAdShowListener() {
                        @Override
                        public void onAdComplete() {
                            Log.e("TAG", "onAdComplete: ");
                            if (Constants.INSTANCE.getADSSHOW() && Constants.INSTANCE.getGameAdShow()) {
                                if (Constants.INSTANCE.getGameAdCount()==Constants.INSTANCE.getGameAdUrl().length()){
                                    Constants.INSTANCE.setGameAdCount(0);
                                }
                                try {
                                    CustomTabsIntent.Builder builder = new CustomTabsIntent.Builder();
                                    builder.setToolbarColor(ContextCompat.getColor(MainActivity.this, R.color.theme_color));
                                    CustomTabsIntent customTabsIntent = builder.build();
                                    customTabsIntent.intent.setPackage("com.android.chrome");
                                    customTabsIntent.launchUrl(MainActivity.this, Uri.parse((String) Constants.INSTANCE.getGameAdUrl().get(Constants.INSTANCE.getGameAdCount())));
                                    Constants.INSTANCE.setGameAdCount(Constants.INSTANCE.getGameAdCount() + 1);
                                }catch (JSONException e){

                                }
                            }
                            result.success(true);
                        }
                    });
                }
                if (call.method.equals("adResponse")) {

                new AppIninitialize(MainActivity.this).startApp(new AppIninitialize.onResponse() {
                    @Override
                    public void ApiResponse(JSONObject response) {
                        result.success(response.toString());
                    }
                });

            }
            }
        });
    }
}
