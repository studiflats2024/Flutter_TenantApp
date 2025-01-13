import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/feature/bookings/screen/booking_scan_qr.dart';
import 'package:vivas/feature/bookings/widget/contact_us.dart';
import 'package:vivas/feature/contact_support/screen/chat_screen.dart';
import 'package:vivas/feature/contact_support/screen/contact_support_screen.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class BookingSummary extends StatelessWidget {
  const BookingSummary({super.key});

  static const routeName = '/booking_summary';
  static const argumentsGuest = 'guest';
  static const argumentsBookingDetails = 'bookingDetails';
  static const argumentsLocation = 'location';
  static const argumentFunctionBack = 'function-call-back';

  static Future<void> open(
    BuildContext context,
    BookingDetailsModel bookingDetailsModel,
    Guest guest,
    String location,
    Function() onBack,
  ) async {
    await Navigator.of(context).pushNamed(routeName, arguments: {
      argumentsGuest: guest,
      argumentsLocation: location,
      argumentsBookingDetails: bookingDetailsModel,
      argumentFunctionBack: onBack,
    });
  }

  Function() onBack(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentFunctionBack]
          as Function();

  Guest guest(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[BookingSummary.argumentsGuest] as Guest;

  BookingDetailsModel bookingDetails(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[BookingSummary.argumentsBookingDetails]
          as BookingDetailsModel;

  String apartmentLocation(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[BookingSummary.argumentsLocation] as String;

  @override
  Widget build(BuildContext context) {
    return BookingSummaryStateFull(
      guest: guest(context),
      bookingDetailsModel: bookingDetails(context),
      aptLocation: apartmentLocation(context),
      onBack: onBack(context),
    );
  }
}

class BookingSummaryStateFull extends BaseStatefulScreenWidget {
  final Guest guest;
  final BookingDetailsModel bookingDetailsModel;
  final String aptLocation;
  final Function() onBack;

  const BookingSummaryStateFull(
      {required this.guest,
      required this.bookingDetailsModel,
      required this.aptLocation,
      required this.onBack,
      super.key});

  @override
  BaseScreenState<BookingSummaryStateFull> baseScreenCreateState() {
    return _BookingSummaryNameState();
  }
}

class _BookingSummaryNameState
    extends BaseScreenState<BookingSummaryStateFull> {
  TextEditingController controller = TextEditingController();
  TapGestureRecognizer gestureRecognizer = TapGestureRecognizer();
  late Guest guest;

  @override
  void initState() {
    guest = widget.guest;
    gestureRecognizer.onTap = _goToContactSupport;
    super.initState();
  }

  void _goToContactSupport() async {
    //await ContactSupportScreen.open(context);
    await ChatScreen.open(context,
        unitUUID: widget.bookingDetailsModel.apartmentId,
        openWithReplacement: false);
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
                    SizedBox(
                      height: 10.h,
                    ),
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
                    Text(
                      "${translate(LocalizationKeys.location)!}: ${widget.aptLocation}",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      widget.bookingDetailsModel.fullBooking == true
                          ? ""
                          : guest.bedName ?? "",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w600),
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
                          guest.guestName ?? "",
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
                          (widget.bookingDetailsModel.fullBooking ?? false)
                              ? translate(LocalizationKeys.full)!
                              : translate(LocalizationKeys.roomType)!,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          (widget.bookingDetailsModel.fullBooking ?? false)
                              ? ""
                              : guest.roomType ?? "",
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
                          widget.bookingDetailsModel.fullBooking == true
                              ? translate(LocalizationKeys.rentPrice)!
                              : translate(LocalizationKeys.bedPrice)!,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.bookingDetailsModel.fullBooking == true
                              ? "€ ${(widget.bookingDetailsModel.fullRent ?? 0.0).toStringAsFixed(2)}"
                              : "€ ${(guest.bedPrice ?? 0.0).toStringAsFixed(2)}",
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
                          widget.bookingDetailsModel.fullBooking == true
                              ? "€ ${(widget.bookingDetailsModel.fullSecurity ?? 0.0).toStringAsFixed(2)}"
                              : "€ ${(guest.securityDeposit ?? 0.0).toStringAsFixed(2)}",
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
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.bookingDetailsModel.fullBooking == true
                              ? "€ ${(widget.bookingDetailsModel.fullService ?? 0.0).toStringAsFixed(2)}"
                              : "€ ${(guest.serviceFee ?? 0.0).toStringAsFixed(2)}",
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
                    BookingScanQr.open(context, widget.bookingDetailsModel,
                            guest, true, widget.onBack)
                        .then((value) => widget.onBack());
                  }),
              SizedBox(
                height: 10.h,
              ),
              ContactUs(gestureRecognizer),
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
