import 'package:ak_ads_plugin/ak_ads_plugin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_app/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controller/analytics_controller.dart';
import '../../controller/auth_controller.dart';
import '../../controller/home_controller.dart';
import '../../res/app_colors.dart';
import '../../res/assets_path.dart';
import '../../utils/size_utils.dart';
import '../../widget/loader.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  AuthController authController = Get.put(AuthController());
  HomeController homeController = Get.put(HomeController());
  @override
  void initState() {
    // TODO: implement initState
    AnalyticsService().setCurrentScreen(screenName: "HistoryScreen");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "History", showLeading: true, centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (authController.user.value.uid.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeUtils.horizontalBlockSize * 4, vertical: SizeUtils.verticalBlockSize * 1),
              child: const Text(
                "Recently Prompt",
                style: TextStyle(color: AppColor.textColor, fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
          if (authController.user.value.uid.isNotEmpty)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('user_prompt_history').doc(authController.user.value.uid).collection('answers_and_questions').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return MyLoader();
                    }

                    List<HistoryModel> historyList = [];
                    historyList = snapshot.data!.docs.map((doc) {
                      final question = doc['question'] as String? ?? ""; // Handle null with '?'
                      final answer = doc['answer'] as String? ?? ""; // Handle null with '?'
                      return HistoryModel(
                        question: question,
                        answer: answer,
                      );
                    }).toList();

                    return historyList.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: SizeUtils.horizontalBlockSize * 4),
                            itemCount: historyList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final data = historyList[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: SizeUtils.verticalBlockSize * 1),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(horizontal: SizeUtils.horizontalBlockSize * 4, vertical: SizeUtils.horizontalBlockSize * 3),
                                        decoration: BoxDecoration(color: AppColor.aiAnsBgClr),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              data.question,
                                              style: TextStyle(color: AppColor.aiAnsTextClr, fontWeight: FontWeight.w400, fontSize: 16),
                                            ),
                                            Material(
                                              color: Colors.transparent,
                                              child: InkResponse(
                                                  onTap: () async {
                                                    Loader.sw();
                                                    await FirebaseFirestore.instance
                                                        .collection("user_prompt_history")
                                                        .doc(authController.user.value.uid)
                                                        .collection("answers_and_questions")
                                                        .doc(snapshot.data!.docs[index].reference.id.toString())
                                                        .delete();
                                                    Loader.hd();
                                                    Get.snackbar("Delete Item", "History delete successfully", colorText: Colors.white);
                                                    setState(() {});
                                                  },
                                                  radius: 20,
                                                  child: SvgPicture.asset(
                                                    AssetsPath.deleteIc,
                                                    width: 15,
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(horizontal: SizeUtils.horizontalBlockSize * 4, vertical: SizeUtils.horizontalBlockSize * 3),
                                        decoration: BoxDecoration(color: AppColor.buttonSelectionClr),
                                        child: Text(
                                          data.answer,
                                          style: TextStyle(color: AppColor.textColor70, fontWeight: FontWeight.w400, fontSize: 15),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              "No History Data",
                              style: TextStyle(color: AppColor.textColor, fontWeight: FontWeight.w700, fontSize: 26),
                            ),
                          );
                  }),
            ),
        ],
      ),
      // bottomNavigationBar: NativeAdView(adSize: "medium"),
    );
  }
}
