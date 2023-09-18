import 'package:flutter/material.dart';

import '../res/app_colors.dart';

class SubscribeNowText extends StatelessWidget {
  const SubscribeNowText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "You have 1 free image left",
          style: TextStyle(fontSize: 16, color: AppColor.textColor35, fontWeight: FontWeight.w400),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "Subscribe Now",
            style: TextStyle(color: AppColor.secondaryClr, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
