import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'call_ads.dart';

typedef BigBlurViewWidgetCreatedCallback = void Function(BigViewWidgetController controller);

class BigNativeViewWidget extends StatefulWidget {
  final BigBlurViewWidgetCreatedCallback onBlurViewWidgetCreated;

  const BigNativeViewWidget({
    Key? key,
    required this.onBlurViewWidgetCreated,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BigNativeViewWidgetState();
}

class _BigNativeViewWidgetState extends State<BigNativeViewWidget> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins/blur_view_big_widget',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }

    return const Text('iOS platform version is not implemented yet.');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onBlurViewWidgetCreated == null) {
      return;
    }
    widget.onBlurViewWidgetCreated(BigViewWidgetController._(id));
  }
}

class BigViewWidgetController {
  BigViewWidgetController._(int id) : _channel = MethodChannel('plugins/blur_view_big_widget_$id');

  final MethodChannel _channel;
}

class PreBigNativeAd extends StatefulWidget {
  final double? height;

  const PreBigNativeAd({super.key, this.height});

  @override
  State<PreBigNativeAd> createState() => _PreBigNativeAdState();
}

class _PreBigNativeAdState extends State<PreBigNativeAd> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: adsModel.adsShow == false ? 0 :widget.height ?? 260,
      child: BigNativeViewWidget(
        onBlurViewWidgetCreated: _onBigViewWidgetCreated,
      ),
    );
  }

  void _onBigViewWidgetCreated(BigViewWidgetController controller) {
    setState(() {});
  }
}
