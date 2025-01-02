import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/feature/bookings/bloc/bookings_repository.dart';
import 'package:vivas/feature/bookings/bloc/select_tenant_for_pay_bloc.dart';
import 'package:vivas/feature/request_details/request_details/screen/invoice_pay_rent_screen_v2.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../../apis/_base/dio_api_manager.dart';
import '../../../res/app_colors.dart';

class SelectTenantForPay extends StatelessWidget {
  static const routeName = '/select-tenant-for-paid';
  static const argumentBookingDetails = 'booking_details';
  static const argumentFunctionBack = 'function-call-back';

  SelectTenantForPay({super.key});

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

  Function() onBack(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentFunctionBack]
          as Function();

  BookingDetailsModel bookingDetailsModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[SelectTenantForPay.argumentBookingDetails]
          as BookingDetailsModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => SelectTenantForPayBloc(BookingsRepository(
          preferencesManager: GetIt.I<PreferencesManager>(),
          apartmentRequestsApiManger:
              ApartmentRequestsApiManger(dioApiManager, context))),
      child: SelectTenantForPayWidget(
        bookingDetailsModel: bookingDetailsModel(context),
        onBack: onBack(context),
      ),
    );
  }
}

class SelectTenantForPayWidget extends BaseStatefulScreenWidget {
  final BookingDetailsModel bookingDetailsModel;
  final Function() onBack;

  const SelectTenantForPayWidget(
      {super.key, required this.bookingDetailsModel, required this.onBack});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _SelectTenantForPayWidgetState();
  }
}

class _SelectTenantForPayWidgetState
    extends BaseScreenState<SelectTenantForPayWidget> {
  late SelectTenantForPayBloc selectTenantForPayBloc;

  @override
  void initState() {
    selectTenantForPayBloc = context.read<SelectTenantForPayBloc>();
    selectTenantForPayBloc
        .add(SelectTenantForPayInitEvent(widget.bookingDetailsModel));
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.payRent)!),
      ),
      body: BlocBuilder<SelectTenantForPayBloc, SelectTenantForPayState>(
        builder: (context, state) {
          return SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          translate(
                              LocalizationKeys.pleaseChooseYourPreferPay)!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF344053),
                            fontSize: 18,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: const Color(0xffC9C5CA), width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 10.w),
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 1.2,
                                  child: Radio(
                                    value: 0,
                                    groupValue: selectTenantForPayBloc
                                        .bookingDetailsModel?.payOption,
                                    onChanged: (value) {
                                      if (value != null) {
                                        selectTenantForPayBloc
                                            .add(ChoosePayOptionEvent(value));
                                      }
                                    },
                                    activeColor: AppColors.colorPrimary,
                                    fillColor: MaterialStateColor.resolveWith(
                                        (states) => AppColors.colorPrimary),
                                  ),
                                ),
                                Text(
                                  translate(LocalizationKeys.payForOnlyMe)!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            Text(
                              "€ ${(selectTenantForPayBloc.bookingDetailsModel?.guests?[selectTenantForPayBloc.bookingDetailsModel?.guestIndex ?? 0].totalGuestPaid ?? 0.0).toStringAsFixed(2)}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: const Color(0xffC9C5CA), width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 10.w),
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 1.2,
                                  child: Radio(
                                    value: 1,
                                    groupValue: selectTenantForPayBloc
                                        .bookingDetailsModel?.payOption,
                                    onChanged: (value) {
                                      if (selectTenantForPayBloc
                                              .bookingDetailsModel
                                              ?.totalGuestsPaid !=
                                          selectTenantForPayBloc
                                              .bookingDetailsModel
                                              ?.guests?[selectTenantForPayBloc
                                                      .bookingDetailsModel
                                                      ?.guestIndex ??
                                                  0]
                                              .totalGuestPaid) {
                                        if (value != null) {
                                          selectTenantForPayBloc
                                              .add(ChoosePayOptionEvent(value));
                                        }
                                      }
                                    },
                                    activeColor: AppColors.colorPrimary,
                                    fillColor: MaterialStateColor.resolveWith(
                                        (states) => (selectTenantForPayBloc
                                                    .bookingDetailsModel
                                                    ?.totalGuestsPaid ==
                                                selectTenantForPayBloc
                                                    .bookingDetailsModel
                                                    ?.guests?[selectTenantForPayBloc
                                                            .bookingDetailsModel
                                                            ?.guestIndex ??
                                                        0]
                                                    .totalGuestPaid)
                                            ? AppColors.formFieldText
                                                .withOpacity(0.2)
                                            : AppColors.colorPrimary),
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                      text: translate(
                                          LocalizationKeys.payForAll)!,
                                      children: [
                                        const TextSpan(
                                          text: " ",
                                          style: TextStyle(
                                              color:
                                                  AppColors.formFieldHintText,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        TextSpan(
                                          text: translate(
                                              LocalizationKeys.twoPerson)!,
                                          style: const TextStyle(
                                              color:
                                                  AppColors.formFieldHintText,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ]),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                // Text(
                                //   translate(LocalizationKeys.payForAll)!,
                                //   style: const TextStyle(
                                //       fontWeight: FontWeight.w500),
                                // )
                              ],
                            ),
                            Text(
                              "€ ${(selectTenantForPayBloc.bookingDetailsModel?.totalGuestsPaid ?? 0.0).toStringAsFixed(2)}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !widget.bookingDetailsModel.isTwoGuest,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: const Color(0xffC9C5CA), width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 10.w),
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 1.2,
                                    child: Radio(
                                      value: 2,
                                      groupValue: selectTenantForPayBloc
                                          .bookingDetailsModel?.payOption,
                                      onChanged: (value) {
                                        if (value != null) {
                                          selectTenantForPayBloc
                                              .add(ChoosePayOptionEvent(value));
                                        }
                                      },
                                      activeColor: AppColors.colorPrimary,
                                      fillColor: MaterialStateColor.resolveWith(
                                          (states) => AppColors.colorPrimary),
                                    ),
                                  ),
                                  Text(
                                    translate(LocalizationKeys.payForRoommate)!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: selectTenantForPayBloc
                                        .bookingDetailsModel?.guests?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  var mainTenant = selectTenantForPayBloc
                                          .bookingDetailsModel!.guests![
                                      selectTenantForPayBloc
                                          .bookingDetailsModel!.guestIndex];
                                  var guest = selectTenantForPayBloc
                                      .bookingDetailsModel!.guests![index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xffC9C5CA)
                                          .withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5.h, horizontal: 10.w),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 10.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Transform.scale(
                                              scale: 1.2,
                                              child: Checkbox(
                                                value: guest.isSelected,
                                                onChanged: (mainTenant
                                                                .guestId !=
                                                            guest.guestId &&
                                                        (guest.secuirtyPaid! &&
                                                            guest.payRent!))
                                                    ? null
                                                    : (value) {
                                                        if (value != null) {
                                                          selectTenantForPayBloc
                                                              .add(
                                                                  ChooseRoommateEvent(
                                                                      index));
                                                        }
                                                      },
                                                activeColor:
                                                    AppColors.colorPrimary,
                                                checkColor: Colors.transparent,
                                                focusColor:
                                                    AppColors.colorPrimary,
                                                side: BorderSide(
                                                    color: (mainTenant
                                                                    .guestId !=
                                                                guest.guestId &&
                                                            (guest.secuirtyPaid! &&
                                                                guest.payRent!))
                                                        ? AppColors
                                                            .formFieldText
                                                            .withOpacity(0.2)
                                                        : AppColors
                                                            .colorPrimary,
                                                    width: 2),
                                              ),
                                            ),
                                            Text(
                                              mainTenant.guestId ==
                                                      guest.guestId
                                                  ? "${guest.guestName?.capitalize ?? ""} (${translate(LocalizationKeys.you)!})"
                                                  : guest.guestName
                                                          ?.capitalize ??
                                                      "",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                        Text(
                                          "€ ${guest.totalGuestPaid.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (selectTenantForPayBloc
                              .bookingDetailsModel?.payOption ==
                          0) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.r),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Payment Details ",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor),
                              ),
                              Text(
                                "€ ${(selectTenantForPayBloc.bookingDetailsModel?.subTotalGuestsPaid)?.toStringAsFixed(2)} ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.r,
                        ),
                        tenantSelectedSummary(
                            0,
                            selectTenantForPayBloc
                                .bookingDetailsModel
                                ?.guests?[selectTenantForPayBloc
                                        .bookingDetailsModel?.guestIndex ??
                                    0]
                                .guestName,
                            selectTenantForPayBloc
                                    .bookingDetailsModel
                                    ?.guests?[selectTenantForPayBloc
                                            .bookingDetailsModel?.guestIndex ??
                                        0]
                                    .securityDeposit ??
                                0,
                            selectTenantForPayBloc
                                    .bookingDetailsModel
                                    ?.guests?[selectTenantForPayBloc
                                            .bookingDetailsModel?.guestIndex ??
                                        0]
                                    .secuirtyPaid ??
                                false,
                            selectTenantForPayBloc
                                    .bookingDetailsModel
                                    ?.guests?[selectTenantForPayBloc
                                            .bookingDetailsModel?.guestIndex ??
                                        0]
                                    .serviceFee ??
                                0,
                            selectTenantForPayBloc
                                    .bookingDetailsModel
                                    ?.guests?[selectTenantForPayBloc.bookingDetailsModel?.guestIndex ?? 0]
                                    .bedPrice ??
                                0,
                            selectTenantForPayBloc.bookingDetailsModel?.guests?[selectTenantForPayBloc.bookingDetailsModel?.guestIndex ?? 0].payRent ?? false)
                      ] else if (selectTenantForPayBloc
                              .bookingDetailsModel?.payOption ==
                          1) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.r),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                translate(LocalizationKeys.paymentDetails) ??
                                    "",
                                style: textTheme.titleMedium?.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor),
                              ),
                              Text(
                                "€ ${(selectTenantForPayBloc.bookingDetailsModel?.subTotalGuestsPaid)?.toStringAsFixed(2)} ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.r,
                        ),
                        Column(
                          children: List.generate(
                              selectTenantForPayBloc
                                      .bookingDetailsModel?.guests?.length ??
                                  0, (index) {
                            var guest = selectTenantForPayBloc
                                .bookingDetailsModel?.guests?[index];
                            return tenantSelectedSummary(
                                index,
                                guest?.guestName,
                                guest?.securityDeposit ?? 0,
                                guest?.secuirtyPaid ?? false,
                                guest?.serviceFee ?? 0,
                                guest?.bedPrice ?? 0,
                                guest?.payRent ?? false);
                          }),
                        )
                      ] else ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.r),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                translate(LocalizationKeys.paymentDetails) ??
                                    "",
                                style: textTheme.titleMedium?.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor),
                              ),
                              Text(
                                "€ ${(selectTenantForPayBloc.bookingDetailsModel?.subTotalGuestsPaid)?.toStringAsFixed(2)} ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.r,
                        ),
                        Column(
                          children: List.generate(
                              selectTenantForPayBloc
                                      .bookingDetailsModel?.guests?.length ??
                                  0, (index) {
                            var guest = selectTenantForPayBloc
                                .bookingDetailsModel?.guests?[index];
                            return guest?.isSelected ?? false
                                ? tenantSelectedSummary(
                                    index,
                                    guest?.guestName,
                                    guest?.securityDeposit ?? 0,
                                    guest?.secuirtyPaid ?? false,
                                    guest?.serviceFee ?? 0,
                                    guest?.bedPrice ?? 0,
                                    guest?.payRent ?? false)
                                : Container();
                          }),
                        )
                      ]
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar:
          BlocBuilder<SelectTenantForPayBloc, SelectTenantForPayState>(
        builder: (context, state) {
          return SizedBox(
            height: 110.h,
            child: selectTenantForPayBloc.bookingDetailsModel?.payOption ==
                        null ||
                    (selectTenantForPayBloc
                            .bookingDetailsModel!.tenantsSelected.isEmpty ??
                        true)
                ? SubmitButtonWidget(
                    title:
                        "${translate(LocalizationKeys.payInvoice)!}  € ${(selectTenantForPayBloc.bookingDetailsModel?.subTotalGuestsPaid)?.toStringAsFixed(2)} ",
                    onClicked: () {
                      showFeedbackMessage(translate(
                          LocalizationKeys.pleaseChooseYourPaymentMethod)!);
                    },
                    titleStyle: TextStyle(
                        color: AppColors.formFieldText.withOpacity(0.8),
                        fontSize: 18),
                    buttonColor: AppColors.formFieldHintText.withOpacity(0.5),
                    withoutCustomShape: false,
                  )
                : SubmitButtonWidget(
                    title:
                        "${translate(LocalizationKeys.payInvoice)!}  € ${(selectTenantForPayBloc.bookingDetailsModel?.subTotalGuestsPaid)?.toStringAsFixed(2)} ",
                    onClicked: () {
                      if (selectTenantForPayBloc
                                  .bookingDetailsModel?.payOption ==
                              2 &&
                          selectTenantForPayBloc
                                  .bookingDetailsModel!.tenantsSelected.length >
                              1) {
                        InvoicePayRentScreenV2.open(
                                context,
                                selectTenantForPayBloc.bookingDetailsModel!,
                                false,
                                widget.onBack,
                                openWithReplacement: true)
                            .then((value) => widget.onBack());
                      } else if (selectTenantForPayBloc
                                  .bookingDetailsModel?.payOption ==
                              2 &&
                          selectTenantForPayBloc.bookingDetailsModel!
                                  .tenantsSelected.length ==
                              1) {
                        showFeedbackMessage("Choose your Roommate ");
                      } else {
                        InvoicePayRentScreenV2.open(
                                context,
                                selectTenantForPayBloc.bookingDetailsModel!,
                                false,
                                widget.onBack,
                                openWithReplacement: true)
                            .then((value) => widget.onBack());
                      }
                    },
                    backgroundColor: AppColors.colorPrimary,
                  ),
          );
        },
      ),
    );
  }

  Widget tenantSelectedSummary(guestIndex, guestName, double guestSecurity,
      bool paidSecurity, double guestFees, double guestRent, bool paidRent) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10.r,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "${translate(LocalizationKeys.tenantNumber)} ${guestIndex + 1}",
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor),
        ),
        SizedBox(
          height: 5.r,
        ),
        Text(
          "${translate(LocalizationKeys.tenantName)} : ${guestName}",
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor),
        ),
        SizedBox(
          height: 5.r,
        ),
        Visibility(
          visible: guestFees != 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    translate(LocalizationKeys.serviceFee) ?? "",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor),
                  ),
                  Text(
                    "  ${paidSecurity ? translate(LocalizationKeys.paid) : translate(LocalizationKeys.unPaid) ?? ""}",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: paidSecurity
                            ? AppColors.success
                            : AppColors.appFormFieldErrorIBorder),
                  ),
                ],
              ),
              Text(
                "€ ${guestFees.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10.r,
        ),
        Visibility(
          visible: guestSecurity != 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    translate(LocalizationKeys.securityDeposit) ?? "",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor),
                  ),
                  Text(
                    "  ${paidSecurity ? translate(LocalizationKeys.paid) : translate(LocalizationKeys.unPaid) ?? ""}",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: paidSecurity
                            ? AppColors.success
                            : AppColors.appFormFieldErrorIBorder),
                  ),
                ],
              ),
              Text(
                "€ ${guestSecurity.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10.r,
        ),
        Visibility(
          visible: guestRent != 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    translate(LocalizationKeys.rentPrice) ?? "",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor),
                  ),
                  Text(
                    "  ${paidRent ? translate(LocalizationKeys.paid) : translate(LocalizationKeys.unPaid) ?? ""}",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: paidRent
                            ? AppColors.success
                            : AppColors.appFormFieldErrorIBorder),
                  ),
                ],
              ),
              Text(
                "€ ${guestRent.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20.r,
        )
      ]),
    );
  }
}
