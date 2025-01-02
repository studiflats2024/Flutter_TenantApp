import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_text_button.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/phone_number_form_filed_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class LoginPhoneForm extends BaseStatelessWidget {
  final GlobalKey<FormState> loginFormKey;
  final PhoneNumber? initialPhoneNumber;
  final String? initialPassword;
  final Function(PhoneNumber? value) phoneNumberSaved;
  final Function(String? value) passwordSaved;
  final String? Function(String?)? passwordValidator;
  final Function() forgotPasswordClicked;
  final Function() loginClicked;
  final AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  LoginPhoneForm({super.key,
    required this.loginFormKey,
    required this.initialPassword,
    required this.initialPhoneNumber,
    required this.phoneNumberSaved,
    required this.passwordSaved,
    required this.passwordValidator,
    required this.forgotPasswordClicked,
    required this.loginClicked,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Form(
      key: loginFormKey,
      autovalidateMode: autovalidateMode,
      child: AutofillGroup(
        child: Column(
          children: [
            PhoneNumberFormFiledWidget(
              title: translate(LocalizationKeys.whatsAppNumber)!,
              hintText: "ex.1234567890",
              autovalidateMode: autovalidateMode,
              onSaved: phoneNumberSaved,
              initialValue: initialPhoneNumber,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            AppTextFormField(
              title: translate(LocalizationKeys.password)!,
              hintText: translate(LocalizationKeys.enterPassword),
              onSaved: passwordSaved,
              obscure: true,
              textInputAction: TextInputAction.done,
              initialValue: initialPassword,
              validator: passwordValidator,
              onFieldSubmitted: (_) => loginClicked(),
              autofillHints: const [AutofillHints.password],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppTextButton.withTitle(
                    onPressed: forgotPasswordClicked,
                    padding: EdgeInsets.zero,
                    title: translate(LocalizationKeys.forgotPassword)!),
              ],
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
