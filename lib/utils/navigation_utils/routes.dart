import 'package:fl_app/screens/Home/home_screen.dart';
import 'package:fl_app/splashpage.dart';
import 'package:get/get.dart';

import '../../screens/Auth/forgot_password_screen.dart';
import '../../screens/Auth/login_screen.dart';
import '../../screens/Auth/register_screen.dart';
import '../../screens/Character/character_chat_screen.dart';
import '../../screens/Character/character_screen.dart';
import '../../screens/Image Generator/Image_generator.dart';
import '../../screens/Image Generator/image_view_screen.dart';
import '../../screens/Setting/setting_screen.dart';
import '../../screens/intro_screen.dart';
import '../../screens/main_screen.dart';

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
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: kMainScreen,
      page: () => MainScreen(),
      transition: defaultTransition,
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
      transition: defaultTransition,
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
  ];
}
