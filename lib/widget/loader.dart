import 'package:fl_app/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

import '../my_home.dart';
import '../res/app_colors.dart';
import '../res/assets_path.dart';

class Loader {
  static sw({bool? imageLoader}) {
    return navigatorKey.currentContext!.loaderOverlay.show(widget: MyLoader(imageLoader: imageLoader));
  }

  static hd() {
    return navigatorKey.currentContext!.loaderOverlay.hide();
  }
}

class MyLoader extends StatelessWidget {
  EdgeInsetsGeometry? margin;
  bool? imageLoader;
  MyLoader({this.margin, this.imageLoader});
  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        margin: margin ?? EdgeInsets.all(imageLoader == true ? SizeUtils.horizontalBlockSize * 30 : SizeUtils.horizontalBlockSize * 40),
        child: imageLoader == true
            ? Lottie.asset(AssetsPath.imageLoader)
            : LoadingAnimationWidget.discreteCircle(
                color: AppColor.white,
                secondRingColor: AppColor.secondaryClr,
                thirdRingColor: AppColor.primaryClr,
                size: 50,
              ),
      );
}
