import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/res/app_colors.dart';

class TextApp extends BaseStatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? color;
  final double? fontSize;
  final double? lineHeight;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;
  final bool multiLang;

  TextApp({
    this.multiLang = false,
    required this.text,
    this.color,
    this.textAlign,
    this.overflow,
    this.fontWeight,
    this.style,
    this.fontSize,
    this.lineHeight,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Text(
      multiLang ? translate(text)! : text,
      overflow: overflow,
      textAlign: textAlign,
      style: style ??
          textTheme.titleMedium?.copyWith(
            color: color ?? AppColors.formFieldText,
            fontWeight: fontWeight ?? FontWeight.w500,
            fontSize: fontSize ?? 16.sp,
            height: lineHeight,
          ),
    );
  }
}
