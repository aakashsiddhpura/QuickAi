import 'dart:ui';

import 'package:fl_app/controller/setiing_controller.dart';
import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/res/assets_path.dart';
import 'package:fl_app/utils/size_utils.dart';
import 'package:fl_app/widget/button.dart';
import 'package:fl_app/widget/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../InApp Purchase/constant.dart';
import '../../InApp Purchase/singletons_data.dart';
import '../Setting/custom_web_view.dart';

class PremiumScreen extends StatefulWidget {
  final Offering? offering;

  const PremiumScreen({Key? key, this.offering}) : super(key: key);

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  SettingController settingController = Get.put(SettingController());
  static List<PremiumPlanList> premiumList = [
    PremiumPlanList("chatpix_499_weekly", "Weekly", "4.99"),
    PremiumPlanList("chatpix_1799_monthly", "Monthly", "17.99", save: "10"),
    PremiumPlanList("chatpix_4999_quarterly", "Quarterly", "49.99", save: "16"),
    PremiumPlanList("chatpix_9999_yearly", "Yearly", "99.99", save: "58"),
  ];

  PremiumPlanList selectedPlan = premiumList[2];
  var selectedProduct;
  @override
  void initState() {
    if (widget.offering != null) {
      selectedProduct = widget.offering?.availablePackages[2];
    }
    setState(() {});
    super.initState();
  }

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
            widget.offering != null
                ? ListView.builder(
                    itemCount: widget.offering!.availablePackages.length,
                    itemBuilder: (BuildContext context, int index) {
                      var myProductList = widget.offering!.availablePackages;
                      return premiumListTile(
                          duration: premiumList[index].duration,
                          amount: myProductList[index].storeProduct.priceString,
                          save: premiumList[index].save,
                          isSelected: selectedPlan == premiumList[index],
                          onTap: () {
                            setState(() {
                              selectedPlan = premiumList[index];
                              selectedProduct = myProductList[index];
                            });
                          });
                    },
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                  )
                : Column(
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
              child: Center(
                  child: CustomButton(
                      onPressed: () async {
                        if (widget.offering != null) {
                          try {
                            CustomerInfo customerInfo = await Purchases.purchasePackage(selectedProduct);
                            EntitlementInfo? entitlement = customerInfo.entitlements.all[entitlementID];
                            appData.entitlementIsActive.value = entitlement?.isActive ?? false;
                          } on PlatformException catch (platformException) {
                            AppToast.toastMessage(platformException.message.toString());

                            print(platformException.message);
                          } catch (error) {
                            print(error);
                          }
                          // PlatformException(1, Purchase was cancelled., {code: 1, message: Purchase was cancelled., readableErrorCode: PurchaseCancelledError, readable_error_code: PurchaseCancelledError, underlyingErrorMessage: Error updating purchases. DebugMessage: . ErrorCode: USER_CANCELED., userCancelled: true}, null)
                          setState(() {});
                          Navigator.pop(context);
                        }
                      },
                      text: "Continue")),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    if (settingController.privacyPolicy != null) {
                      Get.to<dynamic>(CustomWebView(url: settingController.privacyPolicy, pageName: "Privacy Policy"));
                    }
                  },
                  child: Text(
                    "Privacy Policy",
                    style: TextStyle(color: AppColor.secondaryClr, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (settingController.termsAndCondition != null) {
                      Get.to<dynamic>(CustomWebView(url: settingController.termsAndCondition, pageName: "Privacy Policy"));
                    }
                  },
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Note : ",
                    style: TextStyle(color: AppColor.textColor, fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  Flexible(
                    child: Text(
                      "You can get 1 free message by viewing reward ad.",
                      style: TextStyle(color: AppColor.textColor.withOpacity(.7), fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  )
                ],
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
                            amount ?? "",
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
  final String? productId;
  final String? duration;
  final String? amount;
  final String? save;

  PremiumPlanList(this.productId, this.duration, this.amount, {this.save});
}
