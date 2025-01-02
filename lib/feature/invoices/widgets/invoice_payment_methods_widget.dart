import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class InvoicePaymentMethodsWidget extends BaseStatelessWidget {
  final bool canPayOnline;
  final bool canPayCash;
  final VoidCallback payWithOnlineClickedCallBack;
  final VoidCallback payWithCashClickedCallBack;
  InvoicePaymentMethodsWidget({
    required this.canPayOnline,
    required this.canPayCash,
    required this.payWithOnlineClickedCallBack,
    required this.payWithCashClickedCallBack,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        children: [
          if (canPayOnline)
            _methodWidget(translate(LocalizationKeys.onlinePayment)!,
                AppAssetPaths.creditCardIcon, payWithOnlineClickedCallBack),
          if (canPayCash)
            _methodWidget(translate(LocalizationKeys.cash)!,
                AppAssetPaths.walletIcon, payWithCashClickedCallBack),
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
