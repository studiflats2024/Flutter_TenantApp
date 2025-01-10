import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/cached_network_image/app_cached_network_image.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../../apis/models/booking/booking_details_model.dart';

class BookingDetailsScreen extends StatelessWidget {
  static const routeName = '/_booking-details-screen';
  static const argumentBookingDetails = 'booking-details';

  const BookingDetailsScreen({super.key});

  static Future<void> open(BuildContext context,
      BookingDetailsModel bookingDetailsModel) async {
    await Navigator.of(context).pushNamed(routeName,
        arguments: {argumentBookingDetails: bookingDetailsModel});
  }

  @override
  Widget build(BuildContext context) {
    return BookingDetailsScreenFull(
      bookingDetailsModel: bookingDetails(context),
    );
  }

  BookingDetailsModel bookingDetails(BuildContext context) =>
      (ModalRoute
          .of(context)!
          .settings
          .arguments
      as Map)[BookingDetailsScreen.argumentBookingDetails]
      as BookingDetailsModel;
}

class BookingDetailsScreenFull extends BaseStatefulScreenWidget {
  BookingDetailsModel bookingDetailsModel;

  BookingDetailsScreenFull({super.key, required this.bookingDetailsModel});

  @override
  BaseScreenState<BookingDetailsScreenFull> baseScreenCreateState() {
    return _BookingDetailsScreenState();
  }
}

class _BookingDetailsScreenState
    extends BaseScreenState<BookingDetailsScreenFull> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.bookingDetails)!),
        centerTitle: true,
        elevation: 3,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    width: 350.w,
                    height: 150.h,
                    decoration:  BoxDecoration(
                        image:(widget.bookingDetailsModel.apartmentPicture?.isLink?? false) ?  null : const DecorationImage(
                            image: AssetImage(AppAssetPaths.apartmentDetails),
                            fit: BoxFit.cover),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: (widget.bookingDetailsModel.apartmentPicture
                        ?.isLink?? false) ? AppCachedNetworkImage(
                      imageUrl: widget.bookingDetailsModel.apartmentPicture ??
                          "",
                      height: double.infinity,
                      width: double.infinity,
                      boxFit: BoxFit.fill,
                      borderRadius: 5,
                    ) : Container(),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: translate(LocalizationKeys.apartmentId)!,
                              style: TextStyle(
                                color: const Color(0xFF484649),
                                fontSize: 14.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text:
                              " ${widget.bookingDetailsModel.apartmentCode ??
                                  ""}",
                              style: TextStyle(
                                color: const Color(0xFF484649),
                                fontSize: 12.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                  "${translate(
                                      LocalizationKeys.bookingId)!} : ",
                                  style: TextStyle(
                                    color: const Color(0xFF484649),
                                    fontSize: 14.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                  " ${widget.bookingDetailsModel.bookingCode ??
                                      ""}",
                                  style: TextStyle(
                                    color: const Color(0xFF484649),
                                    fontSize: 12.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          InkWell(
                              onTap: () async {
                                try {
                                  Clipboard.setData(ClipboardData(
                                      text: widget.bookingDetailsModel
                                          .bookingCode ??
                                          ""));
                                } catch (e) {
                                  showFeedbackMessage("$e ");
                                } finally {
                                  showFeedbackMessage(
                                      "Copied to Clipboard : ${widget
                                          .bookingDetailsModel.bookingCode ??
                                          ""}");
                                }
                              },
                              child: SvgPicture.asset(AppAssetPaths.copyIcon))
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    widget.bookingDetailsModel.apartmentName ?? "",
                    style: TextStyle(
                      color: const Color(0xFF0A2D4E),
                      fontSize: 20.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(AppAssetPaths.unitLocationIcon),
                          SizedBox(
                            width: 300.w,
                            child: Text(
                              widget.bookingDetailsModel.apartmentLocation ??
                                  "",
                              style: TextStyle(
                                color: const Color(0xFF484649),
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Text(
                      //   translate(LocalizationKeys.viewDirection)!,
                      //   style: TextStyle(
                      //     color: const Color(0xFF1151B3),
                      //     fontSize: 14.sp,
                      //     fontFamily: 'Poppins',
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                              'Room ${widget.bookingDetailsModel.guests?[widget
                                  .bookingDetailsModel.guestIndex].roomName ??
                                  ""} ',
                              style: TextStyle(
                                color: const Color(0xFF0A2D4E),
                                fontSize: 16.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text:
                              "(${widget.bookingDetailsModel.guests?[widget
                                  .bookingDetailsModel.guestIndex].bedName ??
                                  ""})",
                              style: TextStyle(
                                color: AppColors.colorPrimary,
                                fontSize: 14.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                              '€${(widget.bookingDetailsModel.guests?[widget
                                  .bookingDetailsModel.guestIndex].bedPrice ??
                                  0.00).toStringAsFixed(2)}/',
                              style: TextStyle(
                                color: AppColors.colorPrimary,
                                fontSize: 14.spMin,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: translate(LocalizationKeys.month)!,
                              style: TextStyle(
                                color: AppColors.colorPrimary,
                                fontSize: 14.spMin,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate(LocalizationKeys.roomType)!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF0A2D4E),
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        widget
                            .bookingDetailsModel
                            .guests?[widget.bookingDetailsModel.guestIndex]
                            .roomType ??
                            "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF484649),
                          fontSize: 12.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate(LocalizationKeys.serviceFee)!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF0A2D4E),
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        '€ ${(widget.bookingDetailsModel.guests?[widget
                            .bookingDetailsModel.guestIndex].serviceFee ?? 0.0)
                            .toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF484649),
                          fontSize: 12.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate(LocalizationKeys.securityDeposit2)!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF0A2D4E),
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        '€ ${(widget.bookingDetailsModel.guests?[widget
                            .bookingDetailsModel.guestIndex].securityDeposit ??
                            0.00).toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF484649),
                          fontSize: 12.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Visibility(
                    visible: widget.bookingDetailsModel.rentalRulesSigned,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'QR Code',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF0A2D4E),
                                fontSize: 14.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              '${widget.bookingDetailsModel.guests?[widget
                                  .bookingDetailsModel.guestIndex].qRCode}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF484649),
                                fontSize: 12.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 160.h,
                                width: 160.w,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1, color: Color(0xFF909090)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: widget
                                      .bookingDetailsModel
                                      .guests?[widget
                                      .bookingDetailsModel.guestIndex]
                                      .qrCodeImg ??
                                      "",
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 160.w,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 1, color: Color(0xFF798CA4)),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.visibility_outlined),
                                        SizedBox(width: 5.w),
                                        Text(
                                          translate(
                                              LocalizationKeys.viewInvoice)!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF5F6368),
                                            fontSize: 14.sp,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 150.w,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      color: AppColors.colorPrimary,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 1, color: Color(0xFF798CA4)),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.share,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          translate(LocalizationKeys.share)!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
