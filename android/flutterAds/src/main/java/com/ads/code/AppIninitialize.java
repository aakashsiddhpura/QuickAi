package com.ads.code;

import android.app.Activity;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import com.applovin.sdk.AppLovinSdk;
import com.applovin.sdk.AppLovinSdkConfiguration;
import com.google.android.gms.ads.appopen.AppOpenAd;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class AppIninitialize {
    Activity mContext;
    private OpenAdHelper mOpenAdHelper;

    public AppIninitialize(Activity mContext) {
        this.mContext = mContext;

    }

    public void startApp(onResponse responseApi) {
        RequestQueue requestQueue = new Volley().newRequestQueue(mContext);
       Log.e("TAG", "startApp: "+mContext.getPackageName());
        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, "http://plumtech.online/flutterJson/"+mContext.getPackageName()+".txt", null, new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject response) {
                Log.e("TAG", "onResponse: " + response);
                try {
                    Constants.INSTANCE.setInstallTrack(response.getBoolean("install_track"));
                    Constants.INSTANCE.setMatchTrackUrl(response.getBoolean("match_track_url"));
                    Constants.INSTANCE.setTrackUrl(response.getJSONArray("track_url"));
                    Constants.INSTANCE.setInterstitial(response.getString("google_intertital"));
                    Constants.INSTANCE.setAppOpen(response.getString("google_appOpenAd"));
                    Constants.INSTANCE.setNative(response.getString("google_native"));
                    Constants.INSTANCE.setNative_1(response.getString("google_banner"));

                    Constants.INSTANCE.setFaceBookInterstitial(response.getString("facebook_interstitial"));
                    Constants.INSTANCE.setFaceBookBanner(response.getString("facebook_banner"));
                    Constants.INSTANCE.setFaceBookMedium(response.getString("facebook_medium_native"));
                    Constants.INSTANCE.setFaceBookNative(response.getString("facebook_native"));

                    Constants.INSTANCE.setAppLovinInterstitial(response.getString("applovin_interstitial"));
                    Constants.INSTANCE.setAppLovinBanner(response.getString("applovin_banner"));
                    Constants.INSTANCE.setAppLovinNative(response.getString("applovin_native"));

                    Constants.INSTANCE.setAPPINTERCOUNT(response.getInt("app_inter_Count"));
                    Constants.INSTANCE.setBACKINTERCOUNT(response.getInt("back_inter_Count"));

                    Constants.INSTANCE.setIsFullyForceOpenInter(response.getBoolean("is_fully_force_open_inter"));
                    Constants.INSTANCE.setIsFullyForceBackOpenInter(response.getBoolean("is_fully_force_back_open_inter"));
                    Constants.INSTANCE.setIsOpenInterAdShow(response.getBoolean("is_open_inter_ad_show"));
                    Constants.INSTANCE.setIsBackOpenInterAdShow(response.getBoolean("is_back_open_inter_ad_show"));

                    Constants.INSTANCE.setISFULLYFORCEALLPLACEADS(response.getBoolean("is_fully_force_all_place_ads"));
                    Constants.INSTANCE.setISFULLYFORCEBACKADS(response.getBoolean("is_fully_force_back_ads"));

                    Constants.INSTANCE.setIsFullyForceNative(response.getBoolean("is_fully_force_native"));
                    Constants.INSTANCE.setIsFullyForceMediumNative(response.getBoolean("is_fully_force_medium_native"));
                    Constants.INSTANCE.setIsFullyForceSmallNative(response.getBoolean("is_fully_force_small_native"));

                    Constants.INSTANCE.setIsInterstitialOnlineCount(response.getInt("is_inter_online_load_count"));
                    Constants.INSTANCE.setIsOpenOnlineCount(response.getInt("is_open_online_load_count"));
                    Constants.INSTANCE.setIsNativeBigOnlineCount(response.getInt("is_nativeBig_online_load_count"));
                    Constants.INSTANCE.setIsNativeMediumOnlineCount(response.getInt("is_nativeMedium_online_load_count"));
                    Constants.INSTANCE.setIsNativeSmallOnlineCount(response.getInt("is_nativeSmall_online_load_count"));
                    Constants.INSTANCE.setIsOnlyForceFullyInterstitial(response.getBoolean("is_only_force_fully_interstitial"));
                    Constants.INSTANCE.setIsOnlyForceFullyOpen(response.getBoolean("is_only_force_fully_open"));
                    Constants.INSTANCE.setIsOnlyForceFullyNativeBig(response.getBoolean("is_only_force_fully_nativeBig"));
                    Constants.INSTANCE.setIsOnlyForceFullyNativeMedium(response.getBoolean("is_only_force_fully_nativeMedium"));
                    Constants.INSTANCE.setIsOnlyForceFullyNativeSmall(response.getBoolean("is_only_force_fully_nativeSmall"));

                    Constants.INSTANCE.setGoogleAdsShow(response.getBoolean("google_ads_show"));
                    Constants.INSTANCE.setFaceBookAdsShow(response.getBoolean("face_book_ads_show"));
                    Constants.INSTANCE.setAppLovinAdsShow(response.getBoolean("apploin_ads_show"));
                    Constants.INSTANCE.setAlterNativeAdsShow(response.getBoolean("alter_native_ads_show"));


                    Constants.INSTANCE.setBACKADSSHOW(response.getBoolean("back_ads_show"));
                    Constants.INSTANCE.setSPLASHADSHOW(response.getBoolean("splash_ad_show"));
                    Constants.INSTANCE.setSplashOpenAdShow(response.getBoolean("splash_open_ad_show"));
                    Constants.INSTANCE.setOnResumeAdShow(response.getBoolean("on_resume_ad_show"));
                    Constants.INSTANCE.setGameAdShow(response.getBoolean("game_ads_show"));
                    Constants.INSTANCE.setGameAdUrl(response.getJSONArray("game_ads_url"));

                    Constants.INSTANCE.setADSSHOW(response.getBoolean("ads_show"));
                } catch (JSONException e) {
                    throw new RuntimeException(e);
                }
                if (Constants.INSTANCE.getInstallTrack()) {
                    new CheckReferrelApi().checkReferrel(mContext, new CheckReferrelApi.CompleteProcess() {
                        @Override
                        public void Complete(boolean refrrelResult) {
                            JSONObject responseTrack = null;
                            if (!refrrelResult) {
                                try {
                                    responseTrack = response.getJSONObject("track_data");
                                    Constants.INSTANCE.setInterstitial(responseTrack.getString("google_intertital"));
                                    Constants.INSTANCE.setAppOpen(responseTrack.getString("google_appOpenAd"));
                                    Constants.INSTANCE.setNative(responseTrack.getString("google_native"));
                                    Constants.INSTANCE.setNative_1(responseTrack.getString("google_banner"));

                                    Constants.INSTANCE.setFaceBookInterstitial(responseTrack.getString("facebook_interstitial"));
                                    Constants.INSTANCE.setFaceBookBanner(responseTrack.getString("facebook_banner"));
                                    Constants.INSTANCE.setFaceBookMedium(responseTrack.getString("facebook_medium_native"));
                                    Constants.INSTANCE.setFaceBookNative(responseTrack.getString("facebook_native"));

                                    Constants.INSTANCE.setAppLovinInterstitial(responseTrack.getString("applovin_interstitial"));
                                    Constants.INSTANCE.setAppLovinBanner(responseTrack.getString("applovin_banner"));
                                    Constants.INSTANCE.setAppLovinNative(responseTrack.getString("applovin_native"));

                                    Constants.INSTANCE.setAPPINTERCOUNT(responseTrack.getInt("app_inter_Count"));
                                    Constants.INSTANCE.setBACKINTERCOUNT(responseTrack.getInt("back_inter_Count"));

                                    Constants.INSTANCE.setIsFullyForceOpenInter(responseTrack.getBoolean("is_fully_force_open_inter"));
                                    Constants.INSTANCE.setIsFullyForceBackOpenInter(responseTrack.getBoolean("is_fully_force_back_open_inter"));
                                    Constants.INSTANCE.setIsOpenInterAdShow(responseTrack.getBoolean("is_open_inter_ad_show"));
                                    Constants.INSTANCE.setIsBackOpenInterAdShow(responseTrack.getBoolean("is_back_open_inter_ad_show"));

                                    Constants.INSTANCE.setISFULLYFORCEALLPLACEADS(responseTrack.getBoolean("is_fully_force_all_place_ads"));
                                    Constants.INSTANCE.setISFULLYFORCEBACKADS(responseTrack.getBoolean("is_fully_force_back_ads"));

                                    Constants.INSTANCE.setIsFullyForceNative(responseTrack.getBoolean("is_fully_force_native"));
                                    Constants.INSTANCE.setIsFullyForceMediumNative(responseTrack.getBoolean("is_fully_force_medium_native"));
                                    Constants.INSTANCE.setIsFullyForceSmallNative(responseTrack.getBoolean("is_fully_force_small_native"));

                                    Constants.INSTANCE.setIsInterstitialOnlineCount(responseTrack.getInt("is_inter_online_load_count"));
                                    Constants.INSTANCE.setIsOpenOnlineCount(responseTrack.getInt("is_open_online_load_count"));
                                    Constants.INSTANCE.setIsNativeBigOnlineCount(responseTrack.getInt("is_nativeBig_online_load_count"));
                                    Constants.INSTANCE.setIsNativeMediumOnlineCount(responseTrack.getInt("is_nativeMedium_online_load_count"));
                                    Constants.INSTANCE.setIsNativeSmallOnlineCount(responseTrack.getInt("is_nativeSmall_online_load_count"));
                                    Constants.INSTANCE.setIsOnlyForceFullyInterstitial(responseTrack.getBoolean("is_only_force_fully_interstitial"));
                                    Constants.INSTANCE.setIsOnlyForceFullyOpen(responseTrack.getBoolean("is_only_force_fully_open"));
                                    Constants.INSTANCE.setIsOnlyForceFullyNativeBig(responseTrack.getBoolean("is_only_force_fully_nativeBig"));
                                    Constants.INSTANCE.setIsOnlyForceFullyNativeMedium(responseTrack.getBoolean("is_only_force_fully_nativeMedium"));
                                    Constants.INSTANCE.setIsOnlyForceFullyNativeSmall(responseTrack.getBoolean("is_only_force_fully_nativeSmall"));

                                    Constants.INSTANCE.setGoogleAdsShow(responseTrack.getBoolean("google_ads_show"));
                                    Constants.INSTANCE.setFaceBookAdsShow(responseTrack.getBoolean("face_book_ads_show"));
                                    Constants.INSTANCE.setAppLovinAdsShow(responseTrack.getBoolean("apploin_ads_show"));
                                    Constants.INSTANCE.setAlterNativeAdsShow(responseTrack.getBoolean("alter_native_ads_show"));


                                    Constants.INSTANCE.setBACKADSSHOW(responseTrack.getBoolean("back_ads_show"));
                                    Constants.INSTANCE.setSPLASHADSHOW(responseTrack.getBoolean("splash_ad_show"));
                                    Constants.INSTANCE.setSplashOpenAdShow(responseTrack.getBoolean("splash_open_ad_show"));
                                    Constants.INSTANCE.setOnResumeAdShow(responseTrack.getBoolean("on_resume_ad_show"));
                                    Constants.INSTANCE.setGameAdShow(responseTrack.getBoolean("game_ads_show"));
                                    Constants.INSTANCE.setGameAdUrl(responseTrack.getJSONArray("game_ads_url"));

                                    Constants.INSTANCE.setADSSHOW(responseTrack.getBoolean("ads_show"));
                                }
                                catch (Exception e) {
                                    e.printStackTrace();
                                    Toast.makeText(mContext, "TAG" + e.getMessage(), Toast.LENGTH_SHORT).show();
                                }
                            }
                            initilizeAds(responseApi, responseTrack);
                        }
                    });
                } else {
                    initilizeAds(responseApi, response);
                }


            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(mContext, "Please Internet Connection on", Toast.LENGTH_LONG).show();
                Log.e("TAG", "onErrorResponse: " + error.getMessage());

            }
        });
        jsonObjectRequest.setShouldCache(false);
        requestQueue.add(jsonObjectRequest);
    }

    public void initilizeAds(onResponse onResponse, JSONObject jsonObject) {
        AppLovinSdk.getInstance(mContext).setMediationProvider("max");
        AppLovinSdk.initializeSdk(mContext, new AppLovinSdk.SdkInitializationListener() {
            @Override
            public void onSdkInitialized(final AppLovinSdkConfiguration configuration) {
                // AppLovin SDK is initialized, start loading ads
            }
        });
        ArrayList<String> adsArray = new ArrayList<>();

        if (Constants.INSTANCE.getGoogleAdsShow()) {
            adsArray.add(Constants.INSTANCE.getGoogle());
        }

        if (Constants.INSTANCE.getFaceBookAdsShow()) {
            adsArray.add(Constants.INSTANCE.getFaceBook());
        }
        if (Constants.INSTANCE.getAppLovinAdsShow()) {
            adsArray.add(Constants.INSTANCE.getAppLovin());
        }

        Constants.INSTANCE.setAdsArray(adsArray);
        if (Constants.INSTANCE.getFaceBookAdsShow()) {
            new InterstitialAdHelper(mContext).onFacebookAdLoad();
            new NativeAdvanceHelper().loadFaceBookNativeSmall(mContext);
            new NativeAdvanceHelper().loadFacebookNativeBig(mContext);
            new NativeAdvanceHelper().loadFaceBookNativeMedium(mContext);
        }

        if (Constants.INSTANCE.getGoogleAdsShow()) {
            new InterstitialAdHelper(mContext).onAdLoad();
            new NativeAdvanceHelper().loadNativeBig(mContext);
            new NativeAdvanceHelper().loadNativeMedium(mContext);
            new NativeAdvanceHelper().loadNativeSmall(mContext);
        }
        if (Constants.INSTANCE.getAppLovinAdsShow()) {
            new InterstitialAdHelper(mContext).onAppLovinAdLoad();
            new NativeAdvanceHelper().loadAppLovinNativeSmall(mContext);
            new NativeAdvanceHelper().loadAppLovinMedium(mContext);
            new NativeAdvanceHelper().loadApplovinNative(mContext);
        }

        openAdShow(onResponse, jsonObject);
    }

    public void openAdShow(onResponse responseApi, JSONObject response) {

        mOpenAdHelper = new OpenAdHelper();
        if (Constants.INSTANCE.getSPLASHADSHOW()) {
            if (Constants.INSTANCE.getSplashOpenAdShow()) {

                mOpenAdHelper.loadOpenAds(mContext, new OpenAdHelper.openAdListener() {
                    @Override
                    public void onAdClosed() {
                        responseApi.ApiResponse(response);
                    }

                    @Override
                    public void onAdFailedToLoad() {
                        responseApi.ApiResponse(response);
                    }

                    @Override
                    public void onAdLoaded(AppOpenAd appOpenAd) {
                        appOpenAd.show(mContext);
                    }
                });
            } else {
                new InterstitialAdHelper(mContext).onAdLoadForcefully(mContext, new InterstitialAdHelper.InterstitialAdListener() {
                    @Override
                    public void onAdLoaded() {
                    }

                    @Override
                    public void onAdFailedToLoad() {
                        responseApi.ApiResponse(response);
                    }

                    @Override
                    public void onAdClosed() {
                        responseApi.ApiResponse(response);
                    }
                });
            }
        } else {
            responseApi.ApiResponse(response);
        }
    }

    public interface onResponse {
        void ApiResponse(JSONObject response);
    }
}

