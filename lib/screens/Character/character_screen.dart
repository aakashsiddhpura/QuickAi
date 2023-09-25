import 'package:fl_app/controller/premium_controller.dart';
import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/utils/navigation_utils/navigation.dart';
import 'package:fl_app/utils/navigation_utils/routes.dart';
import 'package:fl_app/widget/custom_appbar.dart';
import 'package:fl_app/screens/premium_screen/subscribe_now_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../Database/character_list_data.dart';
import '../../ads/rewarded_ad.dart';
import '../../main.dart';
import '../../utils/size_utils.dart';
import '../../widget/button.dart';
import '../../widget/charchter_card.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  RewardedAdController reward = Get.put(RewardedAdController());

  List<CharacterModel> characterList = [];
  int selectedIndex = 0;
  final box = GetStorage();

  Future<void> updateCharacterLock(int index, bool isLocked) async {
    characterList[index].lock = isLocked;
    await box.write('characters', characterList);
  }

  @override
  void initState() {
    characterList = CharacterDB().readCharacterListData();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Select Character", leadingWith: 0),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // You can adjust the number of columns here
              ),
              itemCount: characterList.length,
              itemBuilder: (context, index) {
                final character = characterList[index];
                return CharacterCard(
                  isSelected: selectedIndex == index,
                  character: character,
                  onTap: () {
                    if (characterList[index].lock) {
                      Get.defaultDialog(
                        title: "Watch Video to unlock character",
                        titlePadding: EdgeInsets.all(10),
                        content: SizedBox(),
                        confirm: ValueListenableBuilder(
                            //TODO 2nd: listen playerPointsToAdd
                            valueListenable: notificationRewardCollected,
                            builder: (BuildContext context, bool value, Widget? child) {
                              return CustomButton(
                                  width: SizeUtils.horizontalBlockSize * 35,
                                  height: SizeUtils.horizontalBlockSize * 12,
                                  onPressed: () async {
                                    Get.back();
                                    await reward.showRewardAd().then((value) {
                                      notificationRewardCollected.addListener(() {
                                        if (notificationRewardCollected.value == true) {
                                          updateCharacterLock(index, false);
                                        }
                                      });
                                    });
                                  },
                                  text: "YES");
                            }),
                        cancel: CustomButton(
                            width: SizeUtils.horizontalBlockSize * 35,
                            buttonColor: AppColor.inActiveButton,
                            height: SizeUtils.horizontalBlockSize * 12,
                            onPressed: Get.back,
                            text: "NO"),
                      );
                    } else {
                      selectedIndex = index;
                      setState(() {});
                    }
                  },
                );
              },
            ),
          ),
          CustomButton(
              onPressed: () {
                Navigation.pushNamed(Routes.kCharacterChatScreen, arg: characterList[selectedIndex]);
              },
              text: "Start Chat"),
          SubscribeNowText(
            screenType: FreeCount.characterFreeCount,
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: SizeUtils.verticalBlockSize * 9,
      ),
    );
  }
}
