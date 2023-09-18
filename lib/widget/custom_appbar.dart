import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../ads/call_ads.dart';
import '../res/app_colors.dart';
import '../res/assets_path.dart';
import '../utils/size_utils.dart';
import 'common_textstyle.dart';

PreferredSize customAppBar({Color? bgClr, required String? title, List<Widget>? action, bool? showLeading, void Function()? onLeadingTap, bool? centerTitle, int? leadingWith}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(SizeUtils.verticalBlockSize * 10),
    child: AppBar(
      backgroundColor: bgClr ?? AppColor.appBarClr,
      toolbarHeight: SizeUtils.verticalBlockSize * 10,
      title: Text(
        title ?? "",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: AppColor.white),
      ),
      centerTitle: centerTitle ?? false,
      // titleSpacing: SizeUtils.horizontalBlockSize * 5,
      actions: action ?? [],
      elevation: 0,
      // shadowColor: AppColor.greyText,
      leadingWidth: SizeUtils.horizontalBlockSize * (leadingWith ?? 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
      ),
      leading: showLeading == true
          ? Container(
              margin: EdgeInsets.only(left: 5),
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
                child: SvgPicture.asset(AssetsPath.backIC),
              ),
            )
          : const SizedBox(),
    ),
  );
}

PreferredSize appBarWithProfile({Color? bgClr, required String? title, required String? userName, List<Widget>? action, bool? showLeading, void Function()? onLeadingTap, bool? centerTitle, int? leadingWith}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(SizeUtils.verticalBlockSize * 8),
    child: AppBar(
      backgroundColor: bgClr ?? AppColor.appBarClr,
      toolbarHeight: SizeUtils.verticalBlockSize * 8,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColor.white),
          ),
          Text(
            "Hey,${userName ?? "John"}",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: AppColor.textColor70),
          ),
        ],
      ),
      centerTitle: centerTitle ?? false,
      // titleSpacing: SizeUtils.horizontalBlockSize * 5,
      actions: action ?? [],
      elevation: 0,
      // shadowColor: AppColor.greyText,
      leadingWidth: SizeUtils.horizontalBlockSize * 18,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
      ),
      leading: showLeading == true
          ? Container(
              margin: EdgeInsets.only(left: SizeUtils.horizontalBlockSize * 5),
              child: Image.asset(AssetsPath.profileAvatar),
            )
          : const SizedBox(),
    ),
  );
}
