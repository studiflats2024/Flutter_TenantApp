import 'dart:convert';

import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/club_activity_model.dart';
import 'package:vivas/feature/Community/Data/Models/subscription_plans_model.dart';

class CommunityManager {
  final DioApiManager dioApiManager;

  CommunityManager(this.dioApiManager);

  Future<void> getCommunityMonthlyActivities(
      PagingListSendModel pagingListSendModel,
      void Function(ClubActivityModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dioUnauthorized
        .get(
      ApiKeys.getCommunityMonthlyActivities,
      queryParameters: pagingListSendModel.toJson(),
    )
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ClubActivityModel wrapper =
          clubActivityModelFromJson(json.encode(extractedData));
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(
        error: error,
      ));
    });
  }

  Future<void> getCommunityClubActivities(
      PagingCommunityActivitiesListSendModel pagingListSendModel,
      void Function(ClubActivityModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dioUnauthorized
        .post(ApiKeys.getCommunityPaginatedActivities,
            data: pagingListSendModel.toJson(),
            queryParameters: pagingListSendModel.toParameters())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ClubActivityModel wrapper =
          clubActivityModelFromJson(json.encode(extractedData));
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(
        error: error,
      ));
    });
  }

  Future<void> getSubscriptionsPlan(
      PagingListSendModel pagingListSendModel,
      void Function(List<SubscriptionPlansModel>) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dioUnauthorized
        .get(ApiKeys.getCommunitySubscriptionsPlan,
            queryParameters: pagingListSendModel.toJson())
        .then((response) async {
      List extractedData = response.data as List;
      List<SubscriptionPlansModel> wrapper =
          subscriptionPlansModelFromJson(json.encode(extractedData));
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(
        error: error,
      ));
    });
  }

  Future<void> getMyQr(void Function(List<String>) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(
      ApiKeys.getCommunityQr,
    ).then((response) async {
      List extractedData = response.data as List;
      List<String> wrapper = extractedData.map((x) => x.toString()).toList();
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(
        error: error,
      ));
    });
  }
}
