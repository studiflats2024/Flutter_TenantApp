import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/res/app_asset_paths.dart';

import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class SuccessfullyCancelRequestWidget extends BaseStatelessWidget {
  SuccessfullyCancelRequestWidget({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 10.h),
        Text(
          translate(LocalizationKeys.done)!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF0F1728),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        SvgPicture.asset(AppAssetPaths.successIcon),
        SizedBox(height: 20.h),
        Text(
          translate(LocalizationKeys.yourCancellationRequestHasBeenSubmitted)!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF344053),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 20),
        AppElevatedButton.withTitle(
            onPressed: () => _goBackClicked(context),
            title: translate(LocalizationKeys.goBack)!),
      ],
    );
  }

  void _goBackClicked(BuildContext context) {
    Navigator.of(context).pop();
  }
}
