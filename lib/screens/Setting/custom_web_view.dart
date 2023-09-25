import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final String? url;
  final String? pageName;
  const CustomWebView({Key? key, required this.url, required this.pageName}) : super(key: key);
  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  late final WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(
        Uri.parse(widget.url ?? ""),
      );
  }

  var loadingPercentage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: widget.pageName, showLeading: true, centerTitle: true),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              color: AppColor.primaryClr,
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}
