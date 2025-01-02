import 'package:flutter/material.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/apis/models/my_problems/add_problem_response.dart';
import 'package:vivas/apis/models/my_problems/problem_details_api_model.dart';
import 'package:vivas/apis/models/my_problems/problems_list_wrapper.dart';
import 'package:vivas/apis/models/my_problems/user_apartments_list_wrapper.dart';
import 'package:vivas/feature/problem/model/edit_problem_end_model.dart';
import 'package:vivas/feature/problem/model/send_problem_model.dart';

class ProblemsApiManger {
  final DioApiManager dioApiManager;
  final BuildContext context;
  ProblemsApiManger(this.dioApiManager, this.context);

  Future<void> getMyProblemsApi(
      PagingListSendModel pagingListSendModel,
      void Function(ProblemsListWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getProblemsListUrl,
            queryParameters: pagingListSendModel.toJson())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ProblemsListWrapper wrapper = ProblemsListWrapper.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getUserApartmentsApi(
      void Function(UserApartmentsListWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getUserApartmentsUrl)
        .then((response) async {
      List<dynamic> extractedData = response.data as List<dynamic>;
      UserApartmentsListWrapper wrapper =
          UserApartmentsListWrapper.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getProblemDetailsApi(
      String problemId,
      void Function(ProblemDetailsApiModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(ApiKeys.getIssueDetailsUrl,
        queryParameters: {"Issue_ID": problemId}).then((response) async {
      List<dynamic> extractedData = response.data as List<dynamic>;
      ProblemDetailsApiModel wrapper =
          ProblemDetailsApiModel.fromJson(extractedData[0]);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> sendProblemApi(
      SendProblemModel sendProblemModel,
      void Function(AddProblemResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.addProblemUrl, data: sendProblemModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      AddProblemResponse wrapper = AddProblemResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> editDescriptionApi(
      EditProblemEndModel editProblemModel,
      void Function(AddProblemResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .put(ApiKeys.editProblemUrl, data: editProblemModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      AddProblemResponse wrapper = AddProblemResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }
}
