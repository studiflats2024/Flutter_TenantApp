import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:textfield_datepicker/textfield_datepicker.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/format/app_date_format.dart';

// ignore: must_be_immutable
class DatePickerFormFiledWidget extends BaseStatelessWidget {
  final String title;
  final bool requiredTitle;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final DateTime? initialValue;
  final DateTime maximumDate;
  final DateTime minimumDate;
  final DateTime? startDate;

  final double radius;

  final void Function(DateTime?) onSaved;
  final void Function(DateTime?)? onFieldSubmitted;
  final String? Function(DateTime?)? validator;

  final TextEditingController? controller;

  final Color? enableBorderColor;
  final Color? focusColor;
  final FocusNode? focusNode;

  DatePickerFormFiledWidget({
    Key? key,
    required this.title,
    required this.maximumDate,
    required this.minimumDate,
    this.startDate,
    this.requiredTitle = true,
    required this.hintText,
    required this.onSaved,
    this.helperText,
    this.labelText,
    this.initialValue,
    this.onFieldSubmitted,
    this.validator,
    this.controller,
    this.enableBorderColor,
    this.focusColor,
    this.focusNode,
    this.radius = 10,
  }) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          requiredTitle ? title.concatenateAsterisk : title,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.appFormFieldTitle,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        TextfieldDatePicker(
          focusNode: focusNode,
          cupertinoDatePickerBackgroundColor: AppColors.appFormFieldFill,
          cupertinoDateInitialDateTime:
              initialValue ?? startDate ?? minimumDate,
          materialDatePickerInitialDate:
              initialValue ?? startDate ?? minimumDate,
          cupertinoDatePickerMaximumDate: maximumDate,
          cupertinoDatePickerMaximumYear: maximumDate.year,
          materialDatePickerLastDate: maximumDate,
          cupertinoDatePickerMinimumYear: minimumDate.year,
          cupertinoDatePickerMinimumDate: minimumDate,
          materialDatePickerFirstDate: minimumDate,
          preferredDateFormat:
              AppDateFormat.appDatePickerFormat(appLocale.locale.languageCode),
          textfieldDatePickerController: controller ?? TextEditingController(),
          style: textTheme.bodyMedium?.copyWith(color: AppColors.formFieldText),
          onSaved: (value) => onSaved(AppDateFormat.appDatePickerParse(
              value!, appLocale.locale.languageCode)),
          onFieldSubmitted: (value) => onFieldSubmitted == null
              ? null
              : onFieldSubmitted!(AppDateFormat.appDatePickerParse(
                  value, appLocale.locale.languageCode)),
          validator: (value) => validator == null
              ? null
              : validator!(AppDateFormat.appDatePickerParse(
                  value!, appLocale.locale.languageCode)),
          textfieldDatePickerMargin: EdgeInsets.zero,
          textfieldDatePickerPadding: EdgeInsets.zero,
          textfieldDatePickerWidth: double.infinity,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: labelText,
            helperText: helperText,
            hintText: hintText,
            hintStyle: textTheme.labelMedium?.copyWith(
              color: AppColors.formFieldHintText,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            fillColor: AppColors.appFormFieldFill,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(
                color: enableBorderColor ?? AppColors.enabledAppFormFieldBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(
                color: focusColor ?? AppColors.formFieldFocusIBorder,
              ),
            ),
            focusColor: focusColor,
            suffixIconConstraints:
                BoxConstraints(maxHeight: 24.h, maxWidth: 50.w),
            suffixIcon: Padding(
              padding: EdgeInsetsDirectional.only(end: 14.w),
              child: SvgPicture.asset(AppAssetPaths.datePicker,
                  colorFilter: const ColorFilter.mode(
                      AppColors.suffixIcon, BlendMode.srcIn)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        ),
      ],
    );
  }
}
