import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/feature/bookings/bloc/bookings_repository.dart';
import 'package:vivas/feature/bookings/bloc/qr_bloc.dart';
import 'package:vivas/feature/bookings/screen/qr_scanner_screen.dart';
import 'package:vivas/feature/bookings/screen/welcome.dart';
import 'package:vivas/feature/bookings/widget/contact_us.dart';
import 'package:vivas/feature/contact_support/screen/contact_support_screen.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import '../../../apis/_base/dio_api_manager.dart';
import '../../../apis/managers/apartment_requests_api_manger.dart';
import '../../../apis/models/booking/booking_details_model.dart';
import '../../contact_support/screen/chat_screen.dart';

class BookingScanQr extends StatelessWidget {
  BookingScanQr({super.key});

  static const routeName = '/booking_scan_qr';
  static const argumentsGuest = 'guest';
  static const argumentsBookingDetails = 'bookingDetails';
  static const argumentFunctionBack = 'function-call-back';

  static Future<void> open(
      BuildContext context,
      BookingDetailsModel bookingDetails,
      Guest guest,
      bool withReplacement,
      Function() onBack) async {
    if (withReplacement) {
      await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
        argumentsGuest: guest,
        argumentsBookingDetails: bookingDetails,
        argumentFunctionBack: onBack,
      });
    } else {
      await Navigator.of(context).pushNamed(routeName, arguments: {
        argumentsGuest: guest,
        argumentsBookingDetails: bookingDetails,
        argumentFunctionBack: onBack,
      });
    }
  }

  Guest guest(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[BookingScanQr.argumentsGuest] as Guest;

  Function() onBack(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentFunctionBack]
          as Function();

  BookingDetailsModel bookingDetails(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[BookingScanQr.argumentsBookingDetails] as BookingDetailsModel;

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrBloc(BookingsRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        apartmentRequestsApiManger:
            ApartmentRequestsApiManger(dioApiManager, context),
      )),
      child: BookingScanQrStateFull(
        guest: guest(context),
        bookingDetails: bookingDetails(context),
        onBack: onBack(context),
      ),
    );
  }
}

class BookingScanQrStateFull extends BaseStatefulScreenWidget {
  final Guest guest;
  final BookingDetailsModel bookingDetails;
  final Function() onBack;

  const BookingScanQrStateFull(
      {required this.guest,
      required this.bookingDetails,
      required this.onBack,
      super.key});

  @override
  BaseScreenState<BookingScanQrStateFull> baseScreenCreateState() {
    return _BookingSummaryNameState();
  }
}

class _BookingSummaryNameState extends BaseScreenState<BookingScanQrStateFull> {
  late QrBloc currentBloc;
  bool showHelpMessage = false;
  TextEditingController controller = TextEditingController();
  GlobalKey<FormState> requestFormKey = GlobalKey<FormState>();
  TapGestureRecognizer gestureRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    currentBloc = context.read<QrBloc>();
    gestureRecognizer.onTap = _goToContactSupport;
    super.initState();
  }

  void _goToContactSupport() async {
    await ChatScreen.open(context,
        unitUUID: widget.bookingDetails.apartmentId,
        openWithReplacement: false);
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: BlocConsumer<QrBloc, QrState>(
        listener: (context, state) {
          if (state is QrLoading) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is QrFailed) {
          } else if (state is QrSuccessScan) {
            WelcomeScreen.open(context, widget.bookingDetails, widget.onBack)
                .then((value) => widget.onBack());
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              child: Column(
                children: [
                  Column(
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
                          mainAxisSize: MainAxisSize.min,
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
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${widget.bookingDetails.bookingCode}",
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
                            "${widget.guest.roomType}",
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
                    ],
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Visibility(
                    visible: currentBloc.question,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 15.h),
                      decoration: BoxDecoration(
                        color: Color(0xffFAFCFF),
                        borderRadius: BorderRadius.circular(15),
                        border: const Border(
                          left: BorderSide(color: Color(0xff1F4068), width: 4),
                        ),
                      ),
                      child: const Text(
                        "For the QR Sticker on the bed check highlighted number that ending with same 3 numbers",
                        style: TextStyle(
                            color: Color(0xff1F4068),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: currentBloc.error,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 15.h),
                      decoration: BoxDecoration(
                        color: Color(0xffFCEEEE),
                        borderRadius: BorderRadius.circular(15),
                        border: const Border(
                          left: BorderSide(color: Color(0xffB3261E), width: 4),
                        ),
                      ),
                      child: const Text(
                        "Wrong code, please scan OR write the correct QR Code",
                        style: TextStyle(
                            color: Color(0xffB3261E),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Scan the bed QR Code#${replaceFirstThreeWithAsterisks(widget.guest.qRCode ?? "")}",
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                          onPressed: () {
                            currentBloc.add(QrQuestionEvent());
                            Future.delayed(const Duration(seconds: 4), () {
                              currentBloc.add(QrQuestionEvent());
                            });
                          },
                          icon: SvgPicture.asset(AppAssetPaths.helpIcon))
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    width: 400.w,
                    child: AppElevatedButton(
                        onPressed: () async {
                          // bool value = await QrScannerScreen.open(context, widget.bookingDetails, widget.guest, currentBloc);
                          bool value = await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return QrScannerScreenState(
                                guest: widget.guest,
                                bookingDetails: widget.bookingDetails);
                          }));
                          if (value) {
                            currentBloc.add(
                              QrSendingEvent(
                                widget.bookingDetails.bookingId ?? "",
                                widget.guest.bedId ?? "",
                                widget.guest.qRCode ?? "",
                              ),
                            );
                          } else {
                            currentBloc.add(QrErrorEvent());
                            Future.delayed(const Duration(seconds: 3), () {
                              currentBloc.add(QrErrorEvent());
                            });
                          }
                        },
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Color(0xff798CA4)),
                            borderRadius: BorderRadius.circular(10)),
                        label: Text(
                          translate(LocalizationKeys.scanQrCode)!,
                          style: TextStyle(
                              color: AppColors.colorPrimary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    "OR",
                    style: TextStyle(
                        color: AppColors.formFieldHintText,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Form(
                    key: requestFormKey,
                    child: AppTextFormField(
                      title: translate(LocalizationKeys.code)!,
                      controller: controller,
                      requiredTitle: false,
                      hintText: translate(LocalizationKeys.enterCode)!,
                      titleStyle: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value != null) {
                          if (value != widget.guest.qRCode) {
                            currentBloc.add(QrErrorEvent());
                            Future.delayed(const Duration(seconds: 3), () {
                              currentBloc.add(QrErrorEvent());
                            });
                            return translate(LocalizationKeys.codeNotCorrect);
                          } else {
                            return null;
                          }
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {},
                    ),
                  ),
                  SubmitButtonWidget(
                      title: translate(LocalizationKeys.continuee)!,
                      withoutShape: true,
                      padding: EdgeInsets.zero,
                      onClicked: () {
                        if (requestFormKey.currentState?.validate() ?? false) {
                          currentBloc.add(
                            QrSendingEvent(
                              widget.bookingDetails.bookingId ?? "",
                              widget.guest.bedId ?? "",
                              controller.text,
                            ),
                          );
                        } else {}
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
          );
        },
      ),
    );
  }

  String replaceFirstThreeWithAsterisks(String input) {
    if (input.length <= 3) {
      // If the string is 3 characters or shorter, return three asterisks
      return '*' * input.length;
    } else {
      // Replace the first three characters with asterisks and keep the rest of the string unchanged
      return '***${input.substring(3)}';
    }
  }
}
