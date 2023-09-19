import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/res/strings_utils.dart';
import 'package:fl_app/utils/size_utils.dart';
import 'package:fl_app/widget/custom_textfield.dart';
import 'package:fl_app/widget/subscribe_now_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../Database/character_list_data.dart';
import '../../env/env.dart';
import '../../res/assets_path.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/toast_helper.dart';

class Message {
  final String role;
  final String content;

  Message(this.role, this.content);
}

class CharacterChatScreen extends StatefulWidget {
  const CharacterChatScreen({super.key});

  @override
  State<CharacterChatScreen> createState() => _CharacterChatScreenState();
}

class _CharacterChatScreenState extends State<CharacterChatScreen> {
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
            {'role': 'system', 'content': 'You are a ${characterModel!.name} character, always give ${characterModel!.name} related answer.'},
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
      Get.snackbar('Error', 'An error occurred: $e');
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

  @override
  void initState() {
    characterModel = Get.arguments;
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
                                speech = false;
                                speechIndex = -1;
                              });
                            }
                          },
                          characterModel: characterModel,
                        );
                },
              ),
            ),
            if (isTyping)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TypingView(
                  characterModel: characterModel,
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
                          final userMessage = textController.text;
                          if (userMessage.isNotEmpty) {
                            sendMessage(userMessage);
                          }
                        },
                        child: SvgPicture.asset(AssetsPath.sendIC),
                      ),
                    ),
                  ),
                ),
                const SubscribeNowText()
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserChatView extends StatelessWidget {
  final String message;
  final void Function()? speechBtnTap;
  final bool? isSpeech;
  const UserChatView({super.key, required this.message, required this.speechBtnTap, required this.isSpeech});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: InkResponse(
                      radius: 15,
                      onTap: speechBtnTap,
                      child: isSpeech == true
                          ? const RippleAnimation(
                              color: AppColor.primaryClr,
                              delay: Duration(milliseconds: 300),
                              repeat: true,
                              minRadius: 25,
                              ripplesCount: 3,
                              duration: Duration(milliseconds: 5 * 500),
                              child: Icon(
                                Icons.volume_up_outlined,
                                color: AppColor.primaryClr,
                              ))
                          : const Icon(
                              Icons.volume_up_outlined,
                              color: AppColor.inActiveButton,
                            ),
                    ),
                  ),
                ),
                ChatBubble(
                  clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                  alignment: Alignment.topRight,
                  backGroundColor: AppColor.userPromptBgClr,
                  elevation: 0,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Text(
                      message,
                      style: const TextStyle(color: AppColor.userPromptTextClr, fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: ClipRRect(
              child: Container(
                width: SizeUtils.horizontalBlockSize * 9,
                height: SizeUtils.horizontalBlockSize * 9,
                decoration: BoxDecoration(color: AppColor.imageBgClr, borderRadius: BorderRadius.circular(100)),
                child: Image.asset(
                  AssetsPath.profileAvatar,
                  width: SizeUtils.horizontalBlockSize * 9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AiChatView extends StatelessWidget {
  final String message;
  final int index;
  final void Function()? speechBtnTap;
  final CharacterModel? characterModel;
  final bool? isSpeech;

  const AiChatView({super.key, required this.message, required this.index, required this.speechBtnTap, this.characterModel, required this.isSpeech});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: ClipRRect(
              child: Container(
                width: SizeUtils.horizontalBlockSize * 9,
                height: SizeUtils.horizontalBlockSize * 9,
                decoration: BoxDecoration(color: AppColor.imageBgClr, borderRadius: BorderRadius.circular(100)),
                child: Image.asset(
                  characterModel!.asset,
                  width: SizeUtils.horizontalBlockSize * 9,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ChatBubble(
                  clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                  backGroundColor: AppColor.aiAnsBgClr,
                  elevation: 0,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: index == 0
                        ? AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                message,
                                cursor: "...",
                                textStyle: const TextStyle(color: AppColor.aiAnsTextClr, fontWeight: FontWeight.w500, fontSize: 14),
                                speed: const Duration(milliseconds: 100),
                              ),
                            ],
                            totalRepeatCount: 1,
                          )
                        : Text(
                            message,
                            style: const TextStyle(color: AppColor.aiAnsTextClr, fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: InkResponse(
                      radius: 15,
                      onTap: speechBtnTap,
                      child: isSpeech == true
                          ? const RippleAnimation(
                              color: AppColor.primaryClr,
                              delay: Duration(milliseconds: 300),
                              repeat: true,
                              minRadius: 15,
                              ripplesCount: 3,
                              duration: Duration(milliseconds: 3 * 500),
                              child: Icon(
                                Icons.volume_up_outlined,
                                color: AppColor.primaryClr,
                              ))
                          : const Icon(
                              Icons.volume_up_outlined,
                              color: AppColor.inActiveButton,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TypingView extends StatelessWidget {
  final CharacterModel? characterModel;

  const TypingView({
    super.key,
    required this.characterModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: ClipRRect(
              child: Container(
                width: SizeUtils.horizontalBlockSize * 9,
                height: SizeUtils.horizontalBlockSize * 9,
                decoration: BoxDecoration(color: AppColor.imageBgClr, borderRadius: BorderRadius.circular(100)),
                child: Image.asset(
                  characterModel!.asset,
                  width: SizeUtils.horizontalBlockSize * 9,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 9,
            child: ChatBubble(
              clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
              backGroundColor: AppColor.aiAnsBgClr,
              elevation: 0,
              child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7, maxHeight: 20),
                  child: LoadingAnimationWidget.waveDots(
                    color: AppColor.white,
                    size: 30,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
