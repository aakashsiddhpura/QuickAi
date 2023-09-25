import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../res/app_colors.dart';
import '../utils/size_utils.dart';
import 'button.dart';

void settingBottomSheet({required String title, required String description, required void Function()? onTapYes}) {
  Get.bottomSheet(
    SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: SizeUtils.horizontalBlockSize * 6, vertical: SizeUtils.verticalBlockSize * 2.5),
        decoration: BoxDecoration(color: AppColor.buttonSelectionClr, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: AppColor.textColor, fontWeight: FontWeight.w600, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              description,
              style: TextStyle(color: AppColor.textColor.withOpacity(.5), fontWeight: FontWeight.w400, fontSize: 18),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                CustomButton(
                  onPressed: onTapYes,
                  text: "Yes",
                  width: SizeUtils.horizontalBlockSize * 27,
                  height: SizeUtils.horizontalBlockSize * 13,
                  buttonColor: Colors.redAccent,
                ),
                const SizedBox(
                  width: 15,
                ),
                CustomButton(
                  onPressed: Get.back,
                  text: "No",
                  width: SizeUtils.horizontalBlockSize * 27,
                  height: SizeUtils.horizontalBlockSize * 13,
                  buttonColor: Colors.grey,
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
