import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/managers/payment_api_manger.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/feature/request_details/request_details/bloc/request_details_bloc.dart';
import 'package:vivas/feature/request_details/request_details/bloc/unit_details_repository.dart';
import 'package:vivas/feature/request_details/request_details/screen/invoice_screen.dart';
import 'package:vivas/feature/request_details/request_details/screen/security_deposit_payment_screen.dart';
import 'package:vivas/feature/request_details/request_details/widget/complete_your_booking_widget.dart';
import 'package:vivas/feature/request_details/request_details/widget/payment_methods_widget.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';

import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class CompleteYourBookingScreen extends StatelessWidget {
  CompleteYourBookingScreen({Key? key}) : super(key: key);
  static const routeName = '/complete-your-booking-screen';
  static const argumentApartmentRequestsApiModel = 'ApartmentRequestsApiModel';

  static Future<void> open(
      BuildContext context, ApartmentRequestsApiModel apartmentRequestsApiModel,
      {bool openWithReplacement = false}) async {
    if (openWithReplacement) {
      await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
        argumentApartmentRequestsApiModel: apartmentRequestsApiModel,
      });
    } else {
      Navigator.of(context).pushNamed(routeName, arguments: {
        argumentApartmentRequestsApiModel: apartmentRequestsApiModel,
      });
    }
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RequestDetailsBloc>(
      create: (context) => RequestDetailsBloc(RequestDetailsRepository(
          apartmentRequestsApiManger: ApartmentRequestsApiManger(dioApiManager, context),
          paymentApiManger: PaymentApiManger(dioApiManager , context))),
      child:
          CompleteYourBookingScreenWithBloc(apartmentRequestsApiModel(context)),
    );
  }

  ApartmentRequestsApiModel apartmentRequestsApiModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[
              CompleteYourBookingScreen.argumentApartmentRequestsApiModel]
          as ApartmentRequestsApiModel;
}

class CompleteYourBookingScreenWithBloc extends BaseStatefulScreenWidget {
  final ApartmentRequestsApiModel apartmentRequestsApiModel;
  const CompleteYourBookingScreenWithBloc(this.apartmentRequestsApiModel,
      {super.key});

  @override
  BaseScreenState<CompleteYourBookingScreenWithBloc> baseScreenCreateState() {
    return _CompleteYourBookingScreenScreenWithBloc();
  }
}

class _CompleteYourBookingScreenScreenWithBloc
    extends BaseScreenState<CompleteYourBookingScreenWithBloc> {
  bool _acceptTermsConditions = false;

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(translate(LocalizationKeys.completeYourBooking)!)),
      body: BlocConsumer<RequestDetailsBloc, RequestDetailsState>(
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
          } else if (state is ChangeAcceptTermsConditionState) {
            _acceptTermsConditions = state.acceptTermsCondition;
          }
          if (state is InvoiceLoadedState) {
            _openCashScreen(state.invoiceApiModel.invId);
          }

          if (state is CashPaymentSuccessState) {
            _openInvoiceCash();
          }
        },
        builder: (context, state) => _detailsWidget(),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////
  Widget _detailsWidget() {
    return Column(
      children: [
        SizedBox(height: 30.h),
        Center(
          child: CompleteYourBookingWidget(
            apartmentRequestsApiModel: widget.apartmentRequestsApiModel,
            acceptTermsConditions: _acceptTermsConditions,
            changeTCCallBack: _changeTCCallBack,
            payLaterClickedCallBack: _payLaterClicked,
            payNowtClickedCallBack: canPayNow ? _payNowtClicked : null,
          ),
        ),
      ],
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  RequestDetailsBloc get currentBloc =>
      BlocProvider.of<RequestDetailsBloc>(context);
  bool get canPayNow => _acceptTermsConditions;
  void _changeTCCallBack(bool value) {
    currentBloc.add(ChangeAcceptTermsConditionEvent(value));
  }

  void _openCashScreen(String invID) {
    currentBloc.add(CashPaymentApiEvent(invID));
  }

  void _openInvoiceCash() async {
    await InvoiceScreen.open(
        context, widget.apartmentRequestsApiModel, 100, true);
  }

  void _payLaterClicked() {
    Navigator.of(context).pop();
  }

  void _payNowtClicked() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: PaymentMethodsWidget(
          canPayOnline: widget.apartmentRequestsApiModel.canPayOnline,
          canPayCash: widget.apartmentRequestsApiModel.canPayCash,
          payWithCashClickedCallBack: _payWithCashClicked,
          payWithOnlineClickedCallBack: _payWithOnlineClicked,
          payWithPaypalClickedCallBack: _payWithPaypalClicked,
        ),
        title: translate(LocalizationKeys.paymentMethod)!);
    /*  SecurityDepositPaymentScreen.open(
        context, widget.apartmentRequestsApiModel); */
  }

  void _payWithPaypalClicked() {}

  void _payWithOnlineClicked() {
    SecurityDepositPaymentScreen.open(
        context, widget.apartmentRequestsApiModel);
    //on pay invoice
    // PaymentScreen.open(context, "a0be897a-d63a-43dd-6605-08dc28834775");
  }

  void _payWithCashClicked() {
    currentBloc.add(
        GetInvoiceApiEvent(widget.apartmentRequestsApiModel.requestId, 100));

    //currentBloc.add(CashPaymentApiEvent(widget.apartmentRequestsApiModel));
  }
}
