import 'package:flutter/material.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/errors/error_api_model.dart';

class PaymentApiManger {
  final DioApiManager dioApiManager;
  final BuildContext context;
  PaymentApiManger(this.dioApiManager, this.context);

  Future<void> getPaymentUrlApi(String invoiceId, bool isCash,
      void Function(String) success, void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(ApiKeys.paymentUrl, queryParameters: {
      "Invoice_ID": invoiceId,
      if (isCash) "Method": "Cash"
    }).then((response) async {
      String extractedData = response.data as String;
      success(extractedData);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> checkPayStatus(String url,
      void Function(String) success, void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(url).then((response) async {
      String extractedData = response.data as String;
      success(extractedData);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error,context: context));
    });
  }

  Future<void> getPaymentUrlApiV2(List<String> invoiceCode, bool isCash,
      void Function(String) success, void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.post(ApiKeys.paymentUrlV2, queryParameters: {
      "Is_Cash": isCash
    }, data: List<dynamic>.from(invoiceCode.map((x) => x)),
    ).then((response) async {
      String extractedData = response.data as String;
      success(extractedData);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }
}
