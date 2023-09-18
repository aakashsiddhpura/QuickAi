import 'package:bot_toast/bot_toast.dart';
import 'package:fl_app/Database/character_list_data.dart';
import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/res/assets_path.dart';
import 'package:fl_app/utils/app_binding.dart';
import 'package:fl_app/utils/my_behavior.dart';
import 'package:fl_app/utils/navigation_utils/routes.dart';
import 'package:fl_app/utils/net_conectivity.dart';
import 'package:fl_app/utils/size_utils.dart';
import 'package:fl_app/widget/exit_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:loader_overlay/loader_overlay.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

class MyHome extends StatefulWidget {
  MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  void initState() {
    CharacterDB().initializeGetStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColor.backgroundColor,
    ));
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColor: AppColor.primaryClr,
        brightness: Brightness.light,
        highlightColor: Colors.transparent,
        disabledColor: Colors.transparent,
        splashColor: AppColor.primaryClr,
        hoverColor: AppColor.primaryClr,
        backgroundColor: AppColor.backgroundColor,
        scaffoldBackgroundColor: AppColor.backgroundColor,
        fontFamily: AssetsPath.fontFamily,
      ),
      initialRoute: Routes.splashPage,
      getPages: Routes.routes,
      builder: EasyLoading.init(
        builder: (context, child) {
          SizeUtils().init(context);

          return GlobalLoaderOverlay(
            overlayColor: Colors.black45,
            child: WillPopScope(
              onWillPop: () async {
                bool exit = await showDialog(
                  context: context,
                  builder: (context) => ExitPopup(),
                );
                return exit ?? false;
              },
              child: Scaffold(
                // backgroundColor: AppColors.white,
                resizeToAvoidBottomInset: false,
                body: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ConnectivityWidget(
                    builder: (_, __) => BotToastInit()(_, child),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
