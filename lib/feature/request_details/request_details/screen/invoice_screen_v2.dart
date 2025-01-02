import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/managers/payment_api_manger.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_model.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/feature/contract/sign_contract/screen/sign_contract_screen_v2.dart';
import 'package:vivas/feature/payment/screen/payment_screen_v2.dart';
import 'package:vivas/feature/payment/screen/success_payment_screen.dart';
import 'package:vivas/feature/request_details/request_details/bloc/request_details_bloc.dart';
import 'package:vivas/feature/request_details/request_details/bloc/unit_details_repository.dart';
import 'package:vivas/feature/request_details/request_details/widget/invoice_widget_v2.dart';

import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../../payment/screen/success_payment_screen_v2.dart';

class InvoiceScreenV2 extends StatelessWidget {
  InvoiceScreenV2({Key? key}) : super(key: key);
  static const routeName = '/invoice-screen-v2';
  static const argumentApartmentRequestsApiModel = 'ApartmentRequestsApiModel';
  static const argumentFunctionBack = 'function-call-back';

  static Future<void> open(BuildContext context,
      BookingDetailsModel apartmentRequestsApiModel, Function() callback,
      {bool openWithReplacement = false}) async {
    if (openWithReplacement) {
      await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
        argumentApartmentRequestsApiModel: apartmentRequestsApiModel,
        argumentFunctionBack: callback,
      });
    } else {
      await Navigator.of(context).pushNamed(routeName, arguments: {
        argumentApartmentRequestsApiModel: apartmentRequestsApiModel,
        argumentFunctionBack: callback,
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
          apartmentRequestsApiModel(context), onBack(context)),
    );
  }

  BookingDetailsModel apartmentRequestsApiModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[argumentApartmentRequestsApiModel] as BookingDetailsModel;

  Function() onBack(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentFunctionBack]
          as Function();
}

class InvoiceScreenWithBloc extends BaseStatefulScreenWidget {
  final BookingDetailsModel apartmentRequestsApiModel;
  final Function() onBack;

  const InvoiceScreenWithBloc(this.apartmentRequestsApiModel, this.onBack,
      {super.key});

  @override
  BaseScreenState<InvoiceScreenWithBloc> baseScreenCreateState() {
    return _InvoiceScreenScreenWithBloc();
  }
}

class _InvoiceScreenScreenWithBloc
    extends BaseScreenState<InvoiceScreenWithBloc> {
  InvoiceModel? _invoiceApiModel;

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
          } else if (state is InvoiceLoadedStateV2) {
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
      // buildWhen: (previous, current) => current is InvoiceLoadedStateV2,
      builder: (context, state) {
        if (state is InvoiceLoadedStateV2) {
          return InvoiceWidgetV2(
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
    currentBloc.add(GetInvoiceApiEventV2(
      widget.apartmentRequestsApiModel.bookingId ?? "",
      widget.apartmentRequestsApiModel
              .guests?[widget.apartmentRequestsApiModel.guestIndex].guestId ??
          "",
    ));
  }

  // ignore: unused_element
  void _payWithPaypalClicked() {}

  // void _paymentClicked() {
  //   if (_invoiceApiModel?.isSecuirtyRequired??false) {
  //     PaymentSuccessfullyScreenV2.open(context , widget.apartmentRequestsApiModel);
  //   }
  // }

  void _payWithOnlineClicked() {
    PaymentScreenV2.open(
            context,
            _invoiceApiModel!.invoiceId ?? "0",
            _invoiceApiModel!.invoiceUrl ?? "",
            true,
            widget.apartmentRequestsApiModel,
            widget.onBack,
            openWithReplacement: true)
        .then((value) => widget.onBack());
  }

  void _payWithPayLaterClicked() {
    // currentBloc.add(CashPaymentApiEvent(_invoiceApiModel!.invoiceId??""));
    SignContractScreenV2.open(
        context, widget.apartmentRequestsApiModel, true, widget.onBack);
  }

  void _openPaymentSuccessScreen() {
    PaymentSuccessfullyScreenV2.open(
        context, widget.apartmentRequestsApiModel,
        widget.onBack,
        false,
        goToSignContract: true);
  }
}
