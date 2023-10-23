import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_app/screens/Home/home_screen.dart';
import 'package:fl_app/splashpage.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../../screens/Auth/forgot_password_screen.dart';
import '../../screens/Auth/login_screen.dart';
import '../../screens/Auth/register_screen.dart';
import '../../screens/Character/character_chat_screen.dart';
import '../../screens/Character/character_screen.dart';
import '../../screens/Home/ai_code_generator.dart';
import '../../screens/Home/assistant_list_screen.dart';
import '../../screens/Home/category_chat_screen.dart';
import '../../screens/Home/input_suggestion_screen.dart';
import '../../screens/Image Generator/Image_generator.dart';
import '../../screens/Image Generator/image_view_screen.dart';
import '../../screens/Setting/edit_profile.dart';
import '../../screens/Setting/history_screen.dart';
import '../../screens/Setting/manage_subscription_plan.dart';
import '../../screens/Setting/setting_screen.dart';
import '../../screens/intro_screen.dart';
import '../../screens/main_screen.dart';
import '../../screens/premium_screen/premium_screen.dart';

mixin Routes {
  static const defaultTransition = Transition.rightToLeft;

  static const String splashPage = "/splashPage";
  static const String kIntroScreen = "/IntroScreen";
  static const String kMainScreen = "/MainScreen";
  static const String kHomeScreen = "/HomeScreen";
  static const String kCharacterScreen = "/CharacterScreen";
  static const String kImageGeneratorScreen = "/ImageGeneratorScreen";
  static const String kSettingScreen = "/SettingScreen";
  static const String kImageViewScreen = "/ImageViewScreen";
  static const String kCharacterChatScreen = "/CharacterChatScreen";
  static const String kLoginScreen = "/LoginScreen";
  static const String kRegisterScreen = "/RegisterScreen";
  static const String kForgotPasswordScreen = "/ForgotPasswordScreen";
  static const String kEditProfile = "/EditProfile";
  static const String kAssistantListScreen = "/AssistantListScreen";
  static const String kHistoryScreen = "/HistoryScreen";
  static const String kInputSuggestionScreen = "/InputSuggestionScreen";
  static const String kCategoryChatScreen = "/CategoryChatScreen";
  static const String kAiCodeGenerator = "/AiCodeGenerator";
  static const String kPremiumScreen = "/PremiumScreen";
  static const String kManageSubscription = "/ManageSubscription";
  static const String k = "/";

  static List<GetPage<dynamic>> routes = [
    GetPage<dynamic>(
      name: splashPage,
      page: () => SplashPage(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: kIntroScreen,
      page: () => IntroScreen(),
      curve: Curves.easeIn,
      transitionDuration: Duration(milliseconds: 1000),
      transition: Transition.rightToLeft,
    ),
    GetPage<dynamic>(
      name: kMainScreen,
      page: () => MainScreen(),
      curve: Curves.easeIn,
      transitionDuration: Duration(milliseconds: 1000),
      transition: Transition.rightToLeft,
    ),
    GetPage<dynamic>(
      name: kHomeScreen,
      page: () => HomeScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: kCharacterScreen,
      page: () => CharacterScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: kImageGeneratorScreen,
      page: () => ImageGeneratorScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: kSettingScreen,
      page: () => SettingScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: kImageViewScreen,
      page: () => ImageViewScreen(),
      transitionDuration: Duration(seconds: 1),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: kCharacterChatScreen,
      page: () => CharacterChatScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: kLoginScreen,
      page: () => LoginScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: kRegisterScreen,
      page: () => RegisterScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: kForgotPasswordScreen,
      page: () => ForgotPasswordScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: kEditProfile,
      page: () => EditProfile(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: kAssistantListScreen,
      page: () => AssistantListScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: kHistoryScreen,
      page: () => HistoryScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: kInputSuggestionScreen,
      page: () => InputSuggestionScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: kCategoryChatScreen,
      page: () => CategoryChatScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: kAiCodeGenerator,
      page: () => AiCodeGenerator(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: kPremiumScreen,
      page: () => PremiumScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: kManageSubscription,
      page: () => ManageSubscription(),
      transition: defaultTransition,
    ),
  ];
}
