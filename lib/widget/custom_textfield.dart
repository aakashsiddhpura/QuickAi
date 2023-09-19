import 'package:fl_app/res/app_colors.dart';
import 'package:fl_app/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../res/assets_path.dart';
import '../res/strings_utils.dart';

class CustomTextField extends StatelessWidget {
  final bool readOnly;
  final TextEditingController controller;
  final int maxLine;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final Color? textColor;
  final double? fontSize;
  final int? maxLength;
  final double? radius;
  final bool enabled;
  final bool isPassword;
  final FocusNode? focusNode;
  final String? hintText;
  final Color? hintTextColor;
  final double? hintFontSize;
  final FontWeight? hintTextWeight;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Offset? offset;
  final double? spreadRadius;
  final VoidCallback? onTap;
  final Color? enableColor;
  final Color? disabledColor;
  final Color? focusedColor;
  final Color? cursorColor;
  final EdgeInsetsGeometry? contentPadding;
  TextInputAction? textInputAction;
  final Widget? prefixWidget;
  final FormFieldValidator<String>? validator;
  final String? inputFormatter;

  CustomTextField(
      {Key? key,
      this.validator,
      this.spreadRadius,
      this.offset,
      this.onChanged,
      this.disabledColor,
      this.maxLine = 1,
      this.maxLength,
      this.radius,
      this.fontSize,
      this.fillColor,
      this.textColor,
      this.isPassword = false,
      this.enabled = true,
      this.keyboardType = TextInputType.text,
      this.textInputAction,
      this.focusNode,
      this.hintText,
      this.hintTextColor,
      this.hintFontSize,
      this.hintTextWeight,
      this.textAlign,
      this.textAlignVertical,
      this.prefixIcon,
      this.suffixIcon,
      this.onTap,
      this.enableColor,
      this.focusedColor,
      this.cursorColor,
      required this.controller,
      this.contentPadding,
      this.prefixWidget,
      this.readOnly = false,
      this.inputFormatter})
      : super(key: key);

  final ValueNotifier<bool> _isObscure = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius ?? 10),
      child: ValueListenableBuilder(
        valueListenable: _isObscure,
        builder: (context, bool isObscure, _) {
          if (!isPassword) {
            isObscure = false;
          }
          return IntrinsicHeight(
            child: TextFormField(
              readOnly: readOnly,
              validator: validator,
              style: TextStyle(
                color: textColor ?? AppColor.textColor,
                fontSize: fontSize ?? SizeUtils.fSize_14(),
                fontWeight: FontWeight.w400,
              ),
              onTap: onTap,
              obscureText: isObscure,
              obscuringCharacter: '*',
              onChanged: onChanged,
              controller: controller,
              inputFormatters: inputFormattersFun(),
              textInputAction: textInputAction ?? TextInputAction.next,
              maxLines: maxLine,
              maxLength: maxLength,
              keyboardType: keyboardType,
              focusNode: focusNode,
              textAlignVertical: textAlignVertical,
              cursorColor: cursorColor ?? AppColor.textColor35,
              textAlign: textAlign ?? TextAlign.start,
              enabled: enabled,
              decoration: InputDecoration(
                prefix: prefixWidget,
                contentPadding: contentPadding ??
                    EdgeInsets.symmetric(
                      horizontal: SizeUtils.horizontalBlockSize * 6,
                      vertical: SizeUtils.verticalBlockSize * 2,
                    ),
                isDense: true,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon == null && isPassword
                    ? IconButton(
                        splashRadius: 20,
                        icon: isObscure ? SvgPicture.asset(AssetsPath.eyeCloseIc) : SvgPicture.asset(AssetsPath.eyeIc),
                        onPressed: () {
                          _isObscure.value = !isObscure;
                        },
                      )
                    : suffixIcon,
                suffixIconConstraints: BoxConstraints(maxWidth: 60, maxHeight: 60),
                counterText: "",
                hintText: hintText,
                hintStyle: TextStyle(
                  color: hintTextColor ?? AppColor.textColor35,
                  fontSize: hintFontSize ?? SizeUtils.fSize_14(),
                  fontWeight: hintTextWeight ?? FontWeight.w400,
                ),
                filled: true,
                fillColor: fillColor ?? AppColor.white5,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(radius ?? 100),
                  ),
                  borderSide: BorderSide(
                    color: disabledColor ?? Colors.transparent,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(radius ?? 100),
                  ),
                  borderSide: BorderSide(
                    color: enableColor ?? Colors.transparent,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(radius ?? 10),
                  ),
                  borderSide: BorderSide(
                    color: focusedColor ?? Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      radius ?? 100,
                    ),
                  ),
                  borderSide: BorderSide(
                    color: focusedColor ?? Colors.transparent,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      radius ?? 100,
                    ),
                  ),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      radius ?? 100,
                    ),
                  ),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  inputFormattersFun() {
    switch (inputFormatter) {
      case Validate.nameFormat:
        return [
          LengthLimitingTextInputFormatter(35),
          NoLeadingSpaceFormatter(),
          FilteringTextInputFormatter.allow(RegExp("[a-z A-Z á-ú Á-Ú 0-9 .,-]")),
        ];
      case Validate.emailFormat:
        return [
          NoLeadingSpaceFormatter(),
          LowerCaseTextFormatter(),
          FilteringTextInputFormatter.deny(RegExp("[ ]")),
          FilteringTextInputFormatter.allow(RegExp("[a-zá-ú0-9.,-_@]")),
          LengthLimitingTextInputFormatter(50),
        ];
      case Validate.passFormat:
        return [
          LengthLimitingTextInputFormatter(20),
          FilteringTextInputFormatter.deny(RegExp('[ ]')),
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Zá-úÁ-Ú0-9-@\$%&#*]")),
        ];

      default:
        return [
          NoLeadingSpaceFormatter(),
        ];
    }
  }
}

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }

    return newValue;
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(text: newValue.text.toLowerCase(), selection: newValue.selection);
  }
}
