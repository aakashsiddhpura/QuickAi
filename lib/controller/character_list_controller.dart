import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Database/character_list_data.dart';
import '../ads/rewarded_ad.dart';

class CharacterListController extends GetxController {
  RewardedAdController reward = Get.put(RewardedAdController());

  RxList<CharacterModel> characterList = <CharacterModel>[].obs;
  RxInt selectedIndex = 0.obs;
  final box = GetStorage();

  Future<void> updateCharacterLock(int index, bool isLocked) async {
    characterList[index].lock = isLocked;
    await box.write('characters',  jsonEncode(characterList));
    update();
  }

  @override
  void onInit() {
    characterList.value = CharacterDB().readCharacterListData();
    update();
    super.onInit();
  }
}
