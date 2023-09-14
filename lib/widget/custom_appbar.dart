import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ads/call_ads.dart';
import '../res/app_colors.dart';
import '../res/assets_path.dart';
import '../utils/size_utils.dart';
import 'common_textstyle.dart';

PreferredSize customAppBar({Color? bgClr, required String? title, List<Widget>? action, bool? showLeading, void Function()? onLeadingTap}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(SizeUtils.verticalBlockSize * 8),
    child: AppBar(
      backgroundColor: bgClr ?? AppColor.white,
      toolbarHeight: SizeUtils.verticalBlockSize * 8,
      title: Text(
        title ?? "",
        style: CommonTextStyle.titleStyle,
      ),
      // centerTitle: true,
      // titleSpacing: SizeUtils.horizontalBlockSize * 5,
      actions: action ?? [],
      elevation: 0,
      // shadowColor: AppColor.greyText,
      // leadingWidth: SizeUtils.horizontalBlockSize * 12,
      leading: showLeading == true
          ? Padding(
              padding: EdgeInsets.only(left: SizeUtils.horizontalBlockSize * 4),
              child: InkResponse(
                radius: 18,
                onTap: onLeadingTap ??
                    () {
                      if (adsModel.adsShow == true) {
                        if (adsModel.backAdsShow == true) {
                          // if (CallAds().adsModel.showCustomAd == true) {
                          //   CustomInter().showInter();
                          // } else {
                          CallAds().callBackAds().then((value) {
                            Get.back();
                          });
                          // }
                        }
                      } else {
                        Get.back();
                      }
                    },
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeUtils.horizontalBlockSize * 2.8, vertical: SizeUtils.verticalBlockSize * 2.8),
                    child: Icon(Icons.arrow_back_ios)),
                // Image.asset(
                //   AssetsPath.backIc,
                // ),
              ),
            )
          : const SizedBox(),
    ),
  );
}
