import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/themer.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vivas/utils/extensions/extension_string.dart';

class AppTextFormField extends StatefulWidget {
  final String? title;
  final bool requiredTitle;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? initialValue;
  final double radius;
  final bool obscure;
  final bool showObscure;
  final bool enable;
  final bool readOnly;
  final void Function(String?) onSaved;
  final void Function(String?)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final int maxLines;
  final int? maxLength;
  final String? customCounterText;
  final Color? enableBorderColor;
  final Color? focusColor;
  final FocusNode? focusNode;
  final IconData? suffixIcon;
  final Function()? onTapSuffixIcon;
  final Iterable<String>? autofillHints;
  final TextStyle? titleStyle;
  final TextStyle? hintStyle;
  final Widget? label;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextFormField({
    Key? key,
    this.title,
    this.requiredTitle = true,
    required this.hintText,
    required this.onSaved,
    this.helperText,
    this.labelText,
    this.onChanged,
    this.initialValue,
    this.onFieldSubmitted,
    this.textInputAction,
    this.obscure = false,
    this.showObscure = false,
    this.enable = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.textInputType,
    this.validator,
    this.controller,
    this.inputFormatters,
    this.customCounterText,
    this.enableBorderColor,
    this.focusColor,
    this.focusNode,
    this.suffixIcon,
    this.onTapSuffixIcon,
    this.autofillHints,
    this.titleStyle,
    this.hintStyle,
    this.radius = 10,
    this.label,
  })  : assert(initialValue == null || controller == null),
        super(key: key);

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> with Themer {
  bool obscure = true;
  bool setObscure = false;

  @override
  Widget build(BuildContext context) {
    initThemer(context);
    if (!setObscure) {
      obscure = widget.obscure;
      setObscure = true;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != null
            ? widget.label ?? Container()
            : Text(
                widget.requiredTitle
                    ? widget.title?.concatenateAsterisk ?? ""
                    : widget.title ?? "",
                style: widget.titleStyle ??
                    const TextStyle(
                      fontSize: 14,
                      color: AppColors.appFormFieldTitle,
                      fontWeight: FontWeight.w500,
                    ),
              ),
        const SizedBox(height: 10),
        TextFormField(
          enabled: widget.enable,
          readOnly: widget.readOnly,
          initialValue: widget.initialValue,
          obscureText: obscure,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.formFieldText),
          controller: widget.controller,
          autofillHints: widget.autofillHints,
          inputFormatters: widget.inputFormatters,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: widget.labelText,
            helperText: widget.helperText,
            counterText: widget.customCounterText,
            hintText: widget.hintText,
            fillColor: AppColors.appFormFieldFill,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            hintStyle: widget.hintStyle ??
                textTheme.labelMedium?.copyWith(
                  color: AppColors.formFieldHintText,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide(
                color: widget.enableBorderColor ??
                    AppColors.enabledAppFormFieldBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide(
                color: widget.focusColor ?? AppColors.formFieldFocusIBorder,
              ),
            ),
            focusColor: widget.focusColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
            ),
            suffixIcon: widget.obscure
                ? GestureDetector(
                    child: Icon(
                      // Based on passwordVisible state choose the icon
                      obscure ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.suffixIcon,
                    ),
                    onTap: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                  )
                : widget.suffixIcon != null && widget.onTapSuffixIcon != null
                    ? IconButton(
                        onPressed: widget.onTapSuffixIcon,
                        icon: Icon(widget.suffixIcon,
                            color: AppColors.suffixIcon, size: 15),
                      )
                    : widget.suffixIcon != null
                        ? Padding(
                            padding: const EdgeInsetsDirectional.only(end: 30),
                            child: Icon(widget.suffixIcon,
                                color: AppColors.suffixIcon, size: 15, ),
                          )
                        : null,
          ),
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          onSaved: widget.onSaved,
          validator: widget.validator,
          maxLines: widget.maxLines,
          textInputAction: widget.textInputAction,
          keyboardType: widget.textInputType,
          maxLength: widget.maxLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ],
    );
  }
}
