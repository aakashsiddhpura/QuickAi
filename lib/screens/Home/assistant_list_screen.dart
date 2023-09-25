import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_app/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../../res/app_colors.dart';
import '../../utils/size_utils.dart';
import '../../widget/loader.dart';
import 'home_screen.dart';

class AssistantListScreen extends StatefulWidget {
  const AssistantListScreen({super.key});

  @override
  State<AssistantListScreen> createState() => _AssistantListScreenState();
}

class _AssistantListScreenState extends State<AssistantListScreen> {
  HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "ChatPix Assistants", centerTitle: true, showLeading: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('ai assistant category').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return MyLoader();
          }

          List<CategoryModel> models = [];
          var data = snapshot.data!.docs[0].data() as Map<String, dynamic>;

          for (var doc in data["category_list"]) {
            var model = CategoryModel(
              title: doc['title'],
              image: doc['image'],
              questionList: List<String>.from(doc['question_list']),
            );
            models.add(model);
          }

          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: SizeUtils.horizontalBlockSize * 4, vertical: SizeUtils.verticalBlockSize * 2),
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16.0, // Adjust spacing between items
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.7),
            shrinkWrap: true,
            itemCount: models.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: SizeUtils.horizontalBlockSize * 18,
                      height: SizeUtils.horizontalBlockSize * 18,
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(color: AppColor.imageBgClr, borderRadius: BorderRadius.circular(100)),
                      child: CachedNetworkImage(
                        imageUrl: models[index].image,
                        progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(color: AppColor.primaryClr, value: downloadProgress.progress)),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    Text(
                      models[index].title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: const TextStyle(color: AppColor.textColor70, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w400, fontSize: 12),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
