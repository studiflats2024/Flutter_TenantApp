import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/extensions/extension_string.dart';

// ignore: must_be_immutable
class TimePickerFormFieldWidget extends BaseStatelessWidget {
  final String title;
  final bool requiredTitle;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final TimeOfDay? initialValue;
  final FormFieldSetter<TimeOfDay> onSaved;
  final FormFieldValidator<TimeOfDay>? validator;
  final ValueChanged<TimeOfDay?>? onChangedDate;

  final TimeOfDay? value;

  TimePickerFormFieldWidget({
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
        _TimeSelectionFormField(
          onSaved: onSaved,
          initialValue: initialValue,
          hintText: hintText,
          validator: validator,
        ),
      ],
    );
  }
}

class _TimeSelectionFormField extends FormField<TimeOfDay> {
  _TimeSelectionFormField({
    Key? key,
    FormFieldSetter<TimeOfDay>? onSaved,
    FormFieldValidator<TimeOfDay>? validator,
    TimeOfDay? initialValue,
    String? hintText,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<TimeOfDay> state) {
            return Builder(builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: state.context,
                        initialTime: state.value ?? TimeOfDay.now(),
                      );

                      if (picked != null && picked != state.value) {
                        state.didChange(picked);
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
                              state.value?.format(state.context) ??
                                  hintText ??
                                  "",
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            SvgPicture.asset(AppAssetPaths.timeIcon,
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
