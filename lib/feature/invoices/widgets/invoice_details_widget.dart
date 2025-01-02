import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_api_model.dart';
import 'package:vivas/feature/invoices/widgets/invoice_state_widget.dart';
import 'package:vivas/feature/widgets/dash_divider/dash_divider_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';

import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class InvoiceDetailsWidget extends BaseStatelessWidget {
  final InvoiceApiModel invoiceApiModel;
  final bool isMonthlyInvoice;

  final VoidCallback downloadClickedCallBack;
  final VoidCallback payNowClickedCallBack;
  InvoiceDetailsWidget({
    super.key,
    required this.invoiceApiModel,
    required this.isMonthlyInvoice,
    required this.downloadClickedCallBack,
    required this.payNowClickedCallBack,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                    if (isMonthlyInvoice || invoiceApiModel.isMonthly) ...[
                      const DashDividerWidget(),
                      SizedBox(height: 16.h),
                      _invoicePaymentItem(
                          translate(LocalizationKeys.monthlyRent)!,
                          "€${invoiceApiModel.invTotal.toStringAsFixed(2)}")
                    ],
                    if (invoiceApiModel.invSecDeposit != 0) ...[
                      const DashDividerWidget(),
                      SizedBox(height: 12.h),
                      _invoicePaymentItem(
                          translate(LocalizationKeys.securityDepositAmount)!,
                          "€${invoiceApiModel.invSecDeposit.toStringAsFixed(2)}"),
                    ],
                    if (invoiceApiModel.invServiceFee != 0) ...[
                      const DashDividerWidget(),
                      SizedBox(height: 12.h),
                      _invoicePaymentItem(
                          translate(LocalizationKeys.serviceFee)!,
                          "€${invoiceApiModel.invServiceFee.toStringAsFixed(2)}",
                          subTitle: translate(
                              LocalizationKeys.serviceFeePaidOneTime)!),
                    ],
                    SizedBox(height: 16.h),
                    const DashDividerWidget(width: .01),
                    SizedBox(height: 16.h),
                    _invoiceTotal(invoiceApiModel.invTotal),
                    SizedBox(height: 16.h),
                    if (invoiceApiModel.invPaid) ...[
                      _invoicePaymentItem(
                          translate(LocalizationKeys.paymentMethod)!,
                          invoiceApiModel.invType),
                      SizedBox(height: 16.h),
                    ],
                    if (!isMonthlyInvoice) ...[
                      _noteWidget(),
                      SizedBox(height: 16.h),
                    ],
                    invoiceApiModel.invPaid
                        ? _downloadButton()
                        : _payNowButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Row(
      children: [
        Expanded(
          child: Column(
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
          ),
        ),
        const SizedBox(width: 5),
        InvoiceStateWidget(invoiceApiModel.invPaid),
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

  Widget _invoicePaymentItem(String title, String value, {String? subTitle}) {
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
              value,
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
            fontWeight: FontWeight.w600,
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

  Widget _downloadButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: downloadClickedCallBack,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: const Color(0xFFEAEEF3),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssetPaths.downloadIcon),
              SizedBox(width: 10.w),
              Text(
                translate(LocalizationKeys.downloadInvoice)!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF2D4568),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _payNowButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: payNowClickedCallBack,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: const Color(0xFF1151B4),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Text(
            translate(LocalizationKeys.payNow)!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
