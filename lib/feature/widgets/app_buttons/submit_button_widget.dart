import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/size_manager.dart';

class SubmitButtonWidget extends StatelessWidget {
  final String title;
  final Widget? child;
  final String? hint;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onClicked;
  final bool withoutShape;
  final bool withoutCustomShape;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final Color? buttonColor;
  final Decoration? decoration;
  final OutlinedBorder? outlinedBorder;
  final double? sizeTop;
  final double? sizeBottom;
  final List<BoxShadow>? shadows;

  const SubmitButtonWidget(
      {super.key,
      required this.title,
      this.hint,
      required this.onClicked,
      this.padding,
      this.margin,
      this.fontSize,
      this.titleStyle,
      this.backgroundColor,
      this.buttonColor,
      this.decoration,
      this.outlinedBorder,
      this.sizeTop,
      this.sizeBottom,
      this.shadows,
        this.child,
      this.withoutShape = false,
      this.withoutCustomShape = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
      margin: margin,
      decoration: withoutShape
          ? withoutCustomShape
              ? decoration
              : BoxDecoration(
                  color: backgroundColor ?? Colors.white,
                  border: Border.all(color: const Color(0xff798CA4)))
          :  ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeManager.sizeSp20),
                  topRight: Radius.circular(SizeManager.sizeSp20),
                ),
              ),
              shadows:shadows?? [
                const BoxShadow(
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
                      style: TextStyle(
                        color: const Color(0xFF667084),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ]
              : sizeTop != null
                  ? [SizedBox(height: sizeTop)]
                  : [const SizedBox(height: 24)],
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: AppElevatedButton(
              label: child?? Text(
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
              shape: outlinedBorder,
              onPressed: onClicked,
            ),
          ),
          sizeBottom != null
              ? SizedBox(height: sizeBottom)
              : SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
