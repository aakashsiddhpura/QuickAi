package com.example.fl_app;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

class MediumNativeViewFactory extends PlatformViewFactory {

    private final Activity activity;

    MediumNativeViewFactory(Activity activity) {
        super(StandardMessageCodec.INSTANCE);
        this.activity = activity;
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int id, @Nullable Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;
        return new MediumNativeView(context, activity, id, creationParams);
    }
}
class BigNativeViewFactory extends PlatformViewFactory {

    private final Activity activity;

    BigNativeViewFactory(Activity activity) {
        super(StandardMessageCodec.INSTANCE);
        this.activity = activity;
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int id, @Nullable Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;
        return new BigNativeView(context, activity, id, creationParams);
    }
}

class BannerViewFactory extends PlatformViewFactory {

    private final Activity activity;

    BannerViewFactory(Activity activity) {
        super(StandardMessageCodec.INSTANCE);
        this.activity = activity;
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int id, @Nullable Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;
        return new BannerView(context, activity, id, creationParams);
    }
}