import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/format/app_date_format.dart';

// ignore: must_be_immutable
class DateTimeFormFieldWidget extends StatelessWidget {
  final String title;
  final String languageKey;
  final bool requiredTitle;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final DateTime? initialValue;
  final FormFieldSetter<DateTime> onSaved;
  final FormFieldValidator<DateTime>? validator;
  final ValueChanged<DateTime?>? onChangedDate;

  final DateTime? value;
  final DateTime? maximumDate;
  final DateTime? minimumDate;
  final bool showFullDay;

  const DateTimeFormFieldWidget({
    super.key,
    required this.title,
    this.requiredTitle = true,
    this.hintText,
    this.labelText,
    this.helperText,
    this.initialValue,
    this.value,
    required this.onSaved,
    this.languageKey = "en",
    this.validator,
    this.onChangedDate,
    this.maximumDate,
    this.minimumDate,
    this.showFullDay = false,
  });

  @override
  Widget build(BuildContext context) {
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
        _DateSelectionFormField(
          onSaved: onSaved,
          initialValue: initialValue,
          hintText: hintText,
          validator: validator,
          languageKey: languageKey,
          maximumDate: maximumDate,
          minimumDate: minimumDate,
          showFullDay: showFullDay,
        ),
      ],
    );
  }
}

class _DateSelectionFormField extends FormField<DateTime> {
  _DateSelectionFormField({
    Key? key,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
    DateTime? initialValue,
    String? hintText,
    DateTime? maximumDate,
    DateTime? minimumDate,
    required String languageKey,
    required bool showFullDay,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<DateTime> state) {
            return Builder(builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      if (Platform.isAndroid) {
                        final DateTime? picked = await showDatePicker(
                          context: state.context,
                          initialDate:
                              state.value ?? initialValue ?? DateTime.now(),
                          firstDate: minimumDate ?? DateTime.now(),
                          lastDate: maximumDate ??
                              DateTime((DateTime.now().year + 10)),
                        );

                        if (picked != null && picked != state.value) {
                          state.didChange(picked);
                        }
                      }
                      if (Platform.isIOS) {
                        // ignore: use_build_context_synchronously
                        await showCupertinoModalPopup<void>(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder: (BuildContext context) => Container(
                            height: 216,
                            padding: const EdgeInsets.only(top: 6.0),
                            // The Bottom margin is provided to align the popup above the system
                            // navigation bar.
                            margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            // Provide a background color for the popup.
                            color: CupertinoColors.systemBackground
                                .resolveFrom(context),
                            // Use a SafeArea widget to avoid system overlaps.
                            child: SafeArea(
                              top: false,
                              child: CupertinoDatePicker(
                                initialDateTime: state.value ??
                                    initialValue ??
                                    DateTime.now(),
                                mode: CupertinoDatePickerMode.date,
                                use24hFormat: true,
                                maximumDate: maximumDate,
                                minimumDate: minimumDate,
                                // This shows day of week alongside day of month
                                showDayOfWeek: true,
                                // This is called when the user changes the date.
                                onDateTimeChanged: (DateTime picked) {
                                  state.didChange(picked);
                                },
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.appFormFieldFill,
                        border: Border.all(
                            color: state.hasError
                                ? Theme.of(context).colorScheme.error
                                : AppColors.enabledAppFormFieldBorder),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.value != null
                                  ? showFullDay
                                      ? AppDateFormat.formattingDate(
                                          state.value!, languageKey)
                                      : AppDateFormat.formattingOnlyMonthDay(
                                          state.value!, languageKey)
                                  : hintText ?? "",
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            SvgPicture.asset(AppAssetPaths.datePicker,
                                colorFilter: const ColorFilter.mode(
                                    AppColors.suffixIcon, BlendMode.srcIn)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
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
