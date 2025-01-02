import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_api_model.dart';
import 'package:vivas/feature/invoices/widgets/invoice_state_widget.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class InvoicesItemWidget extends BaseStatelessWidget {
  final InvoiceApiModel invoiceApiModel;
  final void Function(InvoiceApiModel) cardClickCallback;
  InvoicesItemWidget(
      {super.key,
      required this.invoiceApiModel,
      required this.cardClickCallback});

  @override
  Widget baseBuild(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => cardClickCallback(invoiceApiModel),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleWidget(),
            SizedBox(height: 10.h),
            _dateNumberWidget(),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(LocalizationKeys.total)!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF344053),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '€${invoiceApiModel.invTotal}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF0F1728),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            invoiceApiModel.aptName,
            style: const TextStyle(
              color: Color(0xFF1B1B2F),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 5),
        InvoiceStateWidget(invoiceApiModel.invPaid),
      ],
    );
  }

  Widget _dateNumberWidget() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate(LocalizationKeys.dateOfIssue)!,
                style: const TextStyle(
                  color: Color(0xFF667084),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                AppDateFormat.formattingMonthDay(
                    invoiceApiModel.invIssue, appLocale.locale.languageCode),
                maxLines: 1,
                style: const TextStyle(
                  color: Color(0xFF344053),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
        Container(
          width: 1,
          color: Colors.grey,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          height: 40,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate(LocalizationKeys.invoiceNo)!,
                style: const TextStyle(
                  color: Color(0xFF667084),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                invoiceApiModel.invCode,
                maxLines: 1,
                style: const TextStyle(
                  color: Color(0xFF344053),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
