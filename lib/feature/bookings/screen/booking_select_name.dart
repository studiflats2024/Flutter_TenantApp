import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/feature/bookings/screen/booking_summry.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/custom_drop_down_form_filed_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class BookingSelectName extends BaseStatefulScreenWidget {
  static const routeName = '/booking_select_name';

  const BookingSelectName({super.key});

  static Future<void> open(BuildContext context) async {
    await Navigator.of(context).pushNamed(routeName);
  }

  @override
  BaseScreenState<BookingSelectName> baseScreenCreateState() {
    return _BookingSelectNameState();
  }
}

class _BookingSelectNameState extends BaseScreenState<BookingSelectName> {
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
              SizedBox(height: 10.h,),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.transparent),
                child: Row(
                  children: [
                     Icon(
                      Icons.arrow_back,
                      color: AppColors.colorPrimary,
                      size: 20.r,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate(LocalizationKeys.bookingId)!,
                    style:  TextStyle(
                        fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "R0036",
                    style: TextStyle(
                      color: AppColors.textColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500),
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
                        fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Double Room",
                    style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomDropDownFormFiledWidget(
                title: translate(LocalizationKeys.name)!,
                requiredTitle: false,
                titleTextStyle:  TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.appFormFieldTitle,
                  fontWeight: FontWeight.w600,
                ),
                hintText: translate(LocalizationKeys.selectYourName)!,
                items: ["Osman" , "Mohammed"].map((name) {
                  return CustomDropDownItem(
                      key: name, value: name);
                }).toList(),
              ),
              SizedBox(
                height: 20.h,
              ),
              SubmitButtonWidget(
                  title: translate(LocalizationKeys.continuee)!,
                  withoutShape: true,
                  padding: EdgeInsets.zero,
                  onClicked: () {
                  //  BookingSummary.open(context,Guest(), "");
                  }),
              SizedBox(
                height: 20.h,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
