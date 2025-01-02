import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/widgets/text_field/auto_complete_form_field.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class AppAutoCompleteFormField<T> extends BaseStatelessWidget {
  final String? hintText;
  final TextStyle? hintTextStyle;
  final String? labelText;
  final void Function(T?)? onSaved;
  final void Function(T?)? onFieldSubmitted;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final T? initialValue;
  final List<T> itemList;
  final Widget Function(BuildContext, T?) itemBuilder;
  final T? Function(String)? itemFromString;
  final String Function(T?)? itemToString;
  final Future<List<T?>> Function(String) onSearch;
  final Color? enableBorderColor;

  AppAutoCompleteFormField({
    this.hintText,
    this.hintTextStyle,
    this.labelText,
    this.onSaved,
    this.onFieldSubmitted,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.itemFromString,
    this.itemToString,
    required this.itemList,
    required this.itemBuilder,
    required this.onSearch,
    this.enableBorderColor,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return AutocompleteFormField<T>(
      // autofocus: true,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        fillColor: AppColors.appFormFieldFill,
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        hintStyle:
            hintTextStyle ?? textTheme.labelMedium!.copyWith(fontSize: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: enableBorderColor ?? AppColors.enabledAppFormFieldBorder,
              width: 2),
        ),
        errorBorder: textFormFieldErrorBorder,
        focusedErrorBorder: textFormFieldFocusErrorBorder,
        focusedBorder: textFormFieldFocusBorder,
        border: const OutlineInputBorder(),
      ),
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      initialValue: initialValue,
      maxSuggestions: itemList.length,
      itemToString: itemToString ?? (item) => item.toString(),
      itemBuilder: itemBuilder,
      onSearch: onSearch,
      itemFromString: itemFromString ??
          (string) {
            final matches = itemList
                .where((area) => area.toString() == string.toLowerCase());
            return matches.isEmpty ? null : matches.first;
          },
      onChanged: onChanged,
    );
  }

  OutlineInputBorder get textFormFieldErrorBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.appFormFieldErrorIBorder),
      );

  OutlineInputBorder get textFormFieldFocusBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: AppColors.formFieldFocusIBorder, width: 2),
      );

  OutlineInputBorder get textFormFieldFocusErrorBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
            color: AppColors.appFormFieldErrorIBorder, width: 2),
      );
}
