import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/managers/payment_api_manger.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_api_model.dart';
import 'package:vivas/feature/payment/screen/payment_screen.dart';
import 'package:vivas/feature/payment/screen/success_payment_screen.dart';
import 'package:vivas/feature/request_details/request_details/bloc/request_details_bloc.dart';
import 'package:vivas/feature/request_details/request_details/bloc/unit_details_repository.dart';
import 'package:vivas/feature/request_details/request_details/widget/invoice_widget.dart';

import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class InvoiceScreen extends StatelessWidget {
  InvoiceScreen({Key? key}) : super(key: key);
  static const routeName = '/invoice-screen';
  static const argumentApartmentRequestsApiModel = 'ApartmentRequestsApiModel';
  static const argumentPaidPercentage = 'paidPercentage';
  static const argumentpayCash = 'payCash';
  static Future<void> open(
      BuildContext context,
      ApartmentRequestsApiModel apartmentRequestsApiModel,
      int paidPercentage,
      bool payCash,
      {bool openWithReplacement = false}) async {
    if (openWithReplacement) {
      await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
        argumentApartmentRequestsApiModel: apartmentRequestsApiModel,
        argumentPaidPercentage: paidPercentage,
        argumentpayCash: payCash
      });
    } else {
      await Navigator.of(context).pushNamed(routeName, arguments: {
        argumentApartmentRequestsApiModel: apartmentRequestsApiModel,
        argumentPaidPercentage: paidPercentage,
        argumentpayCash: payCash
      });
    }
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RequestDetailsBloc>(
      create: (context) => RequestDetailsBloc(RequestDetailsRepository(
        apartmentRequestsApiManger: ApartmentRequestsApiManger(dioApiManager, context),
        paymentApiManger: PaymentApiManger(dioApiManager , context),
      )),
      child: InvoiceScreenWithBloc(apartmentRequestsApiModel(context),
          paidPercentage(context), payCash(context)),
    );
  }

  ApartmentRequestsApiModel apartmentRequestsApiModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[argumentApartmentRequestsApiModel]
          as ApartmentRequestsApiModel;
  int paidPercentage(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[argumentPaidPercentage] as int;

  bool payCash(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentpayCash]
          as bool;
}

class InvoiceScreenWithBloc extends BaseStatefulScreenWidget {
  final ApartmentRequestsApiModel apartmentRequestsApiModel;
  final int paidPercentage;
  final bool payCash;
  const InvoiceScreenWithBloc(
      this.apartmentRequestsApiModel, this.paidPercentage, this.payCash,
      {super.key});

  @override
  BaseScreenState<InvoiceScreenWithBloc> baseScreenCreateState() {
    return _InvoiceScreenScreenWithBloc();
  }
}

class _InvoiceScreenScreenWithBloc
    extends BaseScreenState<InvoiceScreenWithBloc> {
  InvoiceApiModel? _invoiceApiModel;
  @override
  void initState() {
    Future.microtask(_getInvoiceApiEvent);
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(translate(LocalizationKeys.invoice)!)),
      body: BlocListener<RequestDetailsBloc, RequestDetailsState>(
        listener: (context, state) {
          if (state is RequestDetailLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is RequestDetailErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is InvoiceLoadedState) {
            _invoiceApiModel = state.invoiceApiModel;
          } else if (state is CashPaymentSuccessState) {
            _openPaymentSuccessScreen();
          }
        },
        child: _detailsWidget(),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////
  Widget _detailsWidget() {
    return BlocBuilder<RequestDetailsBloc, RequestDetailsState>(
      buildWhen: (previous, current) => current is InvoiceLoadedState,
      builder: (context, state) {
        if (state is InvoiceLoadedState) {
          return InvoiceWidget(
            invoiceApiModel: state.invoiceApiModel,
            coveredPercentage: widget.paidPercentage,
            paymentClickedCallBack: _paymentClicked,
            //payWithPaypalClickedCallBack: _payWithPaypalClicked,
            payWithOnlineClickedCallBack: _payWithOnlineClicked,
            payWithCashClickedCallBack: _payWithCashClicked,
            payCash: widget.payCash,
          );
        } else {
          return const LoaderWidget();
        }
      },
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  RequestDetailsBloc get currentBloc =>
      BlocProvider.of<RequestDetailsBloc>(context);
  void _getInvoiceApiEvent() {
    currentBloc.add(GetInvoiceApiEvent(
        widget.apartmentRequestsApiModel.requestId, widget.paidPercentage));
  }

  // ignore: unused_element
  void _payWithPaypalClicked() {}

  void _paymentClicked() {
    if (widget.payCash) {
      PaymentSuccessfullyScreen.open(context);
    } else {
      PaymentScreen.open(context, _invoiceApiModel!.invId);
    }
  }

  void _payWithOnlineClicked() {
    PaymentScreen.open(context, _invoiceApiModel!.invId);
  }

  void _payWithCashClicked() {
    currentBloc.add(CashPaymentApiEvent(_invoiceApiModel!.invId));
  }

  void _openPaymentSuccessScreen() {
    PaymentSuccessfullyScreen.open(context);
  }
}
