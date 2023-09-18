import 'package:fl_app/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../Database/character_list_data.dart';
import '../../main.dart';
import '../../widget/charchter_card.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
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
      body: GridView.builder(
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
              selectedIndex = index;

              // Example: Toggle the lock status when a character is tapped
              updateCharacterLock(index, !character.lock);
              setState(() {});
            },
          );
        },
      ),
    );
  }
}
