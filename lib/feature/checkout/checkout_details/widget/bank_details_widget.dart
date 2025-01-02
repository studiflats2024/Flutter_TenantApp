import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/apis/models/checkout/bank_details_model.dart';
import 'package:vivas/apis/models/checkout/post_bank_details_send_model.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/widgets/app_buttons/app_text_button.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class BankDetailsFormWidget extends BaseStatefulWidget {
  final void Function(GlobalKey<FormState>,BankDetailsModel?) onConfirmBankDetails;

  const BankDetailsFormWidget({required this.onConfirmBankDetails, super.key});

  @override
  BaseState<BaseStatefulWidget> baseCreateState() =>
      _BankDetailsFormWidgetState();
}

class _BankDetailsFormWidgetState extends BaseState<BankDetailsFormWidget>
    with AuthValidate {
  String? _accountHolderName = "";
  String? _accountNumber = "";
  String? _iban = "";
  String? _swiftCode = "";

  GlobalKey<FormState> editFormKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  @override
  Widget baseBuild(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.0.h),
      child: Form(
        key: editFormKey,
        autovalidateMode: autoValidateMode,
        child: AutofillGroup(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              AppTextFormField(
                title: translate(LocalizationKeys.accountHolderName)!,
                requiredTitle: false,
                hintText: translate(LocalizationKeys.enterName),
                onSaved: _accountHolderNameSaved,
                onChanged: _accountHolderNameSaved,
                textInputAction: TextInputAction.next,
                validator: textValidator,
                textInputType: TextInputType.name,
                autofillHints: const [AutofillHints.name],
              ),
              SizedBox(height: 24.h),
              AppTextFormField(
                title: translate(LocalizationKeys.accountNumber)!,
                requiredTitle: false,
                hintText: translate(LocalizationKeys.enterAccountNumber),
                onSaved: _accountNumberSaved,
                onChanged: _accountNumberSaved,
                textInputAction: TextInputAction.next,
                validator: textValidator,
                textInputType: TextInputType.number,
              ),
              SizedBox(height: 24.h),
              AppTextFormField(
                title: translate(LocalizationKeys.iban)!,
                requiredTitle: false,
                hintText: translate(LocalizationKeys.enterYourIban),
                onSaved: _ibanSaved,
                onChanged: _ibanSaved,
                textInputAction: TextInputAction.next,
                validator: textValidator,
                textInputType: TextInputType.number,
              ),
              SizedBox(height: 24.h),
              AppTextFormField(
                title: translate(LocalizationKeys.swiftCode)!,
                requiredTitle: false,
                hintText: translate(LocalizationKeys.enterYourSwiftCode),
                onSaved: _swiftCodeSaved,
                onChanged: _swiftCodeSaved,
                textInputAction: TextInputAction.done,
                validator: textValidator,
                textInputType: TextInputType.text,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: AppColors.appCancelButtonBackground,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: AppTextButton(
                        onPressed: () => {Navigator.pop(context)},
                        child: Text(
                          translate(LocalizationKeys.cancel)!,
                          style: themeData.textTheme.labelMedium?.copyWith(
                              color: AppColors.appCancelButton,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: AppColors.colorPrimary,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: AppTextButton(
                        onPressed: () => _onConfirmClicked(),
                        child: Text(
                          translate(LocalizationKeys.confirm)!,
                          style: themeData.textTheme.labelMedium?.copyWith(
                              color: AppColors.appSecondButton,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _accountHolderNameSaved(String? value) {
    _accountHolderName = value!;
  }

  void _accountNumberSaved(String? value) {
    _accountNumber = value!;
  }

  void _ibanSaved(String? value) {
    _iban = value!;
  }

  void _swiftCodeSaved(String? value) {
    _swiftCode = value!;
  }

  void _onConfirmClicked() {
    widget.onConfirmBankDetails(editFormKey,
        BankDetailsModel(_accountHolderName, _accountNumber, _iban, _swiftCode)
    );
  }
}
