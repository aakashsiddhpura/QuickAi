import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  String? privacyPolicy;
  String? termsAndCondition;
  String? faqS;

  void getSettingData() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('setting').doc("setting_data").get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        privacyPolicy = data["privacy_policy"];
        termsAndCondition = data["terms_and_condition"];
        faqS = data["faqs"];
      }
    } catch (e) {
      print('Error getting ad settings: $e');
    }
    return null;
  }
}
