import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_elevated_button.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class SuccessfullySendReviewWidget extends BaseStatelessWidget {
  final VoidCallback onGoButtonClick;

  SuccessfullySendReviewWidget({
    super.key,
    required this.onGoButtonClick,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            translate(LocalizationKeys.thanks)!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1B1B2F),
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15.h),
          SvgPicture.asset(AppAssetPaths.successIcon),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
            child: Text(
              translate(LocalizationKeys.yourReviewHasBeenSentSuccessfully)!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF1B1B2F),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          AppElevatedButton.withTitle(
              onPressed: () {
                Navigator.of(context).pop();
                onGoButtonClick();
              },
              title: translate(LocalizationKeys.continueForCheckout)!),
        ],
      ),
    );
  }
}
