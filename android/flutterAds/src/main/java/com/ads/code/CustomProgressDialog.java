package com.ads.code;

import android.app.Activity;
import android.app.Dialog;
import android.graphics.PorterDuff;
import android.view.Gravity;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.widget.ImageView;

import androidx.core.content.ContextCompat;
import androidx.swiperefreshlayout.widget.CircularProgressDrawable;

public class CustomProgressDialog extends Dialog {

    private final Activity context;
    private CustomProgressDialog dialog;
    private ImageView progressImage;
    private CircularProgressDrawable circularProgressDrawable;
    private ImageView imgProgress;

//    TextView messageTxt;

    public CustomProgressDialog(Activity context, int theme) {
        super(context, theme);
        this.context = context;
    }

    public void onWindowFocusChanged(boolean hasFocus) {
        progressImage = (ImageView) findViewById(R.id.progress_bar);
        imgProgress = (ImageView) findViewById(R.id.img_progress);
//        messageTxt=findViewById(R.id.tv_progressmsg);
        circularProgressDrawable = new CircularProgressDrawable(context);
        circularProgressDrawable.setStrokeWidth(4f);
        circularProgressDrawable.setProgressRotation(1);
        circularProgressDrawable.setCenterRadius(32f);
        circularProgressDrawable.setColorFilter(ContextCompat.getColor(context, R.color.white), PorterDuff.Mode.SRC_IN);
        circularProgressDrawable.start();

        RotateAnimation rotate = new RotateAnimation(0, 360, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        rotate.setDuration(500);
        rotate.setRepeatCount(Animation.INFINITE);
        rotate.setInterpolator(new LinearInterpolator());


        progressImage.setImageDrawable(circularProgressDrawable);
        imgProgress.startAnimation(rotate);

        /*AnimationDrawable spinner = (AnimationDrawable) imageView.getBackground();
        spinner.start();*/
    }


//    public void setMessage(CharSequence message) {
//        if (message != null && message.length() > 0) {
//            messageTxt.setVisibility(View.VISIBLE);
//            messageTxt.setText(message);
//            messageTxt.invalidate();
//        }
//    }


    public void showDialog() {

        dialog = new CustomProgressDialog(context, R.style.progress_style);
        dialog.setTitle("");
        dialog.setContentView(R.layout.custom_progress_dialog);
        /*if(message == null || message.length() == 0) {
            dialog.findViewById(R.id.message).setVisibility(View.GONE);
        } else {
            TextView txt = (TextView)dialog.findViewById(R.id.message);
            txt.setText(message);
        }*/
        dialog.setCancelable(false);
        dialog.getWindow().getAttributes().gravity = Gravity.CENTER;
        WindowManager.LayoutParams lp = dialog.getWindow().getAttributes();
        lp.dimAmount = 0.2f;
        dialog.getWindow().setAttributes(lp);
        //dialog.getWindow().addFlags(WindowManager.LayoutParams.FLAG_BLUR_BEHIND);


        try {
            if (!dialog.isShowing()) {
                dialog.show();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void hideDialog() {
        if (dialog != null && dialog.isShowing()) {
            if (circularProgressDrawable != null) {
                circularProgressDrawable.stop();
            }
            try {
                dialog.dismiss();
            } catch (Exception e) {

            }

        }
    }
}