import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_api_model.dart';
import 'package:vivas/feature/widgets/app_buttons/app_elevated_button.dart';
import 'package:vivas/feature/widgets/dash_divider/dash_divider_widget.dart';

import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class InvoiceWidget extends BaseStatelessWidget {
  final InvoiceApiModel invoiceApiModel;
  final int coveredPercentage;
  //final VoidCallback payWithPaypalClickedCallBack;
  final VoidCallback paymentClickedCallBack;

  final VoidCallback payWithOnlineClickedCallBack;
  final VoidCallback payWithCashClickedCallBack;
  final bool payCash;
  InvoiceWidget(
      {super.key,
      required this.invoiceApiModel,
      required this.coveredPercentage,
      //required this.payWithPaypalClickedCallBack,
      required this.paymentClickedCallBack,
      required this.payWithOnlineClickedCallBack,
      required this.payWithCashClickedCallBack,
      required this.payCash});

  @override
  Widget baseBuild(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SingleChildScrollView(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 15,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _titleWidget(),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _invoiceInfoItem(
                            translate(LocalizationKeys.dateOfIssue)!,
                            AppDateFormat.formattingMonthDay(
                                invoiceApiModel.invIssue,
                                appLocale.locale.languageCode)),
                        _invoiceInfoItem(translate(LocalizationKeys.invoiceNo)!,
                            invoiceApiModel.invCode),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _invoiceInfoItem(
                            translate(LocalizationKeys.startDate)!,
                            AppDateFormat.formattingMonthDay(
                                invoiceApiModel.invStartDate,
                                appLocale.locale.languageCode)),
                        _invoiceInfoItem(
                            translate(LocalizationKeys.endDate)!,
                            AppDateFormat.formattingMonthDay(
                                invoiceApiModel.invEndDate,
                                appLocale.locale.languageCode)),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    const DashDividerWidget(),
                    SizedBox(height: 16.h),
                    _invoicePaymentItem(
                        "${translate(LocalizationKeys.securityDepositAmount)!} ($coveredPercentage%)",
                        invoiceApiModel.invSecDeposit),
                    if (invoiceApiModel.invServiceFee != 0) ...[
                      SizedBox(height: 12.h),
                      _invoicePaymentItem(
                          translate(LocalizationKeys.serviceFee)!,
                          invoiceApiModel.invServiceFee,
                          subTitle: translate(
                              LocalizationKeys.serviceFeePaidOneTime)!),
                    ],
                    SizedBox(height: 16.h),
                    const DashDividerWidget(width: .01),
                    SizedBox(height: 16.h),
                    _invoiceTotal(invoiceApiModel.invTotal),
                    SizedBox(height: 16.h),
                    _noteWidget(),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppElevatedButton.withTitle(
                  onPressed: paymentClickedCallBack,
                  title: payCash
                      ? translate(LocalizationKeys.confirmPayCash)!
                      : translate(LocalizationKeys.proceed)!),
            ),
          ),
          /* SubmitButtonWidget(
              title: payCash
                  ? translate(LocalizationKeys.confirmPayCash)!
                  : translate(LocalizationKeys.proceed)!,
              onClicked: paymentClickedCallBack), */
          /* SizedBox(height: 40.h),
          Text(
            translate(LocalizationKeys.chooseYourPaymentMethod)!,
            style: const TextStyle(
              color: Color(0xFF1D2838),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          PaymentMethodsWidget(
            canPayCash: invoiceApiModel.canPayCash,
            canPayOnline: invoiceApiModel.canPayOnline,
            payWithPaypalClickedCallBack: payWithPaypalClickedCallBack,
            payWithOnlineClickedCallBack: payWithOnlineClickedCallBack,
            payWithCashClickedCallBack: payWithCashClickedCallBack,
          ) */
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Column(
      children: [
        Text(
          invoiceApiModel.aptName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF1B1B2F),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          invoiceApiModel.aptAddress,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF475466),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _invoiceInfoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF475466),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1B1B2F),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _invoicePaymentItem(String title, num value, {String? subTitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF344053),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "€${value.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Color(0xFF0F1728),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (subTitle != null)
          Text(
            subTitle,
            style: const TextStyle(
              color: Color(0xFF667084),
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
    );
  }

  Widget _invoiceTotal(num total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          translate(LocalizationKeys.total)!,
          style: const TextStyle(
            color: Color(0xFF344053),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          "€${total.toStringAsFixed(2)}",
          style: const TextStyle(
            color: Color(0xFF0F1728),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _noteWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(LocalizationKeys.note)!,
          style: const TextStyle(
            color: Color(0xFF667084),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          translate(LocalizationKeys
              .afterTheLeasePeriodEndsYouCanRefundYourSecurityDeposit)!,
          style: const TextStyle(
            color: Color(0xFF667084),
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
