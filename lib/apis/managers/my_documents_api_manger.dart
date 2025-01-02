import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/apis/models/my_documents/my_documents_list_wrapper.dart';
import 'package:flutter/material.dart';

class MyDocumentsApiManger {
  final DioApiManager dioApiManager;
  final BuildContext context;
  MyDocumentsApiManger(this.dioApiManager, this.context);

  Future<void> getMyDocumentsApi(
      PagingListSendModel pagingListSendModel,
      void Function(MyDocumentsListWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getDocumentsUrl,
            queryParameters: pagingListSendModel.toJson())
        .then((response) async {
      List<dynamic> extractedData = response.data as List<dynamic>;
      MyDocumentsListWrapper wrapper =
          MyDocumentsListWrapper.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }
}
