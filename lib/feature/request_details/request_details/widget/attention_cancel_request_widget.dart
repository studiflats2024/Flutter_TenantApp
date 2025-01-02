import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/request_details/request_details/widget/cancel_request_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/res/app_asset_paths.dart';

import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class AttentionCancelRequestWidget extends BaseStatelessWidget {
  final void Function(String reason, DateTime? terminationDate) sendCallBack;
  final bool showTerminationDate;
   BuildContext? ctx;
  AttentionCancelRequestWidget({
    required this.sendCallBack,
    required this.showTerminationDate,
    this.ctx,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10.h),
        SvgPicture.asset(AppAssetPaths.warringIcon),
        SizedBox(height: 24.h),
        Text(
          translate(LocalizationKeys.attention)!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF0F1728),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          translate(LocalizationKeys
              .weWantedToBringToYourAttentionThatTheCancellationRequestThereIsAPossibilityThatItMayNotBeAccepted)!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF344053),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            AppElevatedButton.withTitle(
              color: const Color(0xFFEFEFEF),
              textColor: const Color(0xFF0F0F0F),
              title: translate(LocalizationKeys.cancel)!,
              onPressed: () => _cancelClicked(ctx??context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            const Spacer(),
            AppElevatedButton.withTitle(
                onPressed: () => _sendClicked(ctx??context),
                title: translate(LocalizationKeys.continuee)!),
          ],
        ),
      ],
    );
  }

  void _cancelClicked(BuildContext context) {
    Navigator.of(context).pop(false);
  }

  void _sendClicked(BuildContext context) {

    // AppBottomSheet.openAppBottomSheet(
    //     context: context,
    //     child: CancelRequestWidget(
    //         sendCallBack: sendCallBack,
    //         showTerminationDate: showTerminationDate),
    //     title: translate(showTerminationDate
    //         ? LocalizationKeys.terminationBooking
    //         : LocalizationKeys.cancelBooking)!);
    Navigator.of(context).pop(true);
  }
}
