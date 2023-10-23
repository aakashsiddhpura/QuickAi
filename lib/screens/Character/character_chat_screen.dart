import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fl_app/ads/banner_view.dart';
import 'package:fl_app/controller/premium_controller.dart';
import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/res/strings_utils.dart';
import 'package:fl_app/utils/size_utils.dart';
import 'package:fl_app/widget/custom_textfield.dart';
import 'package:fl_app/screens/premium_screen/subscribe_now_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../Database/character_list_data.dart';
import '../../InApp Purchase/singletons_data.dart';
import '../../controller/analytics_controller.dart';
import '../../env/env.dart';
import '../../res/assets_path.dart';
import '../../widget/chat_ui.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/toast_helper.dart';

class CharacterChatScreen extends StatefulWidget {
  const CharacterChatScreen({super.key});

  @override
  State<CharacterChatScreen> createState() => _CharacterChatScreenState();
}

class _CharacterChatScreenState extends State<CharacterChatScreen> {
  PremiumController premiumController = Get.put(PremiumController());

  CharacterModel? characterModel;
  String apiUrl = 'https://api.openai.com/v1/chat/completions';
  bool isTyping = false;

  final List<Message> messages = [];
  final TextEditingController textController = TextEditingController();

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
            {
              'role': 'system',
              'content':
                  'You are a ${characterModel!.name} character, always give ${characterModel!.name} related answer and assume as you are ${characterModel!.name}.'
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

  /// text to speech
  final FlutterTts tts = FlutterTts();
  bool speech = false;
  int speechIndex = -1;

  void setTTSListener() {
    tts.setLanguage('en');
    tts.setSpeechRate(0.4);
    tts.setCompletionHandler(() {
      setState(() {
        speech = false;
      });
    });
  }

  /// SpeechToText
  SpeechToText speechToText = SpeechToText();
  bool isListening = false;
  String speechText = "";

  void listen() async {
    if (!isListening) {
      bool available = await speechToText.initialize(
        onStatus: (status) {
          print('Status: $status');
          if (status == "done") {
            isListening = false;

            setState(() {
              textController.text = speechText;
            });
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

  @override
  void initState() {
    characterModel = Get.arguments;
    AnalyticsService().logEvent("Character Chat Screen", {"character": characterModel!.name});

    setTTSListener();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: customAppBar(title: AppString.appName, showLeading: true, action: [
          PopupMenuButton(
            color: AppColor.popupmenuClr,
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
            constraints: BoxConstraints(maxHeight: SizeUtils.horizontalBlockSize * 20, maxWidth: SizeUtils.horizontalBlockSize * 50),
            elevation: 5,
            offset: const Offset(0, 60),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                height: 0,
                padding: EdgeInsets.zero,
                value: 1,
                onTap: () {
                  messages.clear();
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  height: SizeUtils.horizontalBlockSize * 8,
                  width: SizeUtils.horizontalBlockSize * 20,
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text(
                    "Clear All",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.aiAnsTextClr,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),

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
                          aiProfile: Image.asset(
                            characterModel!.asset,
                            width: SizeUtils.horizontalBlockSize * 9,
                          ),
                        );
                },
              ),
            ),
            if (isTyping)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TypingView(
                  aiProfile: Image.asset(
                    characterModel!.asset,
                    width: SizeUtils.horizontalBlockSize * 9,
                  ),
                ),
              ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomTextField(
                    controller: textController,
                    hintText: isListening ? "Listening..." : "Type your message here...",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: IconButton(
                          splashRadius: 25,
                          onPressed: listen,
                          icon: isListening == true
                              ? const RippleAnimation(
                                  color: AppColor.primaryClr,
                                  delay: Duration(milliseconds: 300),
                                  repeat: true,
                                  minRadius: 25,
                                  ripplesCount: 3,
                                  duration: Duration(milliseconds: 5 * 500),
                                  child: Icon(
                                    CupertinoIcons.mic,
                                    size: 25,
                                    color: AppColor.primaryClr,
                                  ))
                              : const Icon(
                                  Icons.mic,
                                  size: 25,
                                  color: AppColor.primaryClr,
                                )),
                    ),
                    suffixIcon: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(gradient: AppColor.primaryGradiant, borderRadius: BorderRadius.circular(100)),
                      child: InkResponse(
                        radius: 25,
                        onTap: () async {
                          if (appData.entitlementIsActive.value) {
                            final userMessage = textController.text;
                            if (userMessage.isNotEmpty) {
                              sendMessage(userMessage);
                            }
                          } else if (premiumController.characterFreeCount.value <= 0) {
                            premiumController.openPremiumDialog();
                          } else {
                            premiumController.useCount(useType: FreeCount.characterFreeCount);
                            final userMessage = textController.text;
                            if (userMessage.isNotEmpty) {
                              sendMessage(userMessage);
                            }
                          }
                        },
                        child: SvgPicture.asset(AssetsPath.sendIC),
                      ),
                    ),
                  ),
                ),
                SubscribeNowText(
                  screenType: FreeCount.characterFreeCount,
                )
              ],
            ),
          ],
        ),
        bottomNavigationBar: PreBannerAd(),
      ),
    );
  }
}
