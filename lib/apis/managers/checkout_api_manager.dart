import 'package:flutter/material.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/checkout/checkoutsheet.dart';
import 'package:vivas/apis/models/checkout/get_checkout_send_model.dart';
import 'package:vivas/apis/models/checkout/post_bank_details_send_model.dart';
import 'package:vivas/apis/models/checkout/post_bank_details_successfully_response.dart';

class CheckoutApiManger {
  final DioApiManager dioApiManager;
  final BuildContext context;
  CheckoutApiManger(this.dioApiManager , this.context);

  Future<void> getCheckoutDetailsApi(
      GetCheckoutSendModel getCheckoutSendModel,
      void Function(CheckoutSheet) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.checkoutSheet,
            queryParameters: getCheckoutSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      CheckoutSheet wrapper = CheckoutSheet.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error , context: context));
    });
  }

  Future<void> sendBankAccountApi(
      PostBankDetailsSendModel postBankDetailsSendModel,
      void Function(PostBankDetailsSuccessfullyResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .put(ApiKeys.postBankDetails, data: postBankDetailsSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      PostBankDetailsSuccessfullyResponse wrapper =
          PostBankDetailsSuccessfullyResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error , context: context));
    });
  }
}
