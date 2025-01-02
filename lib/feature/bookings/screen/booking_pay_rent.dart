import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/feature/bookings/screen/booking_scan_qr.dart';
import 'package:vivas/feature/bookings/screen/hand_over_screen.dart';
import 'package:vivas/feature/bookings/screen/sign_contract_v2.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class BookingPayRent extends BaseStatefulScreenWidget {
  static const routeName = '/booking_pay-rent';

  const BookingPayRent({super.key});

  static Future<void> open(BuildContext context , withReplacement) async {
    if(withReplacement){
      await Navigator.of(context).pushReplacementNamed(routeName);
    }else{
      await Navigator.of(context).pushNamed(routeName);
    }

  }

  @override
  BaseScreenState<BookingPayRent> baseScreenCreateState() {
    return _BookingPayRentState();
  }
}

class _BookingPayRentState extends BaseScreenState<BookingPayRent> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h,),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_back,
                            color: AppColors.colorPrimary,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            translate(LocalizationKeys.back)!,
                            style: TextStyle(
                                color: AppColors.colorPrimary,
                                fontWeight: FontWeight.w800,
                                fontSize: 18.sp),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 24.0.h, horizontal: 15.w),
                        child:  Text(
                          'Pay Rent and Security Deposit',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF1A1B1E),
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      "${translate(LocalizationKeys.location)!}: Uptown SA, East Side Flow 4",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                     Text(
                      "Bed 1",
                      style:
                          TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translate(LocalizationKeys.name)!,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Osman",
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translate(LocalizationKeys.roomType)!,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Single Room",
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translate(LocalizationKeys.bedPrice)!,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "€ 500",
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translate(LocalizationKeys.securityDeposit2)!,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600),
                        ),
                         Text(
                          "€ 70",
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translate(LocalizationKeys.serviceFee)!,
                          style:  TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600),
                        ),
                         Text(
                          "€ 80",
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
              SubmitButtonWidget(
                  title: translate(LocalizationKeys.continuee)!,
                  withoutShape: true,
                  padding: EdgeInsets.zero,
                  onClicked: () {
                    SignContractV2Screen.open(context);
                  }),
              SizedBox(
                height: 10.h,
              ),
              Text.rich(
                TextSpan(
                  text: translate(
                    LocalizationKeys.needHelp,
                  ),
                  style: const TextStyle(color: AppColors.formFieldHintText),
                  children: [
                    TextSpan(
                      text: translate(LocalizationKeys.contactUs)!,
                      style: const TextStyle(
                          color: AppColors.colorPrimary,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
