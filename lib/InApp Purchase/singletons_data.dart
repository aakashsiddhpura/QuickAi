import 'package:flutter/cupertino.dart';

class AppData {
  static final AppData _appData = AppData._internal();

  var entitlementIsActive = ValueNotifier<bool>(false);
  var appUserID = ValueNotifier<String>("");

  // bool entitlementIsActive = false;
  // String appUserID = '';

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}

final appData = AppData();
