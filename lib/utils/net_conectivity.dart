import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fl_app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _NoConnectivityBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.all(8),
            width: double.infinity,
            color: Colors.red,
            height: 50,
            child: const Text(
              "Connection Lost",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _ConnectivityBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.all(8),
            width: double.infinity,
            color: Colors.green,
            height: 50,
            child: const Text(
              "Back Online",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class ConnectivityWidget extends StatefulWidget {
  final Widget Function(BuildContext, bool) builder;

  final VoidCallback? onlineCallback;

  final VoidCallback? offlineCallback;

  const ConnectivityWidget({
    Key? key,
    required this.builder,
    this.onlineCallback,
    this.offlineCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ConnectivityWidgetState();
}

class ConnectivityWidgetState extends State<ConnectivityWidget> with SingleTickerProviderStateMixin {
  bool? isOffline;

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snap) {
        final value = snap.data == ConnectivityResult.none;
        if (isOffline != value) {
          isOffline = value;
          if (isOffline!) {
            animationController.forward();
            widget.offlineCallback?.call();
            Future.delayed(const Duration(seconds: 1), () {
              if (!Get.isDialogOpen!) {
                Get.dialog(
                        name: "",
                        WillPopScope(
                          onWillPop: () {
                            return Future.value(false);
                          },
                          child: const Scaffold(
                            backgroundColor: AppColor.backgroundColor,
                            body: SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.wifi_off_rounded,
                                    color: Colors.grey,
                                    size: 80,
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    "No Internet Connection",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 25),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "No Internet connection was found.\nCheck your connection and try again.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        barrierDismissible: false,
                        barrierColor: Colors.black54,
                        useSafeArea: true)
                    .then((value) {});
              }
            });
          } else {
            widget.onlineCallback?.call();
            animationController.reverse();

            Future.delayed(Duration(milliseconds: 500), () {
              if (Get.isDialogOpen!) {
                Get.back();
              }
            });
          }
        }

        return Stack(
          children: <Widget>[
            widget.builder(context, !isOffline!),
            // if (isOffline!)
            //   Align(
            //     alignment: Alignment.bottomCenter,
            //     child: SlideTransition(
            //       position: animationController.drive(
            //         Tween<Offset>(
            //           begin: const Offset(0.0, 1.0),
            //           end: Offset.zero,
            //         ).chain(
            //           CurveTween(curve: Curves.fastOutSlowIn),
            //         ),
            //       ),
            //       child: _NoConnectivityBanner(),
            //     ),
            //   )
            // else
            //   Align(
            //     alignment: Alignment.bottomCenter,
            //     child: SlideTransition(
            //       position: animationController.drive(
            //         Tween<Offset>(
            //           begin: const Offset(0.0, 1.0),
            //           end: Offset.zero,
            //         ).chain(
            //           CurveTween(curve: Curves.fastOutSlowIn),
            //         ),
            //       ),
            //       child: _ConnectivityBanner(),
            //     ),
            //   ),
          ],
        );
      },
    );
  }
}
