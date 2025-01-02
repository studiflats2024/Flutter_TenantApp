import 'package:vivas/apis/managers/invoices_api_manger.dart';
import 'package:vivas/apis/managers/payment_api_manger.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/feature/invoices/bloc/invoices_bloc.dart';
import 'package:vivas/feature/invoices/helper/filter_enum.dart';
import 'package:vivas/preferences/preferences_manager.dart';

abstract class BaseInvoicesRepository {
  Future<InvoicesState> getInvoicesApi(
      int pageNumber, InvoicesFilter invoicesFilter);
  Future<InvoicesState> getInvoiceDetailsApi(String invoiceId);
  Future<InvoicesState> cashPaymentApi(String invoiceId);
}

class InvoicesRepository implements BaseInvoicesRepository {
  final PreferencesManager preferencesManager;
  final InvoicesApiManger invoicesApiManger;
  final PaymentApiManger paymentApiManger;

  InvoicesRepository({
    required this.preferencesManager,
    required this.invoicesApiManger,
    required this.paymentApiManger,
  });

  @override
  Future<InvoicesState> getInvoicesApi(
      int pageNumber, InvoicesFilter invoicesFilter) async {
    late InvoicesState invoicesState;
    await invoicesApiManger.getInvoicesApi(
        PagingListSendModel(
            pageNumber: pageNumber,
            status: invoicesFilter.getApiKey), (invoicesListWrapper) {
      invoicesState =
          InvoicesLoadedState(invoicesListWrapper.data, MetaModel.demo());
    }, (errorApiModel) {
      invoicesState = InvoicesErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return invoicesState;
  }

  @override
  Future<InvoicesState> getInvoiceDetailsApi(String invoiceId) async {
    late InvoicesState invoicesState;
    await invoicesApiManger.getInvoiceDetailsApi(invoiceId, (invoiceApiModel) {
      invoicesState = InvoiceDetailsLoadedState(invoiceApiModel);
    }, (errorApiModel) {
      invoicesState = InvoicesErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return invoicesState;
  }

  @override
  Future<InvoicesState> cashPaymentApi(String invoiceId) async {
    late InvoicesState invoicesState;

    await paymentApiManger.getPaymentUrlApi(invoiceId, true, (success) {
      invoicesState = const CashPaymentSuccessState();
    }, (errorApiModel) {
      invoicesState = InvoicesErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return invoicesState;
  }
}
