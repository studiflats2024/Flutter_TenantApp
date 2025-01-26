// ignore_for_file: unused_import, unused_element

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/checkout_api_manager.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/apis/models/checkout/bank_details_model.dart';
import 'package:vivas/apis/models/checkout/checkoutsheet.dart';
import 'package:vivas/apis/models/checkout/post_bank_details_send_model.dart';
import 'package:vivas/feature/bottom_navigation/screen/bottom_navigation_screen.dart';
import 'package:vivas/feature/checkout/checkout_details/bloc/checkout_bloc.dart';
import 'package:vivas/feature/checkout/checkout_details/bloc/checkout_repository.dart';
import 'package:vivas/feature/checkout/checkout_details/widget/bank_details_widget.dart';
import 'package:vivas/feature/checkout/checkout_details/widget/checkout_invoice_widget.dart';
import 'package:vivas/feature/checkout/checkout_details/widget/checkout_item_widget.dart';
import 'package:vivas/feature/checkout/checkout_details/widget/checkout_sheet_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/utils/empty_result/status_widget.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';

class CheckoutDetailsScreen extends StatelessWidget {
  CheckoutDetailsScreen({super.key});

  static const routeName = '/checkout-details-screen';
  static const argumentRequestId = 'requestId';

  static Future<void> open(BuildContext context, String requestId) async {
    await Navigator.of(context).pushNamed(routeName, arguments: {
      argumentRequestId: requestId,
    });
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckoutDetailsBloc>(
      create: (context) => CheckoutDetailsBloc(CheckoutRepository(
          checkoutApiManger: CheckoutApiManger(dioApiManager , context))),
      child: CheckoutDetailsScreenWithBloc(requestId(context)),
    );
  }

  String requestId(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[CheckoutDetailsScreen.argumentRequestId] as String;
}

class CheckoutDetailsScreenWithBloc extends BaseStatefulScreenWidget {
  final String requestId;

  const CheckoutDetailsScreenWithBloc(this.requestId, {super.key});

  @override
  BaseScreenState<CheckoutDetailsScreenWithBloc> baseScreenCreateState() {
    return _CheckoutDetailsScreenWithBloc();
  }
}

class _CheckoutDetailsScreenWithBloc
    extends BaseScreenState<CheckoutDetailsScreenWithBloc> {
  CheckoutSheet? _checkoutSheetResponse;
  BankDetailsModel? _bankDetailsModel;

  @override
  void initState() {
    Future.microtask(_getCheckoutDetailsApiEvent);
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(translate(LocalizationKeys.checkOutSheetDetails)!)),
      body: BlocConsumer<CheckoutDetailsBloc, CheckoutDetailsState>(
        listener: (context, state) {
          if (state is CheckoutDetailsLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }
          if (state is CheckoutDetailsErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is CheckoutDetailsLoadedState) {
            _checkoutSheetResponse = state.response;
          } else if (state is CheckoutBankDetailsFormValidatedState) {
            _closeScreen();
            _confirmBankDetailsApiEvent();
          } else if (state is ConfirmBankDetailsSentSuccessfullyState) {
            _closeScreen();
            showConfirmBankDetailsBottomSheet();
          }
        },
        //builder: (context, state) => _sheetDetailsWidget(),
        builder: (context, state) {
          if (state is CheckoutDetailsLoadingState) {
            return const LoaderWidget();
          } else if (state is CheckoutDetailsLoadedState) {
            return _sheetDetailsWidget();
          } else {
            if (_checkoutSheetResponse == null) {
              return _noUnitData();
            } else {
              return const LoaderWidget();
            }
          }
        },
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _sheetDetailsWidget() {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _priceWidget(translate(LocalizationKeys.paidSecurityDeposit)!,
            _checkoutSheetResponse?.paidSecuirty ?? 0),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            translate(
                LocalizationKeys.listOfIssuesProblemsYouWillHaveToPayFor)!,
            maxLines: 1,
            style: const TextStyle(
              color: Color(0xFF484649),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => CheckOutItemWidget(
                  _checkoutSheetResponse?.issueCheckouts?[index].issueCode ??
                      "",
                  _checkoutSheetResponse?.issueCheckouts?[index].issueDesc ??
                      "",
                  _checkoutSheetResponse?.issueCheckouts?[index].issueCost ?? 0,
                  _checkoutSheetResponse?.issueCheckouts?[index].issueImg ?? [],
                  () => _downloadCheckoutItemClicked(""),
                  false),
              itemCount: _checkoutSheetResponse?.issueCheckouts?.length,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            translate(LocalizationKeys.listOfExpensesDuringRent)!,
            maxLines: 1,
            style: const TextStyle(
              color: Color(0xFF484649),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => CheckOutItemWidget(
              _checkoutSheetResponse?.expenseCheckouts?[index].expenseType ??
                  "",
              _checkoutSheetResponse?.expenseCheckouts?[index].expenseDesc ??
                  "",
              _checkoutSheetResponse?.expenseCheckouts?[index].expenseAmount ??
                  0,
              List.empty(),
              () => _downloadCheckoutItemClicked(_checkoutSheetResponse
                      ?.expenseCheckouts?[index].expenseFile ??
                  ""),
              _checkoutSheetResponse?.expenseCheckouts?[index].expenseFile != ""
                  ? true
                  : false),
          itemCount: _checkoutSheetResponse?.expenseCheckouts?.length,
        ),
        _priceWidget(
            translate(LocalizationKeys.theRemainingRefundableSecurityDeposit)!,
            _checkoutSheetResponse?.refundedDeposit ?? 0),
        Padding(
          padding: EdgeInsets.only(left: 24.w, top: 14.h, bottom: 14.h),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      "${translate(LocalizationKeys.ifYouAnyMoreQuestionsFeelFreeToContactOur)} ",
                  style: const TextStyle(
                    color: Color(0xFF605D62),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: translate(LocalizationKeys.supportTeam),
                  style: const TextStyle(
                    height: 1.5,
                    color: Color(0xFF1151B4),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _supportTeamClicked(context),
                ),
              ],
            ),
          ),
        ),

        SubmitButtonWidget(
          title: translate(LocalizationKeys.continuee)!,
          onClicked: _onContinueClicked,
          backgroundColor: Colors.transparent,
          withoutCustomShape: true,
          withoutShape: true,
        )
      ]),
    );
  }

  Widget _priceWidget(String title, double priceValue) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF605D62),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              "$priceValue €",
              maxLines: 1,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Color(0xFF313033),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  CheckoutDetailsBloc get currentBloc =>
      BlocProvider.of<CheckoutDetailsBloc>(context);

  void _getCheckoutDetailsApiEvent() {
    currentBloc.add(GetCheckoutSheetDetailsEvent(widget.requestId));
  }

  void _validateFormInputsEvent(GlobalKey<FormState> editFormKey) {
    currentBloc.add(ValidateFormEvent(editFormKey));
  }

  void _confirmBankDetailsApiEvent() {
    currentBloc.add(ConfirmCheckoutBankDetailsEvent(PostBankDetailsSendModel(
        requestId: _checkoutSheetResponse!.reqID!,
        accountName: _bankDetailsModel?.accountHolderName ?? "",
        accountNo: _bankDetailsModel?.accountNumber ?? "",
        accountIban: _bankDetailsModel?.iban ?? "",
        accountSwift: _bankDetailsModel?.swiftCode ?? "")));
  }

  void _onContinueClicked() {
    handleContinueDestination();
  }

  //1-if cash paid
  void showRequestSentBottomSheet() {
    AppBottomSheet.openAppBottomSheet(
      context: context,
      child: CheckoutBottomSheetWidget(
        description: translate(LocalizationKeys
            .yourRequestHaveBeenSentOneOfOurAgentWillCallYouSoon)!,
        onGoBackClick: () {
          _closeScreen();
        },
      ),
      onCloseCallBack: () {
        _closeScreen();
      },
      title: "",
    );
  }

  //2-if online paid
  void showInvoiceWidgetBottomSheet() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: CheckoutInvoiceWidget(NextInvoiceModel(
            monthInvID: _checkoutSheetResponse!.monthInvID!,
            invDate: _checkoutSheetResponse!.invDate!,
            invTotal: _checkoutSheetResponse!.invTotal!,
            isCashed: false)),
        title: "");
  }

  void showBankDetailsBottomSheet() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: BankDetailsFormWidget(
          onConfirmBankDetails: (editFormKey, bankDetailsInfo) {
            _bankDetailsModel = bankDetailsInfo;
            _validateFormInputsEvent(editFormKey);
          },
        ),
        title: translate(LocalizationKeys.bankDetails)!);
  }

  //after confirm bank details
  void showConfirmBankDetailsBottomSheet() {
    AppBottomSheet.openAppBottomSheet(
      context: context,
      child: CheckoutBottomSheetWidget(
        description: _checkoutSheetResponse!.isCashDeposit!
            ? translate(LocalizationKeys.agentcontactyourefund)!
            : translate(LocalizationKeys.weWillSendTheMoneyWithin2To8Weeks)!,
        onGoBackClick: () {
          BottomNavigationScreen.open(context, 0);
          _closeScreen();
        },
      ),
      onCloseCallBack: () {
        BottomNavigationScreen.open(context, 0);
        _closeScreen();
      },
      title: "",
    );
  }

  void _downloadCheckoutItemClicked(String url) async {
    try {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      showFeedbackMessage(translate(LocalizationKeys.urlNotValid)!);
    }
  }

  void _supportTeamClicked(BuildContext context) {}

  void _closeScreen() {
    Navigator.of(context).pop();
  }

  Widget _noUnitData() {
    return StatusWidget.notFound(onAction: _getCheckoutDetailsApiEvent);
  }

  void handleContinueDestination() {
    bool cash = false;

    if (_checkoutSheetResponse!.isCashDeposit! &&
        _checkoutSheetResponse!.refundedDeposit! > 0) {
      _confirmBankDetailsApiEvent();
      //showRequestSentBottomSheet();
    } else if (!_checkoutSheetResponse!.isCashDeposit! &&
        _checkoutSheetResponse!.refundedDeposit! > 0) {
      showBankDetailsBottomSheet();
    } else {
      showInvoiceWidgetBottomSheet();
    }
  }
}
