import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fl_app/ads/banner_view.dart';
import 'package:fl_app/controller/home_controller.dart';
import 'package:fl_app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../controller/analytics_controller.dart';
import '../../env/env.dart';
import '../../res/app_colors.dart';
import '../../utils/navigation_utils/navigation.dart';
import '../../utils/navigation_utils/routes.dart';
import '../../utils/size_utils.dart';
import '../../widget/chat_ui.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/toast_helper.dart';

class CategoryChatScreen extends StatefulWidget {
  const CategoryChatScreen({super.key});

  @override
  State<CategoryChatScreen> createState() => _CategoryChatScreenState();
}

class _CategoryChatScreenState extends State<CategoryChatScreen> {
  HomeController homeController = Get.put(HomeController());
  CategoryModel? categoryData;
  String apiUrl = 'https://api.openai.com/v1/chat/completions';
  bool isTyping = false;

  final List<Message> messages = [];
  final TextEditingController textController = TextEditingController();

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
    categoryData = Get.arguments["categoryData"];
    //
    AnalyticsService().logEvent("CategoryChatScreen", {"ask_question": Get.arguments["inputText"]});

    print(homeController.inputText.value);
    setTTSListener();
    setState(() {
      Future.delayed(Duration(milliseconds: 500), () {
        sendMessage(Get.arguments["inputText"]);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: categoryData!.title, showLeading: true, centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              shrinkWrap: true,
              reverse: true, // Reverse the list view
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
            Padding(
              padding: EdgeInsets.only(bottom: SizeUtils.verticalBlockSize * 2, top: SizeUtils.verticalBlockSize * 1),
              child: CustomButton(
                  onPressed: () {
                    Navigation.replace(Routes.kInputSuggestionScreen, arguments: categoryData);
                  },
                  text: "Ask New Question"),
            )
          ],
        ),
      ),
      bottomNavigationBar: PreBannerAd(),
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
    textController.clear();
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
            {'role': 'system', 'content': 'You are a ${categoryData!.title} character, always give ${categoryData!.title} related answer.'},
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
