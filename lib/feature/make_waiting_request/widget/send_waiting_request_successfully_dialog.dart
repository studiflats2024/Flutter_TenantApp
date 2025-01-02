import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_dialog_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

Future<void> showSendWaitingRequestSuccessfullyDialog({
  required BuildContext context,
  required VoidCallback goBackCallback,
  String? message,
}) async {
  var widget = SendWaitingRequestSuccessfullyDialog(
    goBackCallback: goBackCallback,
    message: message,
  );
  await showAppDialog(
    context: context,
    dialogWidget: widget,
    shouldPop: true,
  );
}

// ignore: must_be_immutable
class SendWaitingRequestSuccessfullyDialog extends BaseStatelessWidget {
  final VoidCallback goBackCallback;
  final String? message;
  SendWaitingRequestSuccessfullyDialog({
    super.key,
    required this.goBackCallback,
    this.message,
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
            SizedBox(height: 45.h),
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
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Text(
                message ??
                    translate(LocalizationKeys
                        .yourRequestHasBeenReceivedWeWillContactYouOnceWeFindTheAppropriateApartment)!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF1B1B2F),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 40.h),
            AppElevatedButton.withTitle(
                onPressed: () {
                  Navigator.of(context).pop();
                  goBackCallback();
                },
                title: translate(LocalizationKeys.backToHomeScreen)!),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
