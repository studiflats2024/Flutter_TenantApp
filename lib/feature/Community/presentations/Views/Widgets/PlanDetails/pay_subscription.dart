import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/payment_api_manger.dart';
import 'package:vivas/feature/contract/sign_contract/screen/sign_member_contract.dart';
import 'package:vivas/feature/payment/bloc/payment_bloc.dart';
import 'package:vivas/feature/payment/bloc/payment_repository.dart';
import 'package:vivas/feature/widgets/payment_widget/payment_url_widget.dart';

import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class PaySubscription extends StatelessWidget {
  PaySubscription({Key? key}) : super(key: key);
  static const routeName = '/pay-subscription-screen';
  static const argumentInvoiceId = 'invoiceId';
  static const argumentInvoiceUrl = 'invoiceUrl';


  static Future<void> open(
      BuildContext context,
      String invoiceId,
      String invoiceUrl,
      {bool openWithReplacement = false}) async {
    if (openWithReplacement) {
      await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
        argumentInvoiceId: invoiceId,
        argumentInvoiceUrl: invoiceUrl,
      });
    } else {
      await Navigator.of(context).pushNamed(routeName, arguments: {
        argumentInvoiceId: invoiceId,
        argumentInvoiceUrl: invoiceUrl,
      });
    }
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentBloc>(
      create: (context) => PaymentBloc(PaymentRepository(
        paymentApiManger: PaymentApiManger(dioApiManager, context),
      )),
      child: PaymentScreenWithBloc(invoiceId(context), invoiceUrl(context)),
    );
  }

  String invoiceId(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentInvoiceId]
          as String;

  String invoiceUrl(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentInvoiceUrl]
          as String;
}

class PaymentScreenWithBloc extends BaseStatefulScreenWidget {
  final String invoiceId;
  final String invoiceUrl;


  const PaymentScreenWithBloc(this.invoiceId, this.invoiceUrl,
      {super.key});

  @override
  BaseScreenState<PaymentScreenWithBloc> baseScreenCreateState() {
    return _PaymentScreenScreenWithBloc();
  }
}

class _PaymentScreenScreenWithBloc
    extends BaseScreenState<PaymentScreenWithBloc> {
  String? paymentUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(translate(LocalizationKeys.payments)!)),
      body: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is PaymentErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is PaymentUrlLoadedState) {
            paymentUrl = state.paymentUrl;
          } else if (state is PaymentPaidSuccessState) {

           SignMemberContract.open(context, true,);
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
    return PaymentUrlWidget(
      paymentUrl: widget.invoiceUrl,
      successCallback: _successPayment,
      failCallback: _failPayment,
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  PaymentBloc get currentBloc => BlocProvider.of<PaymentBloc>(context);

  void _getPaymentUrlApiEvent() {
    currentBloc.add(GetPaymentUrlApiEvent(widget.invoiceId));
  }

  Future<void> _successPayment(String url) async {
    currentBloc.add(CheckPaymentUrlApiEvent(url));
  }

  void _failPayment() {
    showFeedbackMessage(
        translate(LocalizationKeys.paymentFailPleaseTryAgainLater)!);
    Navigator.of(context).pop();
  }
}
