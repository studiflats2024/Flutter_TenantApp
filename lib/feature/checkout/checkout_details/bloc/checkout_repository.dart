import 'package:flutter/material.dart';
import 'package:vivas/apis/managers/checkout_api_manager.dart';
// ignore: unused_import
import 'package:vivas/apis/managers/contract_api_manager.dart';
import 'package:vivas/apis/models/checkout/get_checkout_send_model.dart';
import 'package:vivas/apis/models/checkout/post_bank_details_send_model.dart';

import 'checkout_bloc.dart';

abstract class BaseCheckoutRepository {
  Future<CheckoutDetailsState> getCheckoutSheetDetails(String requestId);
  Future<CheckoutDetailsState> confirmCheckout(
      PostBankDetailsSendModel postBankDetailsSendModel);
}

class CheckoutRepository implements BaseCheckoutRepository {
  final CheckoutApiManger checkoutApiManger;

  CheckoutRepository({required this.checkoutApiManger});

  @override
  Future<CheckoutDetailsState> getCheckoutSheetDetails(String requestId) async {
    late CheckoutDetailsState checkoutState;

    await checkoutApiManger.getCheckoutDetailsApi(
        GetCheckoutSendModel(requestId: requestId), (checkoutDetailsWrapper) {
      checkoutState = CheckoutDetailsLoadedState(checkoutDetailsWrapper);
      debugPrint("Api State:$checkoutState");
    }, (errorApiModel) {
      checkoutState = CheckoutDetailsErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return checkoutState;
  }

  @override
  Future<CheckoutDetailsState> confirmCheckout(
      PostBankDetailsSendModel postBankDetailsSendModel) async {
    late CheckoutDetailsState checkoutState;
    await checkoutApiManger.sendBankAccountApi(postBankDetailsSendModel,
        (_) {
      checkoutState = ConfirmBankDetailsSentSuccessfullyState();
    }, (error) {
      checkoutState = CheckoutDetailsErrorState(
          error.message, error.isMessageLocalizationKey);
    });
    return checkoutState;
  }
}
