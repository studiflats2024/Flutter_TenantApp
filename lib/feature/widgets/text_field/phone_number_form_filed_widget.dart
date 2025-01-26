import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class PhoneNumberFormFiledWidget extends BaseStatelessWidget {
  final String title;
  final bool requiredTitle;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final TextStyle? titleStyle;
  final IsoCode? isoCode;
  final PhoneNumber? initialValue;
  final void Function(PhoneNumber?) onSaved;
  final void Function(String?)? onFieldSubmitted;
  final void Function(PhoneNumber?)? onChanged;
  final TextInputAction? textInputAction;
  final PhoneController? controller;
  final bool enable;
  final bool allowEmpty;
  final Color? enableBorderColor;
  final Color? focusColor;
  final FocusNode? focusNode;
  final double radius;
  final AutovalidateMode autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;

  PhoneNumberFormFiledWidget({
    Key? key,
    required this.title,
    this.requiredTitle = true,
    required this.onSaved,
    this.helperText,
    this.titleStyle,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.initialValue,
    this.onFieldSubmitted,
    this.textInputAction,
    this.controller,
    this.focusNode,
    this.enable = true,
    this.isoCode,
    this.enableBorderColor,
    this.focusColor,
    this.inputFormatters,
    this.allowEmpty = false,
    this.radius = 10,
  })  : assert(initialValue == null || controller == null),
        super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
              text: requiredTitle ? title : title,
              children: [
                if(requiredTitle)...[
                   TextSpan(text: " *",style: textTheme.titleMedium?.copyWith(
                      fontSize: FontSize.fontSize14,
                      color: AppColors.appFormFieldErrorIBorder,
                      fontWeight: FontWeight.w600))
                ]
              ],
              style: titleStyle ??
                  textTheme.titleMedium?.copyWith(
                      fontSize: FontSize.fontSize12,
                      color: AppColors.appFormFieldTitle,
                      fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 10),
        Directionality(
          textDirection: TextDirection.ltr,
          child: PhoneFormField(
            controller: controller,
            autovalidateMode: autovalidateMode,
            autofillHints: const [AutofillHints.telephoneNumber],
            countrySelectorNavigator:
                const CountrySelectorNavigator.draggableBottomSheet(),
            defaultCountry: isoCode ?? IsoCode.DE,
            decoration: InputDecoration(
              labelText: labelText,
              helperText: helperText,
              hintText: hintText,
              fillColor: AppColors.appFormFieldFill,
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              hintStyle: textTheme.labelMedium?.copyWith(
                color: AppColors.formFieldHintText,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius),
                borderSide: BorderSide(
                  color:
                      enableBorderColor ?? AppColors.enabledAppFormFieldBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius),
                borderSide: BorderSide(
                  color: focusColor ?? AppColors.formFieldFocusIBorder,
                ),
              ),
              focusColor: focusColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
            enabled: enable,
            countryButtonStyle: CountryButtonStyle(
                textStyle: textTheme.bodyMedium
                    ?.copyWith(color: AppColors.formFieldText),
                flagSize: 20.r,
                showFlag: true,
                showDropdownIcon: false),
            validator: _getValidator(context),
            cursorColor: Theme.of(context).colorScheme.primary,
            onSaved: onSaved,
            onChanged: onChanged,
            textInputAction: textInputAction,
            isCountrySelectionEnabled: true,
            isCountryButtonPersistent: true,
            focusNode: focusNode,
            initialValue: initialValue,
            inputFormatters: inputFormatters,
            onSubmitted: onFieldSubmitted,
            style:
                textTheme.bodyMedium?.copyWith(color: AppColors.formFieldText),
          ),
        ),
      ],
    );
  }

  PhoneNumberInputValidator? _getValidator(BuildContext context) {
    List<PhoneNumberInputValidator> validators = [];

    validators.add(PhoneValidator.validMobile(
        //allowEmpty: allowEmpty,
        context,
        errorText: translate(LocalizationKeys.phoneNumberInvalid)));
    return validators.isNotEmpty ? PhoneValidator.compose(validators) : null;
  }
}
