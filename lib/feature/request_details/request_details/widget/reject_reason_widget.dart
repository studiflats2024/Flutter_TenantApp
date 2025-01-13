import 'package:flutter/material.dart';

import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/res/app_colors.dart';

// ignore: must_be_immutable
class RejectReasonWidget extends BaseStatelessWidget {

  final String rejectReason;
  RejectReasonWidget({
    required this.rejectReason,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: 10.h),
        // SvgPicture.asset(AppAssetPaths.warringIcon),
        // SizedBox(height: 24.h),
        // Text(
        //   translate(LocalizationKeys.reason)!,
        //   style: const TextStyle(
        //     color: Color(0xFF0F1728),
        //     fontSize: 18,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        const SizedBox(height: 24),
        Text(
          rejectReason,
          style: const TextStyle(
            color: AppColors.appFormFieldTitle,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
