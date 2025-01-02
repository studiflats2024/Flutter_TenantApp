import 'package:flutter/material.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class AcceptRejectOfferWidget extends BaseStatelessWidget {
  final VoidCallback? acceptOfferClickedCallBack;
  final VoidCallback? rejectOfferClickedCallBack;
  AcceptRejectOfferWidget(
      {super.key,
      this.acceptOfferClickedCallBack,
      this.rejectOfferClickedCallBack});

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 40,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppElevatedButton.withTitle(
            color: const Color(0xFFEFEFEF),
            textColor: const Color(0xFF0F0F0F),
            title: translate(LocalizationKeys.rejectoffer)!,
            onPressed: rejectOfferClickedCallBack,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          AppElevatedButton.withTitle(
            title: translate(LocalizationKeys.approveoffer)!,
            onPressed: acceptOfferClickedCallBack,
          ),
        ],
      ),
    );
  }
}
