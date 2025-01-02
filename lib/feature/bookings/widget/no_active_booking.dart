import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/translator.dart';
import 'package:vivas/feature/bookings/screen/booking_id.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_icons.dart';

class NoActiveBooking extends StatelessWidget {
  NoActiveBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 40.h,
        ),
        Image.asset(
          AppAssetPaths.appLogoTitle,
          width: 120.w,
          height: 60.h,
        ),
        SizedBox(
          height: 20.h,
        ),
        const Text(
          "welcome to studiflats",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 20.h,
        ),
        SvgPicture.asset(AppIcons.noActiveBookingsIcon),
        SizedBox(
          height: 20.h,
        ),
        const Text(
          "You don't have any active booking",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        // SubmitButtonWidget(title: "${translate(LocalizationKeys.click)!}", onClicked: (){})
        // SubmitButtonWidget(
        //   title: "Click Here",
        //   onClicked: () {
        //     BookingId.open(context);
        //   },
        //   withoutShape: true,
        //   padding: EdgeInsets.symmetric(horizontal: 25.w),
        // )
      ],
    ),);
  }
}
