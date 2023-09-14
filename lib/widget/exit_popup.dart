import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ads/native_ad_with_size.dart';
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                    SizedBox(
                      height: SizeUtils.verticalBlockSize * 1.5,
                    ),
                    NativeAd(),
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
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red),
                                child: Text(
                                  "No",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
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
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green),
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
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
