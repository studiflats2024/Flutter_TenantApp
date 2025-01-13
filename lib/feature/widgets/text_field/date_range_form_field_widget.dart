import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/validations/validator.dart';

// ignore: must_be_immutable
class DateRangeFormFieldWidget extends StatelessWidget {
  final String title;
  final String languageKey;
  final bool requiredTitle;
  final bool withTitle;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final TextStyle? hintTextStyle;
  final int? minStay;
  final DateTimeRange? initialValue;
  final FormFieldSetter<DateTimeRange> onSaved;
  final FormFieldValidator<DateTimeRange>? validator;
  final ValueChanged<DateTimeRange?>? onChangedDate;

  final DateTime? value;
  final DateTime? maximumDate;
  final DateTime? minimumDate;

  const DateRangeFormFieldWidget({
    super.key,
    this.title = "",
    this.withTitle = true,
    this.requiredTitle = true,
    this.hintText,
    this.labelText,
    this.helperText,
    this.initialValue,
    this.value,
    this.minStay,
    required this.onSaved,
    this.languageKey = "en",
    this.validator,
    this.onChangedDate,
    this.maximumDate,
    this.minimumDate,
    this.hintTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (withTitle) ...[
          Text(
            requiredTitle ? title.concatenateAsterisk : title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.appFormFieldTitle,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
        ],
        _DateRangeFormField(
          onSaved: onSaved,
          onChangedDate: onChangedDate,
          initialValue: initialValue,
          hintText: hintText,
          validator: validator,
          minStay: minStay,
          hintTextStyle: hintTextStyle,
          languageKey: languageKey,
          maximumDate: maximumDate,
          minimumDate: minimumDate,
        ),
      ],
    );
  }
}

class _DateRangeFormField extends FormField<DateTimeRange> {
  _DateRangeFormField({
    Key? key,
    FormFieldSetter<DateTimeRange>? onSaved,
    ValueChanged<DateTimeRange>? onChangedDate,
    FormFieldValidator<DateTimeRange>? validator,
    DateTimeRange? initialValue,
    String? hintText,
    TextStyle? hintTextStyle,
    DateTime? maximumDate,
    DateTime? minimumDate,
    int? minStay,
    required String languageKey,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<DateTimeRange> state) {
            return Builder(builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      final DateTimeRange? picked = await showDateRangePicker(
                        builder: (context, Widget? child) => Theme(
                          data: Theme.of(context)
                              .copyWith(
                                  dialogBackgroundColor:
                                      Theme.of(context).dialogBackgroundColor,
                                  appBarTheme: Theme.of(context)
                                      .appBarTheme
                                      .copyWith(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          iconTheme: IconThemeData(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                  colorScheme: Theme.of(context)
                                      .colorScheme
                                      .copyWith(
                                          onPrimary: Colors.white,
                                          primary: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                          child: child!,
                        ),
                        context: state.context,
                        initialDateRange: state.value ?? initialValue,
                        firstDate: minimumDate ?? DateTime.now(),
                        lastDate:
                            maximumDate ?? DateTime((DateTime.now().year + 10)),
                        barrierColor: AppColors.colorPrimary,
                      );

                      if (picked != null && picked != state.value) {
                        state.didChange(picked);
                        if (onChangedDate != null) {
                          onChangedDate(picked);
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: AppColors.appFormFieldFill,
                        border: Border.all(
                            width: .5,
                            color: state.hasError ||
                                    Validator.validateTimeRange(
                                            state.value, minStay: minStay??1) !=
                                        null
                                ? Theme.of(context).colorScheme.error
                                : const Color(0xFFD0D0DD)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(AppAssetPaths.datePicker,
                              colorFilter: const ColorFilter.mode(
                                  AppColors.suffixIcon, BlendMode.srcIn)),
                          const SizedBox(width: 10),
                          Text(
                            state.value != null
                                ? "${AppDateFormat.formattingOnlyMonthDay(state.value!.start, languageKey)}-${AppDateFormat.formattingOnlyMonthDay(state.value!.end, languageKey)}"
                                : hintText ?? "",
                            style: hintTextStyle ??TextStyle(
                              fontSize: 18.0,
                              color: state.value != null
                                  ? null
                                  : AppColors.formFieldHintText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        Validator.validateTimeRange(state.value,minStay: minStay??1) != null,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        Validator.validateTimeRange(state.value,minStay: minStay??1) ?? "",
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: AppColors.appFormFieldErrorIBorder,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: Validator.validateTimeRange(state.value,minStay: minStay??1)== null,
                    child: const SizedBox(height: 8.0),
                  ),
                  state.hasError
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            state.errorText!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12.0,
                            ),
                          ),
                        )
                      : Container(),
                ],
              );
            });
          },
        );
}
