import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/managers/payment_api_manger.dart';
import 'package:vivas/feature/request_details/request_details/bloc/request_details_bloc.dart';
import 'package:vivas/feature/request_details/request_details/bloc/unit_details_repository.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/feature/request_details/request_details/screen/invoice_screen.dart';
import 'package:vivas/feature/request_details/request_details/widget/security_deposit_widget.dart';

import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class SecurityDepositScreen extends StatelessWidget {
  SecurityDepositScreen({Key? key}) : super(key: key);
  static const routeName = '/security-deposit-screen';
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
        paymentApiManger: PaymentApiManger(dioApiManager , context),
      )),
      child:
          CompleteYourBookingScreenWithBloc(apartmentRequestsApiModel(context)),
    );
  }

  ApartmentRequestsApiModel apartmentRequestsApiModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[SecurityDepositScreen.argumentApartmentRequestsApiModel]
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
  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(translate(LocalizationKeys.securityDeposit)!)),
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
          child: SecurityDepositWidget(
            apartmentRequestsApiModel: widget.apartmentRequestsApiModel,
            payNowtClickedCallBack: _payNowtClicked,
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

  Future<void> _payNowtClicked() async {
    await InvoiceScreen.open(
        context,
        widget.apartmentRequestsApiModel,
        widget.apartmentRequestsApiModel.coveredRemainPercentage.toInt(),
        false);
  }
}
