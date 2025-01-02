import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../_core/widgets/base_stateless_widget.dart';

// ignore: must_be_immutable
class NoResultFoundLottieWidget extends BaseStatelessWidget {
  final String message, asset;
  double? widthAsset, heightAsset;
  bool multiLan;
  Function()? onClick;

  NoResultFoundLottieWidget(
      {required this.message,
      required this.asset,
      this.multiLan = false,
      this.heightAsset,
      this.widthAsset,
      this.onClick,
      super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        asset.contains("json")
            ? Lottie.asset(asset)
            : Image.asset(
                asset,
                width: widthAsset ?? 200.r,
                height: heightAsset ?? 200.r,
              ),
        SizedBox(height: 20.r),
        Text(
          multiLan ? translate(message) ?? "" : message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 20.r),
        Visibility(
          visible: onClick != null,
          child: AppElevatedButton(
          onPressed: onClick,
          label: Text(
            LocalizationKeys.refresh,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
          ),
        ),)
      ],
    );
  }
}
