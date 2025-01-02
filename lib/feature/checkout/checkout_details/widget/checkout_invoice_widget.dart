import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/feature/invoices/screen/invoices_details_screen.dart';
import 'package:vivas/feature/widgets/app_buttons/app_elevated_button.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class CheckoutInvoiceWidget extends BaseStatelessWidget {
  final NextInvoiceModel nextInvoiceModel;
  CheckoutInvoiceWidget(
    this.nextInvoiceModel, {
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${translate(LocalizationKeys.invoice)!} - ${translate(LocalizationKeys.checkOut)!}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xCC3C3C43),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
          child: Text(
            "€ ${nextInvoiceModel.invTotal}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 30.h),
        const Divider(height: 2, color: Color(0xFFEAECF0)),
        SizedBox(height: 30.h),
        AppElevatedButton.withTitle(
            onPressed: () => _payClicked(context),
            title: translate(LocalizationKeys.payItNow)!),
        SizedBox(height: 10.h),
      ],
    );
  }

  void _payClicked(BuildContext context) {
    Navigator.of(context).pop();
    InvoicesDetailsScreen.open(context, nextInvoiceModel.monthInvID,
        isMonthlyInvoice: true);
  }
}
