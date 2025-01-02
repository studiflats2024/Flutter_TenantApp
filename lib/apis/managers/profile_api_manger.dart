import 'package:flutter/material.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/profile/deleteaccount_request_response.dart';
import 'package:vivas/apis/models/profile/edit_profile/profile_image/update_profile_image_model.dart';
import 'package:vivas/apis/models/profile/edit_profile/profile_image/update_profile_image_successfully_response.dart';
import 'package:vivas/apis/models/profile/edit_profile/update_email_or_phone/update_phone_model.dart';
import 'package:vivas/apis/models/profile/edit_profile/basic_info/update_basic_data_model.dart';
import 'package:vivas/apis/models/profile/edit_profile/basic_info/update_basic_data_successful_response.dart';
import 'package:vivas/apis/models/profile/edit_profile/update_email_or_phone/update_email_model.dart';
import 'package:vivas/apis/models/profile/edit_profile/update_email_or_phone/update_email_phone_response.dart';
import 'package:vivas/apis/models/profile/logout_request_response.dart';
import 'package:vivas/apis/models/profile/profile_info_api_model.dart';

class ProfileApiManger {
  final DioApiManager dioApiManager;
  final BuildContext context;
  ProfileApiManger(this.dioApiManager, this.context);

  Future<void> getProfileApi(void Function(ProfileInfoApiModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(ApiKeys.getProfileUrl).then((response) {
      List<dynamic> extractedData = response.data as List<dynamic>;
      ProfileInfoApiModel wrapper =
          ProfileInfoApiModel.fromJson(extractedData.first);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> updateBasicDataApi(
      UpdateBasicDataSendModel updateBasicDataSendModel,
      void Function(UpdateBasicDataSuccessfulResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .put(ApiKeys.updateBasicDataUrl,
            queryParameters: updateBasicDataSendModel.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      UpdateBasicDataSuccessfulResponse wrapper =
          UpdateBasicDataSuccessfulResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> updateProfileImageApi(
      UpdateProfileImageSendModel updateProfileImageSendModel,
      void Function(UpdateProfileImageSuccessfullyResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .put(ApiKeys.updateProfileImageUrl,
            data: await updateProfileImageSendModel.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      UpdateProfileImageSuccessfullyResponse wrapper =
          UpdateProfileImageSuccessfullyResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> updateEmailApi(
      UpdateEmailSendModel updateEmailSendModel,
      void Function(UpdateEmailOrPhoneResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .put(ApiKeys.updateEmailUrl,
            queryParameters: updateEmailSendModel.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      UpdateEmailOrPhoneResponse wrapper =
          UpdateEmailOrPhoneResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> updatePhoneNumberApi(
      UpdatePhoneNumberSendModel updatePhoneNumberSendModel,
      void Function(UpdateEmailOrPhoneResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .put(ApiKeys.updatePhoneNumberUrl,
            queryParameters: updatePhoneNumberSendModel.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      UpdateEmailOrPhoneResponse wrapper =
          UpdateEmailOrPhoneResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> logoutApi(
      String deviceToken,
      void Function(LogoutResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.delete(ApiKeys.logoutUrl,
        queryParameters: {"Device_Token": deviceToken}).then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      LogoutResponse wrapper = LogoutResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> deleteAccountApi(void Function(DeleteAccountResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.delete(ApiKeys.deleteAccount).then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      DeleteAccountResponse wrapper =
          DeleteAccountResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }
}
