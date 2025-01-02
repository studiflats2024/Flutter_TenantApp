import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_dialog_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

Future<void> showCheckOutAlertDialog({
  required BuildContext context,
  String? title,
  String? buttonTitle,
  required String description,
  required VoidCallback onGoBackClicked,
}) async {
  var widget = CheckoutBottomSheetWidget(
      description: description, onGoBackClick: onGoBackClicked);
  await showAppDialog(
    context: context,
    dialogWidget: widget,
    shouldPop: true,
  );
}

// ignore: must_be_immutable
class CheckoutBottomSheetWidget extends BaseStatelessWidget {
  final String description;
  final VoidCallback onGoBackClick;

  CheckoutBottomSheetWidget({
    super.key,
    required this.description,
    required this.onGoBackClick,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              translate(LocalizationKeys.done)!,
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
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                description,
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
                  onGoBackClick;
                },
                title: translate(LocalizationKeys.goBack)!),
          ],
        ),
      ),
    );
  }
}
