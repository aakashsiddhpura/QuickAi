import 'package:fl_app/res/app_colors.dart';
import 'package:flutter/material.dart';

import '../utils/size_utils.dart';

class CustomButton extends StatelessWidget {
  double? width;

  final double? height;
  final ButtonStyle? style;
  final void Function()? onPressed;
  final String? text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? textColor;
  bool? bordered = false;
  final Color? buttonColor;
  final Color? borderColor;
  final double? radius;
  final Gradient? gradient;
  final TextStyle? textStyle;
  final List<BoxShadow>? buttonShadow;
  final String? buttonIcon;
  final double? iconSize;

  CustomButton({Key? key, this.buttonShadow, this.width, this.height, this.style, required this.onPressed, required this.text, this.fontWeight, this.fontSize, this.textColor, this.buttonColor, this.bordered, this.borderColor, this.gradient, this.radius, this.textStyle, this.buttonIcon, this.iconSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(50.0),
      elevation: 4.0,
      surfaceTintColor: Colors.black,
      shadowColor: Colors.red,
      color: Colors.yellow,
      borderOnForeground: false,
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(1.00, -0.04),
            end: Alignment(-1, 0.04),
            colors: [
              Color(0xFF231C8E),
              Color(0xFF7268EE),
            ],
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(50.0),
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.all(5),
            constraints: BoxConstraints(minWidth: width ?? SizeUtils.horizontalBlockSize * 70, maxWidth: width ?? SizeUtils.horizontalBlockSize * 70, maxHeight: height ?? SizeUtils.horizontalBlockSize * 15),
            height: height ?? SizeUtils.horizontalBlockSize * 15,
            decoration: BoxDecoration(
              color: buttonColor ?? Colors.transparent,
              borderRadius: BorderRadius.circular(radius ?? 50),
            ),
            child: Center(
              child: Text(
                text ?? "",
                textAlign: TextAlign.center,
                style: textStyle ?? TextStyle(fontWeight: fontWeight ?? FontWeight.w600, fontSize: fontSize ?? SizeUtils.fSize_16(), color: textColor ?? AppColor.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
