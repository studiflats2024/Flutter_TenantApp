import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class ContactUs extends BaseStatelessWidget {
  final TapGestureRecognizer gestureRecognizer;

  ContactUs(this.gestureRecognizer, {super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: translate(
          LocalizationKeys.needHelp,
        ),
        style:
        const TextStyle(color: AppColors.formFieldHintText),
        children: [
          TextSpan(
            text: translate(LocalizationKeys.contactUs)!,
            recognizer: gestureRecognizer,
            style: const TextStyle(
                color: AppColors.colorPrimary,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
