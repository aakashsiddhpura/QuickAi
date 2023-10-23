import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../InApp Purchase/singletons_data.dart';
import 'call_ads.dart';

typedef MediumBlurViewWidgetCreatedCallback = void Function(MediumViewWidgetController controller);

class MediumNativeViewWidget extends StatefulWidget {
  final MediumBlurViewWidgetCreatedCallback onBlurViewWidgetCreated;

  const MediumNativeViewWidget({
    Key? key,
    required this.onBlurViewWidgetCreated,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MediumNativeViewWidgetState();
}

class _MediumNativeViewWidgetState extends State<MediumNativeViewWidget> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins/blur_view_medium_widget',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }

    return const Text('iOS platform version is not implemented yet.');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onBlurViewWidgetCreated == null) {
      return;
    }
    widget.onBlurViewWidgetCreated(MediumViewWidgetController._(id));
  }
}

class MediumViewWidgetController {
  MediumViewWidgetController._(int id) : _channel = MethodChannel('plugins/blur_view_medium_widget_$id');

  final MethodChannel _channel;
}

class PreMediumAd extends StatefulWidget {
  final double? height;
  const PreMediumAd({super.key, this.height});

  @override
  State<PreMediumAd> createState() => _PreMediumAdState();
}

class _PreMediumAdState extends State<PreMediumAd> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        //TODO 2nd: listen playerPointsToAdd
        valueListenable: appData.entitlementIsActive,
        builder: (BuildContext context, bool value, Widget? child) {
          if (value) {
            return SizedBox();
          } else {
            if (Platform.isAndroid) {
              return SizedBox(
                height: adsModel.adsShow == false ? 0 : widget.height ?? 120,
                child: MediumNativeViewWidget(
                  onBlurViewWidgetCreated: _onMediumViewWidgetCreated,
                ),
              );
            } else {
              return SizedBox();
            }
          }
        });
  }

  void _onMediumViewWidgetCreated(MediumViewWidgetController controller) {
    setState(() {});
  }
}
