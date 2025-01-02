import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/format/app_date_format.dart';

// ignore: must_be_immutable
class MonthPickerFormFieldWidget extends BaseStatelessWidget {
  final String title;
  final bool requiredTitle;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final DateTime? initialValue;
  final FormFieldSetter<DateTime> onSaved;
  final FormFieldValidator<DateTime>? validator;
  final ValueChanged<DateTime?>? onChangedDate;

  final DateTime maximumDate;
  final DateTime minimumDate;
  final DateTime? value;

  MonthPickerFormFieldWidget({
    super.key,
    required this.title,
    this.requiredTitle = true,
    this.hintText,
    this.labelText,
    this.helperText,
    this.initialValue,
    this.value,
    required this.onSaved,
    this.validator,
    this.onChangedDate,
    required this.maximumDate,
    required this.minimumDate,
  });

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
        _MonthPickerFormField(
          onSaved: onSaved,
          initialValue: initialValue,
          helperText: helperText,
          hintText: hintText,
          labelText: labelText,
          validator: validator,
          local: appLocale.locale.languageCode,
          maximumDate: maximumDate,
          minimumDate: minimumDate,
          onChangedDate: onChangedDate,
          value: value,
        ),
      ],
    );
  }
}

class _MonthPickerFormField extends FormField<DateTime> {
  final ValueChanged<DateTime?>? onChangedDate;
  _MonthPickerFormField({
    Key? key,
    DateTime? initialValue,
    DateTime? value,
    required FormFieldSetter<DateTime> onSaved,
    FormFieldValidator<DateTime>? validator,
    required DateTime maximumDate,
    required DateTime minimumDate,
    this.onChangedDate,
    String? hintText,
    String? labelText,
    String? helperText,
    String? local,
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          builder: (FormFieldState<DateTime> state) {
            final selectedDate = state.value ?? initialValue;

            return GestureDetector(
              onTap: () async {
                DateTime? pickedDate;
                // if (Theme.of(state.context).platform == TargetPlatform.iOS) {
                await showModalBottomSheet(
                  context: state.context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 200.h,
                      child: CupertinoDatePicker(
                        initialDateTime: selectedDate,
                        mode: CupertinoDatePickerMode.monthYear,
                        minimumDate: minimumDate,
                        maximumDate: maximumDate,
                        onDateTimeChanged: (DateTime newDate) {
                          pickedDate = newDate;
                        },
                      ),
                    );
                  },
                );
                // } else {
                //   pickedDate = await showDatePicker(
                //     context: state.context,
                //     initialDate: selectedDate ?? DateTime.now(),
                //     initialDatePickerMode: DatePickerMode.year,
                //     firstDate: minimumDate,
                //     lastDate: maximumDate,
                //   );
                // }

                if (pickedDate != null && pickedDate != selectedDate) {
                  state.didChange(
                      DateTime(pickedDate!.year, pickedDate!.month, 1));
                  if (onChangedDate != null) {
                    onChangedDate(pickedDate);
                  }
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  errorText: state.errorText,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: labelText,
                  helperText: helperText,
                  hintText: hintText,
                  fillColor: AppColors.appFormFieldFill,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  hintStyle:
                      Theme.of(state.context).textTheme.labelMedium?.copyWith(
                            color: AppColors.formFieldHintText,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.enabledAppFormFieldBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.formFieldFocusIBorder,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  state.value != null
                      ? AppDateFormat.formattingDateToMonth(
                          state.value!, local ?? "en")
                      : hintText ?? "",
                  style: state.value == null
                      ? Theme.of(state.context).textTheme.labelMedium?.copyWith(
                            color: AppColors.formFieldHintText,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          )
                      : Theme.of(state.context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.formFieldText),
                ),
              ),
            );
          },
        );
}
