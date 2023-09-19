import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AppToast {
  static void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black54,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16,
    );
  }

  static void errorMessage(String message) {
    Get.snackbar("Failed!", message, backgroundColor: Colors.red.withOpacity(0.3), colorText: Colors.white);
  }

  static void successMessage(String message) {
    Get.snackbar("Success!", message, backgroundColor: Colors.green.withOpacity(0.5), colorText: Colors.white);
  }

  static void warningMessage(String message) {
    Get.snackbar("Warning!", message, backgroundColor: Colors.yellow.shade700.withOpacity(0.4), colorText: Colors.white);
  }
}
