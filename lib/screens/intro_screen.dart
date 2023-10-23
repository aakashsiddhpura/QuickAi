import 'package:dots_indicator/dots_indicator.dart';
import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/res/assets_path.dart';
import 'package:fl_app/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../controller/analytics_controller.dart';
import '../controller/auth_controller.dart';
import '../utils/navigation_utils/navigation.dart';
import '../utils/navigation_utils/routes.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final AuthController authController = Get.put(AuthController());

  final PageController _pageController = PageController();
  StreamController<int> _currentPageStreamController = StreamController<int>();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageViewScroll);
    _currentPageStreamController.add(_pageController.initialPage);
  }

  void _onPageViewScroll() {
    _currentPageStreamController.add(_pageController.page!.toInt());
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageViewScroll);
    _pageController.dispose();
    _currentPageStreamController.close();
    super.dispose();
  }

  List<IntroDataModel> introList = [
    IntroDataModel(
        title: "Your AI assistant",
        description: "ChatPix AI is intended to boost your productivity by quick access to information.",
        image: AssetsPath.intro1Img),
    IntroDataModel(
        title: "Human-like Conversations",
        description: "ChatPix AI understand and response to your message in a natural way.",
        image: AssetsPath.intro2Img),
    IntroDataModel(title: "I can do anything", description: "I can write your essays, emails, codes, text and more.", image: AssetsPath.intro3Img),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeUtils.screenHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColor.backgroundColor,
        image: DecorationImage(
            image: AssetImage(
              AssetsPath.introBg,
            ),
            fit: BoxFit.cover),
      ),
      child: Column(
        children: [
          SizedBox(
            height: SizeUtils.verticalBlockSize * 75,
            child: PageView(
              controller: _pageController,
              children: List<Widget>.generate(introList.length, (int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeUtils.horizontalBlockSize * 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image(
                        width: SizeUtils.horizontalBlockSize * 80,
                        height: SizeUtils.horizontalBlockSize * 80,
                        image: AssetImage(introList[index].image),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: SizeUtils.verticalBlockSize * 5, bottom: SizeUtils.verticalBlockSize * 2),
                        child: Text(
                          introList[index].title,
                          style: const TextStyle(color: AppColor.white, fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        introList[index].description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColor.textColor70,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeUtils.verticalBlockSize * 3),
            child: StreamBuilder<int>(
              stream: _currentPageStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _currentPage = snapshot.data!;
                }
                return DotsIndicator(
                  dotsCount: introList.length,
                  position: _currentPage,
                  decorator: DotsDecorator(
                    spacing: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                    activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    color: Colors.grey, // Inactive dot color
                    activeColor: Colors.white, // Active dot color
                    size: const Size(8.0, 8.0), // Dot size
                    activeSize: const Size(25, 8), // Active dot size
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeUtils.verticalBlockSize * 8),
            child: TextButton(
              onPressed: () {
                if (authController.user.value.uid.isEmpty) {
                  Navigation.replaceAll(Routes.kLoginScreen);
                } else {
                  Navigation.replaceAll(Routes.kMainScreen);
                }
              },
              child: Text(
                "SKIP",
                style: TextStyle(color: AppColor.secondaryClr, fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IntroDataModel {
  String title;
  String description;
  String image;

  IntroDataModel({required this.title, required this.description, required this.image});
}
