import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fl_app/controller/home_controller.dart';
import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/utils/size_utils.dart';
import 'package:fl_app/widget/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import '../../Database/character_list_data.dart';
import '../../res/assets_path.dart';

class Message {
  final String role;
  final String content;

  Message(this.role, this.content);
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
  final Widget aiProfile;
  final bool? isSpeech;

  const AiChatView({super.key, required this.message, required this.index, required this.speechBtnTap, required this.aiProfile, required this.isSpeech});

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
                child: aiProfile,
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
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    message,
                                    cursor: "...",
                                    textStyle: const TextStyle(color: AppColor.aiAnsTextClr, fontWeight: FontWeight.w500, fontSize: 14),
                                    // speed: const Duration(milliseconds: 30),
                                  ),
                                ],
                                totalRepeatCount: 1,
                              ),
                              Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                child: InkResponse(
                                  radius: 15,
                                  onTap: () {
                                    Clipboard.setData(new ClipboardData(text: message));
                                    AppToast.toastMessage("Copied to Clipboard");
                                  },
                                  child: Icon(
                                    Icons.copy,
                                    color: AppColor.aiAnsTextClr,
                                    size: 15,
                                  ),
                                ),
                              )
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                message,
                                style: const TextStyle(color: AppColor.aiAnsTextClr, fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                child: InkResponse(
                                  radius: 15,
                                  onTap: () {
                                    Clipboard.setData(new ClipboardData(text: message));
                                    AppToast.toastMessage("Copied to Clipboard");
                                  },
                                  child: Icon(
                                    Icons.copy,
                                    color: AppColor.aiAnsTextClr,
                                    size: 15,
                                  ),
                                ),
                              )
                            ],
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
  final Widget? aiProfile;

  const TypingView({
    super.key,
    required this.aiProfile,
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
              child: Container(width: SizeUtils.horizontalBlockSize * 9, height: SizeUtils.horizontalBlockSize * 9, decoration: BoxDecoration(color: AppColor.imageBgClr, borderRadius: BorderRadius.circular(100)), child: aiProfile),
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
