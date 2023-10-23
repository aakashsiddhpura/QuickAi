import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fl_app/src/app.dart';
import 'package:fl_app/InApp%20Purchase/constant.dart';
import 'package:fl_app/InApp%20Purchase/store_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:purchases_flutter/models/store.dart';

import 'firebase_options.dart';
import 'my_home.dart';

int appVersion = 0;
var platform = const MethodChannel('ads');
final box = GetStorage();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  MobileAds.instance
      .updateRequestConfiguration(RequestConfiguration(testDeviceIds: ['0059B08F1E6D188E7F949FBA3250DBD9', '311FA942FFF37CE4B49903710319841B']));

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId("03f29bbd-c44e-482c-9a93-a4700b2dd23a");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await GetStorage.init();

  /// in app purchase
  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(
      store: Store.appStore,
      apiKey: appleApiKey,
    );
  } else if (Platform.isAndroid) {
    StoreConfig(
      store: Store.playStore,
      apiKey: googleApiKey,
    );
  }

  WidgetsFlutterBinding.ensureInitialized();

  await configureSDK();

  // runApp(const MagicWeatherFlutter());
  runApp(MyHome());
}
