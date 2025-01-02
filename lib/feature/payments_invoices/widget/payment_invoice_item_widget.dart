import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PaymentInvoiceItemWidget extends StatelessWidget {
  final String title;
  final String logoPath;
  final VoidCallback onClickCallBack;
  const PaymentInvoiceItemWidget(
      {super.key,
      required this.title,
      required this.logoPath,
      required this.onClickCallBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: InkWell(
        onTap: onClickCallBack,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: ShapeDecoration(
            color: Colors.white,
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
                  color: Color(0xFF344053),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_outlined, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
