import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fl_app/ads/banner_view.dart';
import 'package:fl_app/controller/home_controller.dart';
import 'package:fl_app/controller/premium_controller.dart';
import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/widget/button.dart';
import 'package:fl_app/widget/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../InApp Purchase/singletons_data.dart';
import '../../controller/analytics_controller.dart';
import '../../env/env.dart';
import '../../utils/size_utils.dart';
import '../../widget/chat_ui.dart';
import '../../widget/custom_appbar.dart';
import '../premium_screen/subscribe_now_widget.dart';
import '../../widget/toast_helper.dart';

class AiCodeGenerator extends StatefulWidget {
  const AiCodeGenerator({super.key});

  @override
  State<AiCodeGenerator> createState() => _AiCodeGeneratorState();
}

class _AiCodeGeneratorState extends State<AiCodeGenerator> {
  HomeController homeController = Get.put(HomeController());
  PremiumController premiumController = Get.put(PremiumController());

  CategoryModel? categoryData;
  String apiUrl = 'https://api.openai.com/v1/chat/completions';
  bool isTyping = false;

  final List<Message> messages = [];

  /// text to speech
  final FlutterTts tts = FlutterTts();
  bool speech = false;
  int speechIndex = -1;

  /// SpeechToText
  SpeechToText speechToText = SpeechToText();
  bool isListening = false;
  String speechText = "";

  @override
  void initState() {
    categoryData = Get.arguments;
    //
    AnalyticsService().setCurrentScreen(screenName: "AiCodeGenerator");

    setTTSListener();
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    homeController.inputC.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: categoryData!.title, showLeading: true, centerTitle: true),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeUtils.horizontalBlockSize * 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Generate a code on",
                    style: TextStyle(color: AppColor.textColor70, fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: homeController.inputC,
                    hintText: "Enter the details about code you want generate here",
                    maxLine: 5,
                    radius: 10,
                  ),
                  Obx(() {
                    return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(bottom: SizeUtils.verticalBlockSize * 2, top: SizeUtils.verticalBlockSize * 2),
                      child: CustomButton(
                          onPressed: () {
                            if (appData.entitlementIsActive.value) {
                              sendMessage(homeController.inputC.text);
                            } else if (premiumController.assistantFreeCount.value <= 0) {
                              premiumController.openPremiumDialog();
                            } else {
                              premiumController.useCount(useType: FreeCount.assistantFreeCount);
                              sendMessage(homeController.inputC.text);
                            }
                          },
                          buttonColor: homeController.inputText.value.isEmpty ? AppColor.inActiveButton : null,
                          textColor: homeController.inputText.value.isEmpty ? AppColor.textColor35 : null,
                          text: "Generate Code"),
                    );
                  })
                ],
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              shrinkWrap: true,
              reverse: true,
              // Reverse the list view
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return message.role == 'user'
                    ? UserChatView(
                        message: message.content,
                        isSpeech: speechIndex == index && speech,
                        speechBtnTap: () {
                          if (!speech) {
                            tts.speak(message.content);
                            setState(() {
                              speech = true;
                              speechIndex = index;
                            });
                          } else {
                            setState(() {
                              tts.stop();
                              speech = false;
                              speechIndex = -1;
                            });
                          }
                        },
                      )
                    : AiChatView(
                        index: index,
                        message: message.content,
                        isSpeech: speechIndex == index && speech,
                        speechBtnTap: () {
                          if (!speech) {
                            tts.speak(message.content);
                            setState(() {
                              speech = true;
                              speechIndex = index;
                            });
                          } else {
                            setState(() {
                              tts.stop();
                              speech = false;
                              speechIndex = -1;
                            });
                          }
                        },
                        aiProfile: CachedNetworkImage(
                          imageUrl: categoryData!.image,
                          width: SizeUtils.horizontalBlockSize * 9,
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              Center(child: CircularProgressIndicator(color: AppColor.primaryClr, value: downloadProgress.progress)),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      );
              },
            ),
            if (isTyping)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TypingView(
                  aiProfile: CachedNetworkImage(
                    imageUrl: categoryData!.image,
                    width: SizeUtils.horizontalBlockSize * 9,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        Center(child: CircularProgressIndicator(color: AppColor.primaryClr, value: downloadProgress.progress)),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
            PreBannerAd()
          ],
        ),
      ),
      bottomNavigationBar: SubscribeNowText(screenType: FreeCount.assistantFreeCount),
    );
  }

  void sendMessage(String message) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      isTyping = true;
      messages.insert(0, Message('user', message));
    });
    fetchAssistantResponse(message);
    homeController.inputC.clear();
  }

  Future<void> fetchAssistantResponse(String userMessage) async {
    try {
      final dio = Dio();
      String apiKey = Env.key;

      Map<String, dynamic> headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      };

      dio.options.headers.addAll(headers);

      final response = await dio.post(
        apiUrl,
        data: jsonEncode({
          "model": "gpt-3.5-turbo-0613",
          'messages': [
            {
              'role': 'system',
              'content': 'You are world best programmer you have knowledge about all programming language, always give programming related answer.'
            },
            {'role': 'user', 'content': userMessage},
          ],
        }),
      );

      print(response.data);
      Map jsonResponse = response.data;
      if (response.statusCode == 200) {
        if (jsonResponse["choices"].length > 0) {
          final assistantMessage = response.data['choices'][0]['message']['content'];
          setState(() {
            messages.insert(0, Message('assistant', assistantMessage));
            homeController.saveHistory(question: userMessage, answer: assistantMessage);
            homeController.inputText.value = "";
            homeController.inputC.clear();
            isTyping = false;
          });
        }
      } else {
        Get.snackbar('Error', 'Failed to create Ai response.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong! please try again later');
    }
  }

  void setTTSListener() {
    tts.setLanguage('en');
    tts.setSpeechRate(0.4);
    tts.setCompletionHandler(() {
      setState(() {
        speech = false;
      });
    });
  }

  void listen() async {
    if (!isListening) {
      bool available = await speechToText.initialize(
        onStatus: (status) {
          print('Status: $status');
          if (status == "done") {
            isListening = false;
            sendMessage(speechText);
          }
        },
        onError: (error) {
          print('Error 2: $error');
          AppToast.toastMessage("Didn't catch that. Try speaking again.");
          setState(() {
            isListening = false;
            speechToText.stop();
          });
        },
      );

      if (available) {
        setState(() {
          isListening = true;
        });
        speechToText.listen(
          onResult: (result) {
            speechText = result.recognizedWords;
          },
        );
      }
    } else {
      setState(() {
        isListening = false;
        speechToText.stop();
      });
    }
  }
}
