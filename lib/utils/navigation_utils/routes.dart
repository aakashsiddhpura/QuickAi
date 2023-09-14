import 'package:fl_app/splashpage.dart';
import 'package:get/get.dart';

mixin Routes {
  static const defaultTransition = Transition.rightToLeft;

  static const String splashPage = "/splashPage";

  static List<GetPage<dynamic>> routes = [
    GetPage<dynamic>(
      name: splashPage,
      page: () => SplashPage(),
      transition: defaultTransition,
    ),
  ];
}
