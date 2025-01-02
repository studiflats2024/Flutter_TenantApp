import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_api_model.dart';
import 'package:vivas/apis/models/invoices_list/invoices_list_wrapper.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:flutter/material.dart';

class InvoicesApiManger {
  final DioApiManager dioApiManager;
  final BuildContext context;

  InvoicesApiManger(this.dioApiManager, this.context);

  Future<void> getInvoicesApi(
      PagingListSendModel pagingListSendModel,
      void Function(InvoicesListWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getInvoiceListUrl,
            queryParameters: pagingListSendModel.toJson())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      InvoicesListWrapper wrapper = InvoicesListWrapper.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getInvoiceDetailsApi(
      String invoiceId,
      void Function(InvoiceApiModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(ApiKeys.getInvoiceDetailsUrl,
        queryParameters: {"Inv_ID": invoiceId}).then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      InvoiceApiModel wrapper = InvoiceApiModel.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }
}
