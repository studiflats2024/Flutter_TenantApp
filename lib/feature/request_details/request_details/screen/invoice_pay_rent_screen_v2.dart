import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/managers/payment_api_manger.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_rent_model.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/feature/payment/screen/payment_screen_v2.dart';
import 'package:vivas/feature/payment/screen/success_payment_screen.dart';
import 'package:vivas/feature/payment/screen/success_payment_screen_v2.dart';
import 'package:vivas/feature/request_details/request_details/bloc/request_details_bloc.dart';
import 'package:vivas/feature/request_details/request_details/bloc/unit_details_repository.dart';
import 'package:vivas/feature/request_details/request_details/widget/invoice_pay_rent_widget_v2.dart';

import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class InvoicePayRentScreenV2 extends StatelessWidget {
  InvoicePayRentScreenV2({Key? key}) : super(key: key);
  static const routeName = '/invoice-pay-rent-screen-v2';
  static const argumentApartmentRequestsApiModel = 'ApartmentRequestsApiModel';
  static const argumentIsMonthlyInvoices = "is-monthly-invoice";
  static const argumentFunctionBack = 'function-call-back';

  static Future<void> open(
      BuildContext context,
      BookingDetailsModel apartmentRequestsApiModel,
      bool isMonthlyInvoices,
      Function() onBack,
      {bool openWithReplacement = false}) async {
    if (openWithReplacement) {
      await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
        argumentApartmentRequestsApiModel: apartmentRequestsApiModel,
        argumentIsMonthlyInvoices: isMonthlyInvoices,
        argumentFunctionBack: onBack,
      });
    } else {
      await Navigator.of(context).pushNamed(routeName, arguments: {
        argumentApartmentRequestsApiModel: apartmentRequestsApiModel,
        argumentIsMonthlyInvoices: isMonthlyInvoices,
        argumentFunctionBack: onBack,
      });
    }
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RequestDetailsBloc>(
      create: (context) => RequestDetailsBloc(RequestDetailsRepository(
        apartmentRequestsApiManger:
            ApartmentRequestsApiManger(dioApiManager, context),
        paymentApiManger: PaymentApiManger(dioApiManager, context),
      )),
      child: InvoiceScreenWithBloc(
        apartmentRequestsApiModel(context),
        isMonthlyInvoices(context),
        onBack(context),
      ),
    );
  }

  BookingDetailsModel apartmentRequestsApiModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[argumentApartmentRequestsApiModel] as BookingDetailsModel;

  bool isMonthlyInvoices(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[argumentIsMonthlyInvoices] as bool;

  Function() onBack(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentFunctionBack]
          as Function();
}

class InvoiceScreenWithBloc extends BaseStatefulScreenWidget {
  final BookingDetailsModel apartmentRequestsApiModel;
  final bool isMonthlyInvoices;
  final Function() onBack;

  const InvoiceScreenWithBloc(
      this.apartmentRequestsApiModel, this.isMonthlyInvoices, this.onBack,
      {super.key});

  @override
  BaseScreenState<InvoiceScreenWithBloc> baseScreenCreateState() {
    return _InvoiceScreenScreenWithBloc();
  }
}

class _InvoiceScreenScreenWithBloc
    extends BaseScreenState<InvoiceScreenWithBloc> {
  InvoiceRentModel? _invoiceApiModel;

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
          } else if (state is InvoicePayRentLoadedStateV2) {
            _invoiceApiModel = state.invoiceApiModel;
          } else if (state is CashPaymentSuccessState) {
            _openPaymentSuccessScreen(true);
          } else if (state is OnlinePaymentSuccessState) {
            PaymentScreenV2.open(
                context,
                _invoiceApiModel!.invoiceCode![0] ?? "",
                state.invoiceUrl,
                false,
                widget.apartmentRequestsApiModel,
                widget.onBack,
                openWithReplacement: true).then((value) => widget.onBack());
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
      buildWhen: (previous, current) => current is InvoicePayRentLoadedStateV2,
      builder: (context, state) {
        if (state is InvoicePayRentLoadedStateV2) {
          return InvoicePayRentWidgetV2(
            invoiceApiModel: state.invoiceApiModel,
            payWithOnlineClickedCallBack: _payWithOnlineClicked,
            payWithPayLaterClickedCallBack: _payWithPayLaterClicked,
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
    currentBloc.add(GetInvoicePayRentApiEventV2(
      widget.apartmentRequestsApiModel.bookingId ?? "",
      widget.isMonthlyInvoices
          ? widget.apartmentRequestsApiModel.tenantsMonthlyInvoicesSelected
          : widget.apartmentRequestsApiModel.tenantsSelected,
    ));
  }

  void _payWithOnlineClicked() {
    currentBloc
        .add(CashPaymentApiEventV2(_invoiceApiModel?.invoiceCode ?? [], false));
  }

  void _payWithPayLaterClicked() {
    currentBloc
        .add(CashPaymentApiEventV2(_invoiceApiModel?.invoiceCode ?? [], true));
  }

  void _openPaymentSuccessScreen(fromCash) {
    PaymentSuccessfullyScreenV2.open(
        context, widget.apartmentRequestsApiModel, widget.onBack, fromCash);
  }
}
