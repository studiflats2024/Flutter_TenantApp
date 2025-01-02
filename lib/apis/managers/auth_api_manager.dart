import 'dart:async';

import 'package:dio/dio.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/auth/auth_successful_response.dart';
import 'package:vivas/apis/models/auth/forget_password/forget_password_send_model.dart';
import 'package:vivas/apis/models/auth/forget_password/forget_password_successful_response.dart';
import 'package:vivas/apis/models/auth/forget_password/reset_password_send_model.dart';
import 'package:vivas/apis/models/auth/login/login_send_model.dart';
import 'package:vivas/apis/models/auth/login/login_successful_response.dart';
import 'package:vivas/apis/models/auth/login/login_with_social_send_model_api.dart';
import 'package:vivas/apis/models/auth/otp/check_otp_model.dart';
import 'package:vivas/apis/models/auth/otp/send_otp_model.dart';
import 'package:vivas/apis/models/auth/otp/send_otp_successful_response.dart';
import 'package:vivas/apis/models/auth/register/create_account_send_model.dart';
import 'package:vivas/apis/models/auth/register/finish_account_send_model.dart';
import 'package:flutter/material.dart';

class AuthApiManager {
  final DioApiManager dioApiManager;
  final BuildContext context;

  AuthApiManager(this.dioApiManager, this.context);

  Future<void> createAccountApi(
      CreateAccountSendModel createAccountSendModel,
      Future<void> Function(AuthSuccessfulResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dioUnauthorized
        .post(ApiKeys.createAccountUrl, data: createAccountSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      AuthSuccessfulResponse wrapper =
          AuthSuccessfulResponse.fromJson(extractedData);
      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> sendOtpApi(
      SendOtpModelApi sendOtpModelApi,
      void Function(SendOtpSuccessfulResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dioUnauthorized
        .get(ApiKeys.refreshOtpUrl, queryParameters: sendOtpModelApi.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      SendOtpSuccessfulResponse wrapper =
          SendOtpSuccessfulResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> checkOtpApi(
      CheckOtpModelApi sendOtpModelApi,
      void Function(AuthSuccessfulResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dioUnauthorized
        .put(ApiKeys.checkOtpUrl, queryParameters: sendOtpModelApi.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      AuthSuccessfulResponse wrapper =
          AuthSuccessfulResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> finishAccountApi(
      FinishAccountSendModel finishAccountSendModel,
      FutureOr Function(LoginSuccessfulResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dioUnauthorized
        .put(ApiKeys.finishAccountUrl,
            queryParameters: finishAccountSendModel.toMap())
        .then((response) async{
      Map<String, dynamic> extractedData = response.data as Map<String, dynamic>;
      // AuthSuccessfulResponse wrapper =
      //     AuthSuccessfulResponse.fromJson(extractedData);
      LoginSuccessfulResponse wrapper =
      LoginSuccessfulResponse.fromJson(extractedData);
     await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> loginApi(
      LoginSendModelApi loginSendModelApi,
      void Function(LoginSuccessfulResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dioUnauthorized
        .post(ApiKeys.loginUrl, data: loginSendModelApi.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      LoginSuccessfulResponse wrapper =
          LoginSuccessfulResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      if (error.type == DioExceptionType.badResponse &&
              (error as DioException).response?.statusCode == 400 ||
          (error as DioException).response?.statusCode == 401) {
        fail(ErrorApiModel.fromLoginJson(error));
      } else {
        fail(ErrorApiModel.identifyError(error: error, context: context));
      }
    });
  }

  Future<void> loginWithSocial(
      LoginWithSocialSendModelApi loginWithSocialSendModelApi,
      void Function(LoginSuccessfulResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dioUnauthorized
        .post(ApiKeys.socialSignUrl,
            queryParameters: loginWithSocialSendModelApi.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      LoginSuccessfulResponse wrapper =
          LoginSuccessfulResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      if (error is DioException &&
          error.type == DioExceptionType.badResponse &&
          (error.response?.statusCode == 400 ||
              error.response?.statusCode == 401)) {
        fail(ErrorApiModel.fromLoginJson(error));
      } else {
        fail(ErrorApiModel.identifyError(error: error, context: context));
      }
    });
  }

  Future<void> forgetPasswordApi(
      ForgetPasswordSendModel forgetPasswordSendModel,
      void Function(ForgetPasswordSuccessfulResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dioUnauthorized
        .get(ApiKeys.forgetPasswordUrl,
            queryParameters: forgetPasswordSendModel.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ForgetPasswordSuccessfulResponse wrapper =
          ForgetPasswordSuccessfulResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> resetPasswordApi(
      ResetPasswordSendModelApi resetPasswordSendModelApi,
      void Function(AuthSuccessfulResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dioUnauthorized
        .put(ApiKeys.resetPasswordUrl,
            queryParameters: resetPasswordSendModelApi.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      AuthSuccessfulResponse wrapper =
          AuthSuccessfulResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> resetPasswordApiV2(
      ResetPasswordSendModelApi resetPasswordSendModelApi,
      void Function(AuthSuccessfulResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.resetPasswordUrlV2,
            queryParameters: resetPasswordSendModelApi.toMapV2())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      AuthSuccessfulResponse wrapper =
          AuthSuccessfulResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }
}
