import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/apis/models/booking/selfie_request_model.dart';
import 'package:vivas/feature/bookings/bloc/selfie_bloc.dart';
import 'package:vivas/feature/bookings/screen/booking_pay_rent.dart';
import 'package:vivas/feature/bookings/screen/select_tenant_for_paid.dart';
import 'package:vivas/res/app_asset_paths.dart';

import '../../../apis/_base/dio_api_manager.dart';
import '../../../apis/managers/apartment_requests_api_manger.dart';
import '../../../preferences/preferences_manager.dart';
import '../../../res/app_colors.dart';
import '../../../utils/locale/app_localization_keys.dart';
import '../../request_details/request_details/screen/invoice_pay_rent_screen_v2.dart';
import '../bloc/bookings_repository.dart';
import 'hand_over_screen.dart';

class SelfieScreen extends StatelessWidget {
  SelfieScreen({super.key});

  static const routeName = '/_selfie-screen';
  static const argumentBookingDetails = "bookingDetailsModel";
  static const argumentFunctionBack = 'function-call-back';

  static Future<void> open(
      BuildContext context,
      BookingDetailsModel bookingDetailsModel,
      bool withReplacement,
      Function() onBack) async {
    if (withReplacement) {
      await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
        argumentBookingDetails: bookingDetailsModel,
        argumentFunctionBack: onBack
      });
    } else {
      await Navigator.of(context).pushNamed(routeName, arguments: {
        argumentBookingDetails: bookingDetailsModel,
        argumentFunctionBack: onBack
      });
    }
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelfieBloc(BookingsRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        apartmentRequestsApiManger:
            ApartmentRequestsApiManger(dioApiManager, context),
      )),
      child: SelfieScreenFull(
        bookingDetailsModel: bookingDetailsModel(context),
        onBack: onBack(context),
      ),
    );
  }

  BookingDetailsModel bookingDetailsModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[SelfieScreen.argumentBookingDetails] as BookingDetailsModel;

  Function() onBack(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentFunctionBack]
          as Function();
}

class SelfieScreenFull extends BaseStatefulScreenWidget {
  BookingDetailsModel bookingDetailsModel;
  Function() onBack;

  SelfieScreenFull(
      {super.key, required this.bookingDetailsModel, required this.onBack});

  @override
  BaseScreenState<SelfieScreenFull> baseScreenCreateState() {
    return _SelfieScreenState();
  }
}

class _SelfieScreenState extends BaseScreenState<SelfieScreenFull> {
  XFile? imageP;
  late SelfieBloc currentBloc;
  CameraDevice cameraDevice = CameraDevice.front;

  @override
  void initState() {
    currentBloc = context.read<SelfieBloc>();
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<SelfieBloc, SelfieState>(
        listener: (context, state) {
          if (state is SelfieSendingLoading) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is SelfieAddImage) {
            imageP = state.imageP;
          }
          if (state is SelfieSendingSuccess) {
            if (widget.bookingDetailsModel.paidRent) {
              HandoverProtocolsScreen.open(
                context,
                widget.bookingDetailsModel,
                widget.onBack,
                withReplacement: true,
              ).then((value) => widget.onBack);
            } else {
              if (widget.bookingDetailsModel.fullBooking ?? false) {
                InvoicePayRentScreenV2.open(context, widget.bookingDetailsModel,
                        false, widget.onBack,
                        openWithReplacement: true)
                    .then((value) => widget.onBack());
              } else if (widget.bookingDetailsModel.isSingleGuest) {
                InvoicePayRentScreenV2.open(context, widget.bookingDetailsModel,
                        false, widget.onBack,
                        openWithReplacement: true)
                    .then((value) => widget.onBack());
              } else {
                SelectTenantForPay.open(context, widget.bookingDetailsModel,
                        true, widget.onBack)
                    .then((value) => widget.onBack());
              }
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                child: Stack(
                  children: [
                    Positioned(
                      top: 80.h,
                      right: 0,
                      left: 0,
                      child: SizedBox(
                        width: 300.w,
                        child: Text(
                          'Please take a Selfie to verify your identity',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            color: Color(0xFF1A1B1E),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 180.h,
                      right: 0,
                      left: 0,
                      child: Card(
                        child: Container(
                          width: 200.w,
                          height: 250.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            image: imageP == null
                                ? const DecorationImage(
                                    image: AssetImage(
                                        AppAssetPaths.profileDefaultAvatar),
                                    fit: BoxFit.contain)
                                : DecorationImage(
                                    image: FileImage(
                                      File(imageP?.path ?? ''),
                                    ),
                                    fit: BoxFit.fitWidth),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(1, 1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  color: const Color(0xff000000)
                                      .withOpacity(0.25)),
                              BoxShadow(
                                  offset: const Offset(-1, -1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  color: const Color(0xff000000)
                                      .withOpacity(0.25)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () async {
                                ImagePicker imagePicker = ImagePicker();
                                currentBloc.add(
                                  SelfieAddImageEvent(
                                    await imagePicker.pickImage(
                                        source: ImageSource.camera,
                                        preferredCameraDevice: cameraDevice),
                                  ),
                                );
                              },
                              child: Container(
                                width: 150.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.divider),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                  child: Text("Take selfie"),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: imageP != null
                                  ? () {
                                      currentBloc.add(
                                        SelfieSendingImageEvent(
                                          SelfieRequestModel(
                                              requestId: widget
                                                      .bookingDetailsModel
                                                      .bookingId ??
                                                  "",
                                              bedID: widget
                                                      .bookingDetailsModel
                                                      .guests![widget
                                                          .bookingDetailsModel
                                                          .guestIndex]
                                                      .bedId ??
                                                  "",
                                              imagePath: imageP?.path ?? ""),
                                        ),
                                      );
                                    }
                                  : null,
                              child: Container(
                                width: 150.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                    color: imageP != null
                                        ? AppColors.colorPrimary
                                        : AppColors.divider,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    translate(LocalizationKeys.continuee)!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
