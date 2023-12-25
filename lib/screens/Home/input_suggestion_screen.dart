import 'package:ak_ads_plugin/ak_ads_plugin.dart';
import 'package:fl_app/ads/banner_view.dart';
import 'package:fl_app/ads/call_ads.dart';
import 'package:fl_app/controller/premium_controller.dart';
import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/res/assets_path.dart';
import 'package:fl_app/utils/navigation_utils/navigation.dart';
import 'package:fl_app/utils/navigation_utils/routes.dart';
import 'package:fl_app/utils/size_utils.dart';
import 'package:fl_app/widget/custom_appbar.dart';
import 'package:fl_app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../InApp Purchase/singletons_data.dart';
import '../../controller/analytics_controller.dart';
import '../../controller/home_controller.dart';
import '../../widget/button.dart';
import '../premium_screen/subscribe_now_widget.dart';

class InputSuggestionScreen extends StatefulWidget {
  const InputSuggestionScreen({super.key});

  @override
  State<InputSuggestionScreen> createState() => _InputSuggestionScreenState();
}

class _InputSuggestionScreenState extends State<InputSuggestionScreen> {
  CategoryModel? categoryData;
  HomeController homeController = Get.put(HomeController());
  PremiumController premiumController = Get.put(PremiumController());

  @override
  void initState() {
    setState(() {
      categoryData = Get.arguments;
    });
    AnalyticsService().logEvent("InputSuggestionScreen", {"selected_category": categoryData!.title});

    super.initState();
  }

  @override
  void dispose() {
    homeController.inputC.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: categoryData!.title,
        showLeading: true,
        action: [
          IconButton(
            onPressed: () {
              Navigation.pushNamed(Routes.kHistoryScreen);
            },
            icon: SvgPicture.asset(AssetsPath.historyIc),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeUtils.horizontalBlockSize * 3, vertical: SizeUtils.verticalBlockSize * 1),
        child: Column(
          children: [
            CustomTextField(
              controller: homeController.inputC,
              hintText: "How can I help you?",
              textInputAction: TextInputAction.done,
              fillColor: Colors.transparent,
            ),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: SizeUtils.verticalBlockSize * 1),
                  itemCount: categoryData!.questionList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        if (appData.entitlementIsActive.value) {
                          Navigation.replace(
                            Routes.kCategoryChatScreen,
                            arguments: {
                              "categoryData": categoryData,
                              "inputText": categoryData!.questionList[index],
                            },
                          );
                        } else if (premiumController.assistantFreeCount.value <= 0) {
                          premiumController.openPremiumDialog();
                        } else {
                          premiumController.useCount(useType: FreeCount.assistantFreeCount);
                          homeController.inputText.value = categoryData!.questionList[index];
                          homeController.update();
                          await AkAdsPlugin().callInterstitialAds();
                          Navigation.replace(
                            Routes.kCategoryChatScreen,
                            arguments: {
                              "categoryData": categoryData,
                              "inputText": categoryData!.questionList[index],
                            },
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(color: AppColor.aiAnsBgClr, borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          categoryData!.questionList[index],
                          style: const TextStyle(color: AppColor.aiAnsTextClr, fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
      bottomNavigationBar: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Obx(() {
              return CustomButton(
                onPressed: homeController.inputText.value.isNotEmpty
                    ? () {
                        if (appData.entitlementIsActive.value) {
                          Navigation.replace(
                            Routes.kCategoryChatScreen,
                            arguments: {
                              "categoryData": categoryData,
                              "inputText": homeController.inputText.value,
                            },
                          );
                        } else if (premiumController.assistantFreeCount.value <= 0) {
                          premiumController.openPremiumDialog();
                        } else {
                          premiumController.useCount(useType: FreeCount.assistantFreeCount);
                          Navigation.replace(
                            Routes.kCategoryChatScreen,
                            arguments: {
                              "categoryData": categoryData,
                              "inputText": homeController.inputText.value,
                            },
                          );
                        }
                      }
                    : null,
                text: "Send",
                buttonColor: homeController.inputText.value.isEmpty ? AppColor.inActiveButton : null,
                textColor: homeController.inputText.value.isEmpty ? AppColor.textColor35 : null,
              );
            }),
            SubscribeNowText(screenType: FreeCount.assistantFreeCount),
            BannerAdView()
          ],
        ),
      ),
    );
  }
}
