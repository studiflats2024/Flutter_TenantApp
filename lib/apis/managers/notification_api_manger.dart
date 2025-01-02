import 'package:flutter/material.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/apis/models/notifications_list/notification_list_wrapper.dart';

class NotificationApiManger {
  final DioApiManager dioApiManager;
  final BuildContext context;
  NotificationApiManger(this.dioApiManager, this.context);

  Future<void> getNotificationListApi(
      PagingListSendModel pagingListSendModel,
      void Function(NotificationListWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getNotificationUrl,
            queryParameters: pagingListSendModel.toJson())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      NotificationListWrapper wrapper =
          NotificationListWrapper.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> markNotificationReadApi(String notificationId,
      void Function() success, void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.put(ApiKeys.notificationMarkReadUrl,
        queryParameters: {"ID": notificationId}).then((response) async {
      success();
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }
}
