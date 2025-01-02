import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/invoices_api_manger.dart';
import 'package:vivas/apis/managers/payment_api_manger.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_api_model.dart';

import 'package:vivas/feature/invoices/bloc/invoices_bloc.dart';
import 'package:vivas/feature/invoices/bloc/invoices_repository.dart';
import 'package:vivas/feature/invoices/widgets/invoice_details_widget.dart';
import 'package:vivas/feature/invoices/widgets/invoice_payment_methods_widget.dart';
import 'package:vivas/feature/payment/screen/payment_screen.dart';
import 'package:vivas/feature/payment/screen/success_payment_screen.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';

import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/no_result/no_result_found.dart';

class InvoicesDetailsScreen extends StatelessWidget {
  InvoicesDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/invoices-details-screen';
  static const argumentInvoiceId = 'invoiceId';
  static const argumentIsMonthlyInvoice = 'isMonthlyInvoice';

  static open(BuildContext context, String invoiceId,
      {bool isMonthlyInvoice = false}) async {
    await Navigator.of(context).pushNamed(routeName, arguments: {
      argumentInvoiceId: invoiceId,
      argumentIsMonthlyInvoice: isMonthlyInvoice,
    });
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoicesBloc>(
      create: (context) => InvoicesBloc(InvoicesRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        invoicesApiManger: InvoicesApiManger(dioApiManager , context),
        paymentApiManger: PaymentApiManger(dioApiManager , context),
      )),
      child: InvoicesDetailsScreenWithBloc(
          invoiceId(context), isMonthlyInvoice(context)),
    );
  }

  String invoiceId(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentInvoiceId]
          as String;
  bool isMonthlyInvoice(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[argumentIsMonthlyInvoice] as bool;
}

class InvoicesDetailsScreenWithBloc extends BaseStatefulScreenWidget {
  final String invoiceId;
  final bool isMonthlyInvoice;
  const InvoicesDetailsScreenWithBloc(this.invoiceId, this.isMonthlyInvoice,
      {super.key});

  @override
  BaseScreenState<InvoicesDetailsScreenWithBloc> baseScreenCreateState() {
    return _InvoicesDetailsScreenWithBloc();
  }
}

class _InvoicesDetailsScreenWithBloc
    extends BaseScreenState<InvoicesDetailsScreenWithBloc> {
  InvoiceApiModel? _invoiceApiModel;
  @override
  void initState() {
    Future.microtask(() => _getInvoicesDetailsApiEvent());
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.invoiceDetails)!),
      ),
      body: BlocListener<InvoicesBloc, InvoicesState>(
        listener: (context, state) {
          if (state is InvoicesLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is InvoicesErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is InvoiceDetailsLoadedState) {
            _invoiceApiModel = state.invoiceApiModel;
          } else if (state is CashPaymentSuccessState) {
            _openPaymentSuccessScreen();
          }
        },
        child: BlocBuilder<InvoicesBloc, InvoicesState>(
          builder: (context, state) {
            if (state is InvoicesLoadingState) {
              return const LoaderWidget();
            } else if (state is InvoiceDetailsLoadedState) {
              return _invoicesDetailWidget();
            } else {
              if (_invoiceApiModel != null) {
                return _invoicesDetailWidget();
              } else {
                return NoResultFoundWidget();
              }
            }
          },
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////
  Widget _invoicesDetailWidget() {
    return InvoiceDetailsWidget(
      invoiceApiModel: _invoiceApiModel!,
      isMonthlyInvoice: widget.isMonthlyInvoice,
      downloadClickedCallBack: _downloadClick,
      payNowClickedCallBack: _payNowClicked,
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  InvoicesBloc get currentBloc => BlocProvider.of<InvoicesBloc>(context);

  void _getInvoicesDetailsApiEvent() {
    currentBloc.add(GetInvoiceDetailsEvent(widget.invoiceId));
  }

  Future<void> _downloadClick() async {
    try {
      await launchUrlString(_invoiceApiModel!.downloadUrl,
          mode: LaunchMode.externalApplication);
    } catch (e) {
      showFeedbackMessage(translate(LocalizationKeys.urlNotValid)!);
    }
  }

  void _payNowClicked() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: InvoicePaymentMethodsWidget(
          canPayOnline: _invoiceApiModel!.canPayOnline,
          canPayCash: _invoiceApiModel!.canPayCash,
          payWithOnlineClickedCallBack: _payWithOnlineClicked,
          payWithCashClickedCallBack: _payWithCashClicked,
        ),
        title: translate(LocalizationKeys.paymentMethod)!);
  }

  void _payWithCashClicked() {
    _closeSheet();
    currentBloc.add(CashPaymentApiEvent(_invoiceApiModel!.invId));
  }

  void _payWithOnlineClicked() {
    _closeSheet();
    PaymentScreen.open(context, _invoiceApiModel!.invId);
  }

  void _openPaymentSuccessScreen() {
    PaymentSuccessfullyScreen.open(context);
  }

  void _closeSheet() {
    Navigator.of(context).pop();
  }
}
