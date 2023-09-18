import 'package:fl_app/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../my_home.dart';
import '../res/app_colors.dart';

class Loader {
  static sw() {
    return navigatorKey.currentContext!.loaderOverlay.show(widget: MyLoader());
  }

  static hd() {
    return navigatorKey.currentContext!.loaderOverlay.hide();
  }
}

class MyLoader extends StatelessWidget {
  EdgeInsetsGeometry? margin;
  MyLoader({this.margin});
  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        margin: margin ?? EdgeInsets.all(SizeUtils.horizontalBlockSize * 40),
        child: LoadingAnimationWidget.discreteCircle(
          color: AppColor.white,
          secondRingColor: AppColor.secondaryClr,
          thirdRingColor: AppColor.primaryClr,
          size: 50,
        ),
      );
}
