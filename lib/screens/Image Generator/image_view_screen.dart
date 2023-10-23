import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fl_app/ads/banner_view.dart';
import 'package:fl_app/res/assets_path.dart';
import 'package:fl_app/utils/size_utils.dart';
import 'package:fl_app/widget/custom_appbar.dart';
import 'package:fl_app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../controller/analytics_controller.dart';
import '../../res/app_colors.dart';

class ImageViewScreen extends StatefulWidget {
  const ImageViewScreen({super.key});

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  String? imageUrl;

  @override
  void initState() {
    setState(() {
      imageUrl = Get.arguments;
    });
    AnalyticsService().setCurrentScreen(screenName: "ImageViewScreen");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "Image",
        showLeading: true,
        action: [
          IconButton(
              onPressed: () {
                if (imageUrl != null) {
                  downloadAndSaveImage(imageUrl ?? "", isFileShare: true);
                }
              },
              icon: SvgPicture.asset(AssetsPath.shareIc))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: imageUrl != null
                ? Padding(
                    padding: EdgeInsets.all(SizeUtils.horizontalBlockSize * 5),
                    child: Hero(
                      tag: imageUrl!,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl!,
                        fit: BoxFit.contain,
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            Center(child: CircularProgressIndicator(color: AppColor.primaryClr, value: downloadProgress.progress)),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  )
                : SizedBox(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: SizeUtils.verticalBlockSize * 4, horizontal: SizeUtils.horizontalBlockSize * 10),
            child: InkWell(
                onTap: () {
                  if (imageUrl != null) {
                    downloadAndSaveImage(imageUrl ?? "");
                    AnalyticsService().logEvent("Image Download", null);
                  }
                },
                child: Image.asset(AssetsPath.downloadImageBtn)),
          )
        ],
      ),
      bottomNavigationBar: PreBannerAd(),
    );
  }

  Future<void> downloadAndSaveImage(String imageUrl, {bool? isFileShare}) async {
    Loader.sw();
    try {
      final dio = Dio();
      final response = await dio.get(imageUrl, options: Options(responseType: ResponseType.bytes));

      final Directory? quickAiDirectory = await getExternalStorageDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String filePath = '${quickAiDirectory!.path.replaceFirst("data", "media")}/ChatPix AI/ChatPix_image$timestamp.jpg';
      final File file = await File(filePath).create(recursive: true);
      if (isFileShare == true) {
        Share.shareFiles([file.path]);
      } else {
        await file.writeAsBytes(response.data);
        print('Image saved to: $filePath');
        EasyLoading.showSuccess('Image saved to: $filePath');
      }

      Loader.hd();
    } catch (e) {
      Loader.hd();
      print('Error downloading image: $e');
    }
  }
}
