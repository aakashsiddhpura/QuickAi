import 'package:bot_toast/bot_toast.dart';
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

class MyHome extends StatefulWidget {
  MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
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
      theme: ThemeData(
        brightness: Brightness.light,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        disabledColor: Colors.transparent,
        // fontFamily: AssetsPath.robotoFonts,
      ),
      initialRoute: Routes.splashPage,
      getPages: Routes.routes,
      builder: EasyLoading.init(
        builder: (context, child) {
          SizeUtils().init(context);

          return WillPopScope(
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
          );
        },
      ),
    );
  }
}
