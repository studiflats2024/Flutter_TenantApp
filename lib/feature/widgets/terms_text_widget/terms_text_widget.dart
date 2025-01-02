import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/app_pages/screen/privacy_privacy_screen.dart';
import 'package:vivas/feature/app_pages/screen/terms_conditions_screen.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class TermsTextWidget extends BaseStatelessWidget {
  TermsTextWidget({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    TextStyle defaultStyle =
        const TextStyle(color: Colors.grey, fontSize: 14.0);
    TextStyle linkStyle = const TextStyle(color: AppColors.colorPrimary);
    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          TextSpan(
              text:
                  "${translate(LocalizationKeys.byClickOnContinueIAgreeToVivasApartments)}  "),
          TextSpan(
              text: "${translate(LocalizationKeys.termsOfService)} ,",
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () => _termsOfServiceClicked(context)),
          TextSpan(
              text: "${translate(LocalizationKeys.paymentsTermsOfService)}  ",
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = _paymentsTermsOfServiceClicked),
          TextSpan(text: "${translate(LocalizationKeys.and)}  "),
          TextSpan(
            text: "${translate(LocalizationKeys.privacyPolicy)} ",
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () => _privacyPolicyClicked(context),
          ),
        ],
      ),
    );
  }

  void _termsOfServiceClicked(BuildContext context) {
    TermsConditionsScreen.open(context);
  }

  void _paymentsTermsOfServiceClicked() {}

  void _privacyPolicyClicked(BuildContext context) {
    PrivacyPrivacyScreen.open(context);
  }
}
