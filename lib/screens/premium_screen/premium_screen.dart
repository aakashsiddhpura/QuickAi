import 'dart:ui';

import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/res/assets_path.dart';
import 'package:fl_app/utils/size_utils.dart';
import 'package:fl_app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  static List<PremiumPlanList> premiumList = [
    PremiumPlanList("Weekly", "4.99"),
    PremiumPlanList("Monthly", "17.99", save: "10"),
    PremiumPlanList("Quarterly", "49.99", save: "16"),
    PremiumPlanList("Yearly", "99.99", save: "58"),
  ];

  PremiumPlanList selectedPlan = premiumList[2];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: SizeUtils.verticalBlockSize * 5, horizontal: SizeUtils.horizontalBlockSize * 5),
        color: AppColor.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: SizeUtils.verticalBlockSize * 3,
                      left: SizeUtils.horizontalBlockSize * 10,
                      right: SizeUtils.horizontalBlockSize * 10,
                      bottom: SizeUtils.verticalBlockSize * 1),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColor.premiumImageBgClr.withOpacity(.2), borderRadius: BorderRadius.circular(1000)),
                  child: BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
                    child: Image.asset(
                      AssetsPath.premiumRoboImg,
                      width: SizeUtils.horizontalBlockSize * 60,
                      height: SizeUtils.horizontalBlockSize * 60,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Material(
                    color: Colors.transparent,
                    child: InkResponse(
                      onTap: Get.back,
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const Text(
              "Choose Your Plan!",
              style: TextStyle(color: AppColor.textColor, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 8,
            ),
            detailTile(
              firstText: "High Word Limit ",
              secondText: "for question & answers",
            ),
            detailTile(
              firstText: "Unlimited ",
              secondText: "for question & answers",
            ),
            detailTile(
              firstText: "Ads Free ",
              secondText: "experience",
            ),
            Column(
              children: premiumList.map((premiumData) {
                return premiumListTile(
                    duration: premiumData.duration,
                    amount: premiumData.amount,
                    save: premiumData.save,
                    isSelected: selectedPlan == premiumData,
                    onTap: () {
                      setState(() {
                        selectedPlan = premiumData;
                      });
                    });
              }).toList(),
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeUtils.verticalBlockSize * 3, bottom: SizeUtils.verticalBlockSize * 2),
              child: Center(child: CustomButton(onPressed: () {}, text: "Continue")),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {},
                  child: Text(
                    "Privacy Policy",
                    style: TextStyle(color: AppColor.secondaryClr, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    "Terms & Conditions",
                    style: TextStyle(color: AppColor.secondaryClr, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Subscription will be charged to your payment method through your google play belling account. your subscription will automatically renew unless canceled at least 24 hours before the end of current period. Mange your subscription in account setting after purchase.",
                style: TextStyle(color: AppColor.textColor.withOpacity(.5), fontWeight: FontWeight.w400, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget detailTile({String? firstText, String? secondText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Image.asset(
            AssetsPath.premiumLabelIc,
            width: 25,
            height: 25,
          ),
          const SizedBox(
            width: 10,
          ),
          RichText(
            text: TextSpan(
              text: firstText,
              style: const TextStyle(color: AppColor.premiumPrimaryCr, fontWeight: FontWeight.w500, fontSize: 16),
              children: [
                TextSpan(
                  text: secondText,
                  style: const TextStyle(color: AppColor.textColor70, fontWeight: FontWeight.w300, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget premiumListTile({String? duration, String? amount, String? save, bool? isSelected, required VoidCallback? onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          // height: SizeUtils.verticalBlockSize * 10,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.symmetric(vertical: SizeUtils.verticalBlockSize * 1),
          decoration: BoxDecoration(
            color: AppColor.premiumPrimaryCr.withOpacity(.09),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected == true ? AppColor.premiumPrimaryCr : Colors.transparent,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeUtils.horizontalBlockSize * 5, vertical: SizeUtils.horizontalBlockSize * 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        duration ?? "",
                        style: TextStyle(color: AppColor.textColor, fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "\$ ${amount ?? ""}",
                            style: TextStyle(color: AppColor.green, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (save != null)
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(color: AppColor.secondaryClr.withOpacity(.1), borderRadius: BorderRadius.circular(100)),
                              child: Text(
                                "SAVE $save%",
                                style: TextStyle(color: AppColor.secondaryClr, fontWeight: FontWeight.w700, fontSize: 10),
                              ),
                            )
                        ],
                      )
                    ],
                  ),
                ),
                if (isSelected == true)
                  Container(
                    height: SizeUtils.verticalBlockSize * 10,
                    width: SizeUtils.horizontalBlockSize * 15,
                    padding: EdgeInsets.all(SizeUtils.horizontalBlockSize * 4),
                    decoration: const BoxDecoration(
                      color: AppColor.premiumPrimaryCr,
                    ),
                    child: SvgPicture.asset(AssetsPath.doneIc),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumPlanList {
  final String duration;
  final String amount;
  final String? save;

  PremiumPlanList(this.duration, this.amount, {this.save});
}
