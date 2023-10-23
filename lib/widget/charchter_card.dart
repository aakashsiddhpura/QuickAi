import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/res/assets_path.dart';
import 'package:fl_app/utils/size_utils.dart';
import 'package:flutter/material.dart';

import '../Database/character_list_data.dart';
import '../InApp Purchase/singletons_data.dart';

class CharacterCard extends StatelessWidget {
  final CharacterModel character;
  final VoidCallback onTap;
  final bool isSelected;

  CharacterCard({required this.character, required this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.all(8),
        color: isSelected ? AppColor.primaryClr.withOpacity(0.3) : AppColor.buttonSelectionClr,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClipRRect(
                  child: Container(
                    width: SizeUtils.horizontalBlockSize * 15,
                    height: SizeUtils.horizontalBlockSize * 15,
                    decoration: BoxDecoration(
                        color: isSelected ? AppColor.secondaryClr.withOpacity(0.3) : AppColor.imageBgClr, borderRadius: BorderRadius.circular(1000)),
                    child: Image.asset(character.asset),
                  ),
                ),
                Text(
                  character.name,
                  style: TextStyle(color: AppColor.textColor70),
                ),
              ],
            ),
            if (character.lock && appData.entitlementIsActive.value == false)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0, right: 5),
                  child: Image.asset(
                    AssetsPath.lockIc,
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
