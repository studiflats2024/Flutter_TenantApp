import 'dart:convert';

import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/_base/base_model.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/activity_details_send.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/enroll_activity_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/invite_frind_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/my_activity_rating_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/my_activity_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/paginated_club_activity_model.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/pay_subscription_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/activity_details_model.dart';
import 'package:vivas/feature/Community/Data/Models/club_activity_model.dart';
import 'package:vivas/feature/Community/Data/Models/invitations_history_model.dart';
import 'package:vivas/feature/Community/Data/Models/invoice_club_details_model.dart';
import 'package:vivas/feature/Community/Data/Models/my_activity_response.dart';
import 'package:vivas/feature/Community/Data/Models/my_plan_model.dart';
import 'package:vivas/feature/Community/Data/Models/plan_details_model.dart';
import 'package:vivas/feature/Community/Data/Models/plan_history_model.dart';
import 'package:vivas/feature/Community/Data/Models/plan_subscribe_model.dart';
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

  Future<void> getActivityDetails(
      ActivityDetailsSendModel sendModel,
      void Function(ActivityDetailsModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getCommunityActivityDetails,
            queryParameters: sendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ActivityDetailsModel wrapper =
          activityDetailsModelFromJson(json.encode(extractedData));
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

  Future<void> getSubscriptionPlanDetails(
    planId,
    void Function(PlanDetailsModel) success,
    void Function(ErrorApiModel) fail,
  ) async {
    await dioApiManager.dio.get(ApiKeys.getCommunityPlanDetails,
        queryParameters: {"Plan_ID": planId}).then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      PlanDetailsModel wrapper =
          planDetailsModelFromJson(json.encode(extractedData));
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
    )
        .then((response) async {
      List extractedData = response.data as List;
      List<String> wrapper = extractedData.map((x) => x.toString()).toList();
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(
        error: error,
      ));
    });
  }

  Future<void> getDoorLock(
      void Function(String) success, void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(
      ApiKeys.openDoorLock,
    )
        .then((response) async {
      String doorLock = response.data as String;
      success(doorLock);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(
        error: error,
      ));
    });
  }

  Future<void> subscriptionPlan(id, void Function(SubscribePlanModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.post(ApiKeys.subscribePlan,
        queryParameters: {"Plan_ID": id}).then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      SubscribePlanModel wrapper =
          subscribePlanModelFromJson(json.encode(extractedData));
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(
        error: error,
      ));
    });
  }

  Future<void> paySubscriptionPlan(PaySubscriptionSendModel model,
      void Function(String) success, void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(
      ApiKeys.paySubscribePlan,
      queryParameters: model.toMap(),
    )
        .then((response) async {
      String extractedData = response.data as String;
      success(extractedData);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(
        error: error,
      ));
    });
  }

  Future<void> inviteFriend(
      InviteFriendSendModel model,
      void Function(BaseMessageModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.inviteFriend, data: model.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      BaseMessageModel baseModel =
          baseMessageModelFromJson(json.encode(extractedData));
      success(baseModel);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(
        error: error,
      ));
    });
  }

  Future<void> getMyPlan(void Function(MyPlanModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(ApiKeys.getMyPlan).then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      MyPlanModel plan = myPlanModelFromJson(json.encode(extractedData));
      success(plan);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(
        error: error,
      ));
    });
  }

  Future<void> enrollActivity(
      EnrollActivitySendModel model,
      void Function(BaseMessageModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(
      ApiKeys.enrollActivity,
      data: model.toMap(),
    )
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      BaseMessageModel data =
          baseMessageModelFromJson(json.encode(extractedData));
      success(data);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(
        error: error,
      ));
    });
  }

  Future<void> myActivity(
      MyActivitySendModel model,
      void Function(MyActivityResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(
      ApiKeys.getMyActivity,
      queryParameters: model.toMap(),
    )
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      MyActivityResponse data =
          myActivityResponseFromJson(json.encode(extractedData));
      success(data);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(
        error: error,
      ));
    });
  }

  Future<void> unEnrollActivity(
      String id,
      void Function(BaseMessageModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(
      ApiKeys.unEnrollActivity,
      queryParameters: {"ID": id},
    ).then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      BaseMessageModel data =
          baseMessageModelFromJson(json.encode(extractedData));
      success(data);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(
        error: error,
      ));
    });
  }

  Future<void> reviewActivity(
      MyActivityRatingSendModel model,
      void Function(BaseMessageModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(
      ApiKeys.reviewActivity,
      data: model.toMap(),
    )
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      BaseMessageModel data =
          baseMessageModelFromJson(json.encode(extractedData));
      success(data);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(
        error: error,
      ));
    });
  }

  Future<void> planHistoryTransaction(
      PagingListSendModel model,
      void Function(PlanHistoryModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(
      ApiKeys.getPlanTransactions,
      queryParameters: {
        "Page_No": model.pageNumber,
        "Page_Size": model.pageSize
      },
    ).then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      PlanHistoryModel data =
          planHistoryModelFromJson(json.encode(extractedData));
      success(data);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(
        error: error,
      ));
    });
  }
  Future<void> planTransactionDetails(
      String id,
      void Function(InvoiceClubDetailsModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(
      ApiKeys.getPlanTransactionDetails,
      queryParameters: {
        "Invoice_ID": id,
      },
    ).then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      InvoiceClubDetailsModel data =
          invoiceClubDetailsModelFromJson(json.encode(extractedData));
      success(data);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(
        error: error,
      ));
    });
  }

  Future<void> invitationsHistory(
      PagingListSendModel model,
      void Function(InvitationsHistoryModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(
      ApiKeys.getInvitationsHistory,
      queryParameters: {
        "Page_No": model.pageNumber,
        "Page_Size": model.pageSize
      },
    ).then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      InvitationsHistoryModel data =
          invitationsHistoryModelFromJson(json.encode(extractedData));
      success(data);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(
        error: error,
      ));
    });
  }
}
