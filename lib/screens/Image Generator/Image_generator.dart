import 'package:ak_ads_plugin/ak_ads_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fl_app/ads/banner_view.dart';
import 'package:fl_app/controller/premium_controller.dart';
import 'package:fl_app/env/env.dart';
import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/res/assets_path.dart';
import 'package:fl_app/utils/navigation_utils/navigation.dart';
import 'package:fl_app/utils/navigation_utils/routes.dart';
import 'package:fl_app/utils/size_utils.dart';
import 'package:fl_app/widget/custom_appbar.dart';
import 'package:fl_app/widget/custom_textfield.dart';
import 'package:fl_app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../InApp Purchase/singletons_data.dart';
import '../../controller/analytics_controller.dart';
import '../../model/dall_e_model.dart';
import '../premium_screen/subscribe_now_widget.dart';

class ImageGeneratorScreen extends StatefulWidget {
  const ImageGeneratorScreen({super.key});

  @override
  State<ImageGeneratorScreen> createState() => _ImageGeneratorScreenState();
}

class _ImageGeneratorScreenState extends State<ImageGeneratorScreen> {
  final TextEditingController promptController = TextEditingController();
  final List<DallEImage> generatedImages = <DallEImage>[
    // DallEImage(
    //     url:
    //         "https://images.unsplash.com/photo-1538991383142-36c4edeaffde?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2071&q=80"),
    // DallEImage(
    //     url:
    //         "https://images.unsplash.com/photo-1430990480609-2bf7c02a6b1a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80"),
  ].obs;
  String selectedSize = imageSizes[0]; // Default to the first size

  static const List<String> imageSizes = ["256x256", "512x512", "1024x1024"];
  PremiumController premiumController = Get.put(PremiumController());
  @override
  void initState() {
    // TODO: implement initState
    AnalyticsService().setCurrentScreen(screenName: "ImageGeneratorScreen");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "ChatPix AI Image", leadingWith: 0),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Prompt",
              style: TextStyle(color: AppColor.textColor70, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: promptController,
              hintText: 'Enter your prompt...',
              suffixIcon: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(gradient: AppColor.primaryGradiant, borderRadius: BorderRadius.circular(100)),
                child: InkResponse(
                  radius: 25,
                  onTap: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    if (appData.entitlementIsActive.value) {
                      await generateImages(promptController.text);
                    } else if (premiumController.imageFreeCount.value <= 0) {
                      premiumController.openPremiumDialog();
                    } else {
                      await AkAdsPlugin().callInterstitialAds();
                      premiumController.useCount(useType: FreeCount.imageFreeCount);
                      AnalyticsService().logEvent("ImageGenerate", {"image_prompt": promptController.text});

                      await generateImages(promptController.text);
                    }
                  },
                  child: SvgPicture.asset(AssetsPath.sendIC),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: imageSizes.map((size) {
                return SizedBox(
                  height: SizeUtils.horizontalBlockSize * 10,
                  width: SizeUtils.horizontalBlockSize * 28,
                  child: ImageSizeButton(
                    size: size,
                    isSelected: selectedSize == size,
                    onPressed: () {
                      if (appData.entitlementIsActive.value) {
                        setState(() {
                          selectedSize = size;
                        });
                      } else {
                        if (size != imageSizes[0]) {
                          premiumController.openPremiumDialog();
                        }
                      }
                    },
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: BannerView(),
            ),
            Expanded(
              child: Obx(() {
                if (generatedImages.isEmpty) {
                  return const Center(
                      child: Text(
                    "Enter prompt and create your images",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColor.textColor70, fontSize: 18, fontWeight: FontWeight.w500),
                  ));
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0, // Adjust spacing between items
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: generatedImages.length,
                    itemBuilder: (context, index) {
                      return Hero(tag: generatedImages[index].url, child: ImageCard(imageUrl: generatedImages[index].url));
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            SubscribeNowText(screenType: FreeCount.imageFreeCount),
            SizedBox(
              height: SizeUtils.verticalBlockSize * 9,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateImages(String prompt) async {
    Loader.sw(imageLoader: true);
    try {
      final dio = Dio();
      String apiKey = Env.key;
      // Define your headers here
      Map<String, dynamic> headers = {
        'Authorization': 'Bearer $apiKey', // Replace with your actual token
        'Content-Type': 'application/json',
      };

      // Create a new Dio instance with the headers
      dio.options.headers.addAll(headers);

      final response = await dio.post('https://api.openai.com/v1/images/generations', data: {
        'prompt': prompt,
        'n': appData.entitlementIsActive.value ? 4 : 2,
        'size': selectedSize,
      });
      if (response.statusCode == 200) {
        DallEImageData data = DallEImageData.fromJson(response.data);
        generatedImages.assignAll(data.data);
      } else {
        Get.snackbar('Error', 'Failed to generate images.', colorText: Colors.white);
      }
      Loader.hd();
    } catch (e) {
      Loader.hd();
      Get.snackbar('Error', 'Something went wrong! please try again later', colorText: Colors.white);
    }
  }
}

/// size selection button
class ImageSizeButton extends StatelessWidget {
  final String size;
  final bool isSelected;
  final VoidCallback onPressed;

  ImageSizeButton({
    required this.size,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        size,
        style: TextStyle(color: isSelected ? AppColor.secondaryClr : AppColor.textColor70),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        side: BorderSide(color: isSelected ? AppColor.secondaryClr : Colors.transparent),
        backgroundColor: AppColor.buttonSelectionClr,
      ),
    );
  }
}

/// image view widget
class ImageCard extends StatelessWidget {
  final String imageUrl;

  ImageCard({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigation.pushNamed(Routes.kImageViewScreen, arg: imageUrl);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.primaryClr.withOpacity(0.1),

          borderRadius: BorderRadius.circular(15.0), // Set the border radius
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(color: AppColor.primaryClr, value: downloadProgress.progress)),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
