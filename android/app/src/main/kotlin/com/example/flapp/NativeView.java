package com.example.fl_app;

import android.app.Activity;
import android.content.Context;
import android.view.View;
import android.widget.FrameLayout;

import com.ads.code.NativeAdvanceHelper;

import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

class MediumNativeView implements PlatformView {
    private final FrameLayout frameLayout;

    MediumNativeView(Context context,Activity activity, int id, Map<String, Object> creationParams) {
        frameLayout = new FrameLayout(context);
        new NativeAdvanceHelper().showNative(activity, null, 4,null,View.GONE,frameLayout,View.GONE,null,View.GONE);
    }

    @Override
    public View getView() {
        return frameLayout;
    }

    @Override
    public void dispose() {}
}

class BigNativeView implements PlatformView {
    private final FrameLayout frameLayout;

    BigNativeView(Context context,Activity activity, int id, Map<String, Object> creationParams) {
        frameLayout = new FrameLayout(context);
        new NativeAdvanceHelper().showNative(activity, null, 4,null,View.GONE,null,View.GONE,frameLayout,View.GONE);
    }

    @Override
    public View getView() {
        return frameLayout;
    }

    @Override
    public void dispose() {}
}

class BannerView implements PlatformView {
    private final FrameLayout frameLayout;

    BannerView(Context context,Activity activity, int id, Map<String, Object> creationParams) {
        frameLayout = new FrameLayout(context);
        new NativeAdvanceHelper().showNative(activity, null, 4,frameLayout,View.GONE,null,View.GONE,null,View.GONE);
    }

    @Override
    public View getView() {
        return frameLayout;
    }

    @Override
    public void dispose() {}
}
