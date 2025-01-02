import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/utils/extensions/extension_string.dart';

class SubmitButtonWidget extends StatelessWidget {
  final String title;
  final String? hint;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onClicked;
  final bool withoutShape;
  final bool withoutCustomShape;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final Color? buttonColor;

  const SubmitButtonWidget(
      {super.key,
      required this.title,
      this.hint,
      required this.onClicked,
      this.padding,
      this.fontSize,
      this.titleStyle,
      this.backgroundColor,
      this.buttonColor,
      this.withoutShape = false,
      this.withoutCustomShape = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
      decoration: withoutShape
          ? withoutCustomShape
              ? null
              : BoxDecoration(
                  color:backgroundColor?? Colors.white,
                  border: Border.all(color: const Color(0xff798CA4)))
          : const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 40,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...!hint.isNullOrEmpty
              ? [
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      hint!,
                      style:  TextStyle(
                        color: const Color(0xFF667084),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ]
              : [const SizedBox(height: 24)],
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: AppElevatedButton(
              label: Text(
                title,
                textAlign: TextAlign.center,
                style: titleStyle ??
                    TextStyle(
                      color: Colors.white,
                      fontSize: fontSize ?? 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              color: buttonColor,
              onPressed: onClicked,
            ),
          ),
           SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
