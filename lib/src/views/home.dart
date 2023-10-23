import 'package:fl_app/src/views/user.dart';
import 'package:fl_app/src/views/weather.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../InApp Purchase/constant.dart';
import '../../InApp Purchase/singletons_data.dart';
import '../model/styles.dart';

final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();

class AppContainer extends StatefulWidget {
  const AppContainer({Key? key}) : super(key: key);

  @override
  AppContainerState createState() => AppContainerState();
}

class AppContainerState extends State<AppContainer> {
  int currentIndex = 0;

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  Future<void> initPlatformState() async {
    appData.appUserID.value = await Purchases.appUserID;

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      appData.appUserID.value = await Purchases.appUserID;

      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      EntitlementInfo? entitlement = customerInfo.entitlements.all[entitlementID];
      appData.entitlementIsActive.value = entitlement?.isActive ?? false;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: kColorBar,
      tabBar: CupertinoTabBar(
        backgroundColor: kColorBar,
        activeColor: kColorAccent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.wb_sunny,
              size: 24.0,
            ),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_rounded,
              size: 24.0,
            ),
            label: 'User',
          ),
        ],
        onTap: (index) {
          // back home only if not switching tab
          if (currentIndex == index) {
            switch (index) {
              case 0:
                firstTabNavKey.currentState?.popUntil((r) => r.isFirst);
                break;
              case 1:
                secondTabNavKey.currentState?.popUntil((r) => r.isFirst);
                break;
            }
          }
          currentIndex = index;
        },
      ),
      tabBuilder: (context, index) {
        if (index == 0) {
          return CupertinoTabView(
            navigatorKey: firstTabNavKey,
            builder: (BuildContext context) => const WeatherScreen(),
          );
        } else {
          return CupertinoTabView(
            navigatorKey: secondTabNavKey,
            builder: (BuildContext context) => const UserScreen(),
          );
        }
      },
    );
  }
}
