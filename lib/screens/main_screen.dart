import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/res/assets_path.dart';
import 'package:fl_app/screens/Character/character_screen.dart';
import 'package:fl_app/screens/Home/home_screen.dart';
import 'package:fl_app/screens/Image%20Generator/Image_generator.dart';
import 'package:fl_app/screens/Setting/setting_screen.dart';
import 'package:fl_app/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColor.appBarClr,
      systemNavigationBarColor: AppColor.bottomBarClr,
    ));
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      extendBody: true,
      bottomNavigationBar: CircleNavBar(
          activeIcons: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(AssetsPath.homeIC),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(AssetsPath.roboIC),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(AssetsPath.imageIC),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(AssetsPath.settingIC),
            ),
          ],
          inactiveIcons: [
            SvgPicture.asset(AssetsPath.homeIC, color: AppColor.textColor35),
            SvgPicture.asset(AssetsPath.roboIC, color: AppColor.textColor35),
            SvgPicture.asset(AssetsPath.imageIC, color: AppColor.textColor35),
            SvgPicture.asset(AssetsPath.settingIC, color: AppColor.textColor35),
          ],
          color: AppColor.bottomBarClr,
          height: SizeUtils.verticalBlockSize * 8,
          circleWidth: 55,
          activeIndex: tabIndex,
          onTap: (index) {
            tabIndex = index;
            pageController.jumpToPage(tabIndex);
          },
          cornerRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          shadowColor: Colors.transparent,
          elevation: 5,
          circleGradient: AppColor.primaryGradiant),
      body: PageView(
        controller: pageController,
        onPageChanged: (v) {
          tabIndex = v;
        },
        children: [HomeScreen(), CharacterScreen(), ImageGeneratorScreen(), SettingScreen()],
      ),
    );
  }
}
