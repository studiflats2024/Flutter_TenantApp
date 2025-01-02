import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/feature/invoices/screen/invoices_screen.dart';
import 'package:vivas/feature/payments_invoices/widget/payment_invoice_item_widget.dart';
import 'package:vivas/feature/saved_card/saved_card_screen.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class PaymentsInvoicesScreen extends BaseStatefulScreenWidget {
  static const routeName = '/payments-invoices-screen';
  const PaymentsInvoicesScreen({super.key});
  static open(BuildContext context) async {
    await Navigator.of(context).pushNamed(routeName);
  }

  @override
  BaseScreenState<PaymentsInvoicesScreen> baseScreenCreateState() {
    return _PaymentsInvoicesScreen();
  }
}

class _PaymentsInvoicesScreen extends BaseScreenState<PaymentsInvoicesScreen> {
  @override
  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.paymentsInvoices)!),
      ),
      body: _listWidget(),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _listWidget() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          PaymentInvoiceItemWidget(
            title: translate(LocalizationKeys.savedPayments)!,
            logoPath: AppAssetPaths.cardIcon,
            onClickCallBack: _openPaymentScreen,
          ),
          PaymentInvoiceItemWidget(
            title: translate(LocalizationKeys.invoices)!,
            logoPath: AppAssetPaths.invoiceIcon,
            onClickCallBack: _openInvoicesScreen,
          ),
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  Future<void> _openPaymentScreen() async {
    await SavedCardScreen.open(context);
  }

  Future<void> _openInvoicesScreen() async {
    await InvoicesScreen.open(context);
  }
}
