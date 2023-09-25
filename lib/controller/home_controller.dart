import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_app/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  AuthController authController = Get.put(AuthController());

  TextEditingController inputC = TextEditingController();
  RxString inputText = ''.obs;
  Future<void> saveHistory({required String question, required String answer}) async {
    try {
      if (authController.user.value.uid.isNotEmpty) {
        await FirebaseFirestore.instance.collection('user_prompt_history').doc(authController.user.value.uid).collection('answers_and_questions').add({
          'answer': answer,
          'question': question,
        });
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  @override
  void onInit() {
    inputC.addListener(() {
      inputText.value = inputC.text;
    });
    super.onInit();
  }
}

class CategoryModel {
  final String title;
  final String image;
  final List<String> questionList;

  CategoryModel({
    required this.title,
    required this.image,
    required this.questionList,
  });
}

class HistoryModel {
  final String question;
  final String answer;

  HistoryModel({
    required this.question,
    required this.answer,
  });
}
