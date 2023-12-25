import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_app/ads/rewarded_ad.dart';
import 'package:fl_app/controller/home_controller.dart';
import 'package:fl_app/controller/premium_controller.dart';
import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/utils/navigation_utils/navigation.dart';
import 'package:fl_app/utils/navigation_utils/routes.dart';
import 'package:fl_app/utils/size_utils.dart';
import 'package:fl_app/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../ads/banner_view.dart';
import '../../controller/analytics_controller.dart';
import '../../controller/auth_controller.dart';
import '../../widget/loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthController authController = Get.put(AuthController());
  HomeController homeController = Get.put(HomeController());
  PremiumController premiumController = Get.put(PremiumController());
  RewardedAdController reward = Get.put(RewardedAdController());
  @override
  void initState() {
    // TODO: implement initState
    AnalyticsService().setCurrentScreen(screenName: "HomeScreen");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithProfile(title: "Welcome to ChatPix AI", userName: authController.user.value.displayName, showLeading: true, action: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ValueListenableBuilder(
            //TODO 2nd: listen playerPointsToAdd
            valueListenable: notificationRewardCollected,
            builder: (BuildContext context, bool value, Widget? child) {
              return InkWell(
                onTap: () {
                  premiumController.rewardAdDialog(onPressed: () async {
                    Get.back();
                    await reward.showRewardAd().then((value) {
                      notificationRewardCollected.addListener(() {
                        AnalyticsService().logEvent("Reward Ad View", null);

                        if (notificationRewardCollected.value == true) {
                          premiumController.incrementCount();
                        }
                      });
                    });
                  });
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.slow_motion_video_rounded,
                      color: AppColor.secondaryClr,
                    ),
                    Text(
                      "Reward Ads",
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
              );
            },
          ),
        )
      ]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('ai assistant category').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return MyLoader();
              }

              List<CategoryModel> models = [];
              var data = snapshot.data!.docs[1].data() as Map<String, dynamic>;

              for (var doc in data["category_list"]) {
                var model = CategoryModel(
                  title: doc['title'],
                  image: doc['image'],
                  questionList: List<String>.from(doc['question_list']),
                );
                models.add(model);
              }

              return GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: SizeUtils.horizontalBlockSize * 4),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16.0, mainAxisSpacing: 16.0),
                itemCount: models.length,
                itemBuilder: (context, index) {
                  return InkResponse(
                    radius: 15,
                    onTap: () {
                      if (index == 0) {
                        Navigation.pushNamed(Routes.kAiCodeGenerator, arg: models[index]);
                      } else {
                        Navigation.pushNamed(Routes.kInputSuggestionScreen, arg: models[index]);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: SizeUtils.horizontalBlockSize * 4, vertical: SizeUtils.horizontalBlockSize * 3),
                      decoration: BoxDecoration(color: AppColor.buttonSelectionClr, borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 10),
                              alignment: Alignment.topCenter,
                              child: CachedNetworkImage(
                                imageUrl: models[index].image,
                                width: SizeUtils.horizontalBlockSize * 25,
                                progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(color: AppColor.primaryClr, value: downloadProgress.progress)),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                models[index].title,
                                style: const TextStyle(color: AppColor.textColor, fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                color: AppColor.primaryClr,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          BannerView(),
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeUtils.horizontalBlockSize * 4, vertical: SizeUtils.verticalBlockSize * 1.2),
                  child: const Text(
                    "Your ChatPix Assistants",
                    style: TextStyle(color: AppColor.textColor, fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('ai assistant category').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return MyLoader();
                      }

                      List<CategoryModel> models = [];
                      var data = snapshot.data!.docs[0].data() as Map<String, dynamic>;

                      for (var doc in data["category_list"]) {
                        var model = CategoryModel(
                          title: doc['title'],
                          image: doc['image'],
                          questionList: List<String>.from(doc['question_list']),
                        );
                        models.add(model);
                      }

                      return GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: SizeUtils.horizontalBlockSize * 4),
                        scrollDirection: Axis.vertical,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 16.0, // Adjust spacing between items
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 0.7),
                        shrinkWrap: true,
                        itemCount: models.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigation.pushNamed(Routes.kInputSuggestionScreen, arg: models[index]);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: SizeUtils.horizontalBlockSize * 18,
                                  height: SizeUtils.horizontalBlockSize * 18,
                                  alignment: Alignment.topCenter,
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(color: AppColor.imageBgClr, borderRadius: BorderRadius.circular(100)),
                                  child: CachedNetworkImage(
                                    imageUrl: models[index].image,
                                    placeholder: (context, url) => CircularProgressIndicator(
                                      color: AppColor.primaryClr,
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                ),
                                Text(
                                  models[index].title,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: const TextStyle(color: AppColor.textColor70, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w400, fontSize: 12),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: SizeUtils.verticalBlockSize * 9,
      ),
    );
  }
}
