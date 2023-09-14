package com.ads.code;

import android.app.Activity;
import android.os.RemoteException;
import android.util.Log;

import com.android.installreferrer.api.InstallReferrerClient;
import com.android.installreferrer.api.InstallReferrerStateListener;
import com.android.installreferrer.api.ReferrerDetails;

import org.json.JSONException;

import java.util.Locale;

public class CheckReferrelApi {
    InstallReferrerClient referrerClient;

    public void checkReferrel(Activity mContext,CompleteProcess completeProcess){
        referrerClient = InstallReferrerClient.newBuilder(mContext).build();
        referrerClient.startConnection(new InstallReferrerStateListener() {
            @Override
            public void onInstallReferrerSetupFinished(int responseCode) {
                // this method is called when install referrer setup is finished.
                switch (responseCode) {
                    case InstallReferrerClient.InstallReferrerResponse.OK:
                        ReferrerDetails response = null;
                        try {
                            response = referrerClient.getInstallReferrer();
                            String referrerUrl = response.getInstallReferrer();
                            Log.e("TAG", "Complete: "+referrerUrl );
                            if (!checkReferrel(referrerUrl)) {
                                completeProcess.Complete(true);
                            } else {
                                completeProcess.Complete(false);
                            }
                        } catch (RemoteException e) {
                            completeProcess.Complete(false);
                            e.printStackTrace();
                        }
                        break;
                    case InstallReferrerClient.InstallReferrerResponse.FEATURE_NOT_SUPPORTED:
                        completeProcess.Complete(false);
                        break;
                    case InstallReferrerClient.InstallReferrerResponse.SERVICE_UNAVAILABLE:
                        completeProcess.Complete(false);
                        break;

                }
            }

            @Override
            public void onInstallReferrerServiceDisconnected() {

                referrerClient.startConnection(new InstallReferrerStateListener() {
                    @Override
                    public void onInstallReferrerSetupFinished(int responseCode) {
                        switch (responseCode) {
                            case InstallReferrerClient.InstallReferrerResponse.OK:
                                ReferrerDetails response = null;
                                try {
                                    response = referrerClient.getInstallReferrer();
                                    String referrerUrl = response.getInstallReferrer();
                                    if (!checkReferrel(referrerUrl)) {
                                        completeProcess.Complete(true);
                                    } else {
                                        completeProcess.Complete(false);
                                    }
                                } catch (RemoteException e) {
                                    completeProcess.Complete(false);
                                    e.printStackTrace();
                                }
                                break;
                            case InstallReferrerClient.InstallReferrerResponse.FEATURE_NOT_SUPPORTED:
                                completeProcess.Complete(false);
                                break;
                            case InstallReferrerClient.InstallReferrerResponse.SERVICE_UNAVAILABLE:
                                completeProcess.Complete(false);
                                break;

                        }

                    }

                    @Override
                    public void onInstallReferrerServiceDisconnected() {

                    }
                });
            }
        });
    }
    public boolean checkReferrel(String str){
        try {
            for (int i = 0; i < Constants.INSTANCE.getTrackUrl().length(); i++) {
                if (str.toLowerCase(Locale.getDefault()).contains(Constants.INSTANCE.getTrackUrl().get(i).toString().toLowerCase(Locale.getDefault()))) {
                    if (Constants.INSTANCE.getMatchTrackUrl()) {
                        return true;
                    }else {
                        return false;
                    }
                }
            }
        }catch (JSONException e){
            return false;
        }
        if (Constants.INSTANCE.getMatchTrackUrl()) {
            return false;
        }else {
            return true;
        }
    }
    public interface CompleteProcess {
        void Complete(boolean refrrelResult);
    }
}
