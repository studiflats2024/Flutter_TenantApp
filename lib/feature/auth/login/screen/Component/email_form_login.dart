import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_text_button.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class LoginEmailForm extends BaseStatelessWidget {
  final GlobalKey<FormState> loginFormKey;
  final String? initialPassword , initialEmail;
  final Function(String? value) emailSaved;
  final Function(String? value) passwordSaved;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? passwordValidator;
  final Function() forgotPasswordClicked;
  final Function() loginClicked;
  final AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  LoginEmailForm({super.key,
    required this.loginFormKey,
    required this.initialEmail,
    required this.initialPassword,
    required this.emailSaved,
    required this.passwordSaved,
    required this.emailValidator,
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
            AppTextFormField(
              title: translate(LocalizationKeys.email)!,
              hintText: translate(LocalizationKeys.enterYourEmail),
              onSaved: emailSaved,
              obscure: false,
              textInputAction: TextInputAction.next,
              initialValue: initialEmail,
              validator: emailValidator,
              autofillHints: const [AutofillHints.email],
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
