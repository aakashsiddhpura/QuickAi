import 'package:ak_ads_plugin/ak_ads_plugin.dart';
import 'package:fl_app/InApp%20Purchase/singletons_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../res/app_colors.dart';
import '../utils/size_utils.dart';

class ExitPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
        child: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.backgroundColor,
              ),
              child: Container(
                color: AppColor.backgroundColor,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Are you sure you want to exit?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    SizedBox(
                      height: SizeUtils.verticalBlockSize * 1.5,
                    ),
                  if(appData.entitlementIsActive.value)  NativeAdView(),
                    SizedBox(
                      height: SizeUtils.verticalBlockSize * 1.5,
                    ),
                    Container(
                      width: SizeUtils.horizontalBlockSize * 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Ink(
                              child: Container(
                                height: SizeUtils.verticalBlockSize * 7,
                                width: SizeUtils.horizontalBlockSize * 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColor.imageBgClr),
                                child: Text(
                                  "No",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.of(context).pop(true);
                            },
                            child: Ink(
                              child: Container(
                                height: SizeUtils.verticalBlockSize * 7,
                                width: SizeUtils.horizontalBlockSize * 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColor.primaryClr),
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
