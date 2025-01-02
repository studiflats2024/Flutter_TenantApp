import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class InvoiceStateWidget extends BaseStatelessWidget {
  final bool isPaid;
  InvoiceStateWidget(this.isPaid, {super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      decoration: ShapeDecoration(
        color: statusBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        isPaid
            ? translate(LocalizationKeys.paid)!
            : translate(LocalizationKeys.unPaid)!,
        style: TextStyle(
          color: statusTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Color get statusTextColor {
    if (isPaid) {
      return const Color(0xFF1151B4);
    } else {
      return const Color(0xFFED2E38);
    }
  }

  Color get statusBackgroundColor {
    if (isPaid) {
      return const Color(0x141151B4);
    } else {
      return const Color(0x14ED2E38);
    }
  }
}
