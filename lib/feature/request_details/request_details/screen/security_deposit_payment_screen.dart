//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/managers/payment_api_manger.dart';
import 'package:vivas/feature/request_details/request_details/bloc/request_details_bloc.dart';
import 'package:vivas/feature/request_details/request_details/bloc/unit_details_repository.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/feature/request_details/request_details/screen/invoice_screen.dart';
import 'package:vivas/feature/request_details/request_details/widget/security_deposit_payment_widget.dart';
import 'package:vivas/feature/unit_details/screen/unit_details_screen.dart';

import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class SecurityDepositPaymentScreen extends StatelessWidget {
  SecurityDepositPaymentScreen({Key? key}) : super(key: key);
  static const routeName = '/security-deposit-payment-screen';
  static const argumentApartmentRequestsApiModel = 'ApartmentRequestsApiModel';

  static Future<void> open(
      BuildContext context, ApartmentRequestsApiModel apartmentRequestsApiModel,
      {bool openWithReplacement = false}) async {
    if (openWithReplacement) {
      await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
        argumentApartmentRequestsApiModel: apartmentRequestsApiModel,
      });
    } else {
      await Navigator.of(context).pushNamed(routeName, arguments: {
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
        paymentApiManger: PaymentApiManger(dioApiManager , context),
      )),
      child: SecurityDepositPaymentScreenWithBloc(
          apartmentRequestsApiModel(context)),
    );
  }

  ApartmentRequestsApiModel apartmentRequestsApiModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[
              SecurityDepositPaymentScreen.argumentApartmentRequestsApiModel]
          as ApartmentRequestsApiModel;
}

class SecurityDepositPaymentScreenWithBloc extends BaseStatefulScreenWidget {
  final ApartmentRequestsApiModel apartmentRequestsApiModel;
  const SecurityDepositPaymentScreenWithBloc(this.apartmentRequestsApiModel,
      {super.key});

  @override
  BaseScreenState<SecurityDepositPaymentScreenWithBloc>
      baseScreenCreateState() {
    return _SecurityDepositPaymentScreenScreenWithBloc();
  }
}

class _SecurityDepositPaymentScreenScreenWithBloc
    extends BaseScreenState<SecurityDepositPaymentScreenWithBloc> {
  bool _acceptTermsConditions = false;
  int _selectedPercentageDeposit = 0;

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(translate(LocalizationKeys.securityDepositPayment)!)),
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
          } else if (state is ChangePercentageDepositState) {
            _selectedPercentageDeposit = state.percentageDeposit;
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
    return SecurityDepositPaymentWidget(
      acceptTermsConditions: _acceptTermsConditions,
      selectedPercentageDeposit: _selectedPercentageDeposit,
      apartmentRequestsApiModel: widget.apartmentRequestsApiModel,
      proceedClickedCallBack: canProceed ? _proceedClicked : null,
      changeDepositCallBack: changeDeposit,
      changeTCCallBack: _changeTCCallBack,
      unitInfoWidgetClickedCallBack: _unitInfoWidgetClicked,
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  RequestDetailsBloc get currentBloc =>
      BlocProvider.of<RequestDetailsBloc>(context);

  bool get canProceed =>
      _acceptTermsConditions && (_selectedPercentageDeposit != 0);

  void _unitInfoWidgetClicked() {
    UnitDetailsScreen.open(context, widget.apartmentRequestsApiModel.unitId,
        viewOnlyMode: true);
  }

  void _changeTCCallBack(bool value) {
    currentBloc.add(ChangeAcceptTermsConditionEvent(value));
  }

  void changeDeposit(int value) {
    currentBloc.add(ChangePercentageDepositEvent(value));
  }

  Future<void> _proceedClicked() async {
    await InvoiceScreen.open(context, widget.apartmentRequestsApiModel,
        _selectedPercentageDeposit, false);
  }
}
