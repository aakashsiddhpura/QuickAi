import 'package:fl_app/screens/premium_screen/premium_screen.dart';
import 'package:fl_app/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../InApp Purchase/singletons_data.dart';
import '../../controller/premium_controller.dart';
import '../../res/app_colors.dart';

import 'package:get_storage/get_storage.dart';

class SubscribeNowText extends StatelessWidget {
  final FreeCount? screenType;

  SubscribeNowText({super.key, required this.screenType});

  PremiumController premiumController = Get.put(PremiumController());

  @override
  Widget build(BuildContext context) {
    return appData.entitlementIsActive.value == false
        ? Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  return Text(
                    "You have ${screenType == FreeCount.assistantFreeCount ? premiumController.assistantFreeCount.value : screenType == FreeCount.characterFreeCount ? premiumController.characterFreeCount.value : screenType == FreeCount.imageFreeCount ? premiumController.imageFreeCount.value : 0} free ${screenType == FreeCount.imageFreeCount ? "image" : "messages"} left",
                    style: const TextStyle(fontSize: 16, color: AppColor.textColor35, fontWeight: FontWeight.w400),
                  );
                }),
                TextButton(

                  onPressed: () {
                    premiumController.openPremiumDialog();
                  },
                  child: const Text(
                    "Subscribe Now",
                    style: TextStyle(color: AppColor.secondaryClr, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          )
        : SizedBox(height: SizeUtils.verticalBlockSize * 2,);
  }
}
