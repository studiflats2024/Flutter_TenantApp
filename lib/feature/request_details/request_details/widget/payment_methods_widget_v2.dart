import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class PaymentMethodsWidgetV2 extends BaseStatelessWidget {
  final bool canPayLater;
  final bool payCash;
  final VoidCallback payWithOnlineClickedCallBack;
  final VoidCallback payWithPayLaterClickedCallBack;
  final VoidCallback? payWithCashClickedCallBack;

  PaymentMethodsWidgetV2({
    required this.canPayLater,
    this.payCash = false,
    required this.payWithOnlineClickedCallBack,
    required this.payWithPayLaterClickedCallBack,
    this.payWithCashClickedCallBack,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 15,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          _methodWidget(translate(LocalizationKeys.onlinePayment)!,
              AppAssetPaths.creditCardIcon, payWithOnlineClickedCallBack),
          if (canPayLater)
            TextButton(
                onPressed: payWithPayLaterClickedCallBack,
                child: Text(
                  translate(LocalizationKeys.payLater)!,
                  style: const TextStyle(
                    color: AppColors.colorPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                )),
          if (payCash)
            _methodWidget(translate(LocalizationKeys.cash)!,
                AppAssetPaths.walletIcon, payWithCashClickedCallBack??(){}),
        ],
      ),
    );
  }

  Widget _methodWidget(String title, String logoPath, VoidCallback onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFF5F5F5)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(logoPath),
              SizedBox(width: 16.w),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF606060),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_outlined,
                  color: Color(0xff1D2939)),
            ],
          ),
        ),
      ),
    );
  }
}
