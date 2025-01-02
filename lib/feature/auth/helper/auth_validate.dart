import 'package:flutter/material.dart';
import 'package:vivas/_core/translator.dart';
import 'package:vivas/feature/widgets/text_field/country_picker_form_field_widget.dart';
import 'package:vivas/feature/widgets/text_field/custom_drop_down_form_filed_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/validations/validator.dart';

mixin AuthValidate on Translator {
  String? emailOrPhoneNumberValidator(String? value) {
    ValidationState validationState =
        Validator.validateEmailOrPhoneNumber(value);
    switch (validationState) {
      case ValidationState.empty:
        return translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return translate(LocalizationKeys.enterPhoneNumberInvalid);
      case ValidationState.valid:
        return null;
    }
  }

  String? emailValidator(String? value) {
    ValidationState validationState = Validator.validateEmail(value);
    switch (validationState) {
      case ValidationState.empty:
        return translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return translate(LocalizationKeys.emailInvalid);
      case ValidationState.valid:
        return null;
    }
  }

  String? confirmPasswordValidator(String? value, String password) {
    ValidationState validationState =
        Validator.validateTextWithText(value, password);
    switch (validationState) {
      case ValidationState.empty:
        return translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return translate(LocalizationKeys.passMatch);
      case ValidationState.valid:
        return null;
    }
  }

  String? passwordValidator(String? value) {
    ValidationState validationState = Validator.validatePassword(value);
    switch (validationState) {
      case ValidationState.empty:
        return translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return translate(LocalizationKeys.passInvalid);
      case ValidationState.valid:
        return null;
    }
  }

  String? fullNameValidator(String? value) {
    ValidationState validationState = Validator.validateText(value);
    switch (validationState) {
      case ValidationState.empty:
      case ValidationState.formatting:
        return translate(LocalizationKeys.required);
      case ValidationState.valid:
        return null;
    }
  }

  String? textValidator(String? value) {
    ValidationState validationState = Validator.validateText(value);
    switch (validationState) {
      case ValidationState.empty:
      case ValidationState.formatting:
        return translate(LocalizationKeys.required);
      case ValidationState.valid:
        return null;
    }
  }

  String? textOpticalValidator(String? value) {
    ValidationState validationState = Validator.validateText(value);
    switch (validationState) {
      case ValidationState.formatting:
        return translate(LocalizationKeys.required);
      case ValidationState.empty:
      case ValidationState.valid:
        return null;
    }
  }

  String? otpValidator(String? value) {
    ValidationState validationState =
        Validator.validateNumber(value, length: 4);
    switch (validationState) {
      case ValidationState.empty:
        return translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return translate(LocalizationKeys.checkOtpCode);
      case ValidationState.valid:
        return null;
    }
  }

  String? countryPickerValidator(CountryPickerWidgetItem? value) {
    ValidationState validationState = Validator.validateText(value?.key);
    switch (validationState) {
      case ValidationState.empty:
      case ValidationState.formatting:
        return translate(LocalizationKeys.required);
      case ValidationState.valid:
        return null;
    }
  }

  String? customDropDownItemValidator(CustomDropDownItem? value) {
    ValidationState validationState = Validator.validateText(value?.key);
    switch (validationState) {
      case ValidationState.empty:
      case ValidationState.formatting:
        return translate(LocalizationKeys.required);
      case ValidationState.valid:
        return null;
    }
  }

  String? dateTimeValidator(DateTime? value) {
    ValidationState validationState = Validator.validateDateTime(value);
    switch (validationState) {
      case ValidationState.empty:
      case ValidationState.formatting:
        return translate(LocalizationKeys.required);
      case ValidationState.valid:
        return null;
    }
  }

  String? timeValidator(TimeOfDay? value) {
    ValidationState validationState = Validator.validateTimeOfDay(value);
    switch (validationState) {
      case ValidationState.empty:
      case ValidationState.formatting:
        return translate(LocalizationKeys.required);
      case ValidationState.valid:
        return null;
    }
  }
}
