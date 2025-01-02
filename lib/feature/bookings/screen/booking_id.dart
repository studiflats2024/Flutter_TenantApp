import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/feature/arriving_details/Screen/arriving_details.dart';
import 'package:vivas/feature/bookings/screen/booking_select_name.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class BookingId extends BaseStatefulScreenWidget {
  static const routeName = '/booking_id';

  const BookingId({super.key});

  static Future<void> open(BuildContext context) async {
    await Navigator.of(context).pushNamed(routeName);
  }

  @override
  BaseScreenState<BookingId> baseScreenCreateState() {
    return _BookingIdState();
  }
}

class _BookingIdState extends BaseScreenState<BookingId> {
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                      style:  TextStyle(
                          color: AppColors.colorPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 18.sp),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                translate(LocalizationKeys.enterBookingId)!,
                style:
                     TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                translate(LocalizationKeys.bookingNumberSent)!,
                textAlign: TextAlign.center,
                style:  TextStyle(fontSize: 18.sp),
              ),
              SizedBox(
                height: 20.h,
              ),
              AppTextFormField(
                title: "",
                controller: controller,
                requiredTitle: false,
                hintText: "Booking Id",
                textInputAction: TextInputAction.next,
                onSaved: (value) {},
              ),
              SizedBox(
                height: 20.h,
              ),
              SubmitButtonWidget(
                  title: translate(LocalizationKeys.continuee)!,
                  withoutShape: true,
                  padding: EdgeInsets.zero,
                  onClicked: () {
                    BookingSelectName.open(context);
                   // ArrivingDetails.open(context);
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
