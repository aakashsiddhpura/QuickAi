import 'dart:convert';

import 'package:fl_app/res/assets_path.dart';
import 'package:get_storage/get_storage.dart';

import '../main.dart';

class CharacterModel {
  final String asset;
  final String name;
  bool lock;

  CharacterModel({
    required this.asset,
    required this.name,
    required this.lock,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      asset: json['asset'],
      name: json['name'],
      lock: json['lock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asset': asset,
      'name': name,
      'lock': lock,
    };
  }
}

List<CharacterModel> characterList = [];

class CharacterDB {
  Future<void> initializeGetStorage() async {
    final characterListData = box.read('characters');
    if (characterListData == null) {
      // Initialize with default data if it's the first run
      characterList = [
        CharacterModel(asset: AssetsPath.laughterIC, name: 'Laughter', lock: false),
        CharacterModel(asset: AssetsPath.funnyIc, name: 'Funny', lock: true),
        CharacterModel(asset: AssetsPath.tigerCubIc, name: 'Tiger Cub', lock: true),
        CharacterModel(asset: AssetsPath.puppyIc, name: 'Puppy', lock: true),
        CharacterModel(asset: AssetsPath.toucanIc, name: 'Toucan', lock: true),
        CharacterModel(asset: AssetsPath.sheepIc, name: 'Sheep', lock: true),
        CharacterModel(asset: AssetsPath.sleepyCatIc, name: 'Sleepy Cat', lock: true),
        CharacterModel(asset: AssetsPath.gechoIc, name: 'Gecho', lock: true),
        CharacterModel(asset: AssetsPath.walkingBirdIc, name: 'Walking Bird', lock: true),
        CharacterModel(asset: AssetsPath.owlIc, name: 'Owl', lock: true),
      ];
      await box.write('characters', jsonEncode(characterList));
    } else {
      readCharacterListData();
    }
  }

  List<CharacterModel> readCharacterListData() {
    final decodeData = box.read('characters');
    final List<Map<String, dynamic>>? characterListData = jsonDecode(decodeData).cast<Map<String, dynamic>>().toList();

    if (characterListData != null) {
      characterList = characterListData.map((data) {
        return CharacterModel(
          asset: data["asset"],
          name: data["name"],
          lock: data["lock"],
        );
      }).toList();
      return characterList;
    }
    return characterList;
  }
}
