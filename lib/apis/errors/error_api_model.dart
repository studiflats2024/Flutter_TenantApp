import 'package:dio/dio.dart';
import 'package:vivas/apis/errors/error_api_helper.dart';
import 'package:vivas/apis/errors/locale_dio_exceptions.dart';
import 'package:vivas/apis/models/_base/details_model.dart';
import 'package:vivas/apis/models/auth/login/login_fail_response.dart';
import 'package:vivas/app_route.dart';
import 'package:vivas/feature/widgets/MaintenanceApp/maintenance_app.dart';
import 'package:vivas/utils/build_type/build_type.dart';
import 'package:flutter/material.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';

class ErrorApiModel {
  final bool isMessageLocalizationKey;
  final String message;
  final int code;
  final BuildContext? context;

  ErrorApiModel(
      {required this.isMessageLocalizationKey,
      required this.message,
      required this.code,
      this.context});

  factory ErrorApiModel.fromDioError(DioException dioError,
      {BuildContext? context}) {
    late int codeError;
    switch (dioError.type) {
      case DioExceptionType.cancel:
        codeError = 1001;
        break;
      case DioExceptionType.connectionTimeout:
        codeError = 1002;
        break;
      case DioExceptionType.receiveTimeout:
        codeError = 1003;
        break;
      case DioExceptionType.badResponse:
        if (dioError.response?.statusCode == 400) {
          codeError = 400;

          return ErrorApiModel.fromResponse(dioError, context: context);
        }
        // use code from 1004 - 1010

        codeError = ErrorApiHelper.handleResponseErrorCode(
          dioError.response?.statusCode,
        );
        if (codeError == 1009 && context != null) {
          if (context != null) {
            MaintenanceApp.open(context);
          } else if (AppRoute.mainNavigatorKey.currentContext != null) {
            MaintenanceApp.open(AppRoute.mainNavigatorKey.currentContext!);
          } else {
            showFeedbackMessage(
                "Our app in maintenance now please try again Later");
          }
        }
        break;
      case DioExceptionType.sendTimeout:
        codeError = 1011;
        break;
      case DioExceptionType.badCertificate:
        codeError = 1013;
        break;
      case DioExceptionType.connectionError:
        break;
      case DioExceptionType.unknown:
        if (dioError.message?.contains("SocketException") ?? false) {
          codeError = 1012;
          break;
        }
        codeError = 1014;
        break;
      default:
        codeError = 1014;
    }

    return ErrorApiModel(
        context: context,
        code: codeError,
        isMessageLocalizationKey: true,
        message: LocaleDioExceptions.getLocaleMessage(codeError));
  }

  factory ErrorApiModel.identifyError(
      {required dynamic error, BuildContext? context}) {
    ErrorApiModel errorApiModel;
    if (error is DioException) {
      errorApiModel = ErrorApiModel.fromDioError(error, context: context);
    } else if (error is TypeError && isDebugMode()) {
      String? stackTrace = "";
      stackTrace = error.stackTrace.toString();
      errorApiModel = ErrorApiModel(
          context: context,
          code: 1015,
          message:
              ErrorApiHelper.formErrorMessage(error.toString(), stackTrace),
          isMessageLocalizationKey: false);
    } else {
      errorApiModel = ErrorApiModel(
          context: context,
          code: 1014,
          message: LocaleDioExceptions.getLocaleMessage(1014),
          isMessageLocalizationKey: true);
    }
    return errorApiModel;
  }

  factory ErrorApiModel.fromLoginJson(DioException error) {
    Map<String, dynamic> extractedData =
        error.response?.data as Map<String, dynamic>;
    return LoginFailResponse.fromJson(extractedData);
  }

  factory ErrorApiModel.fromResponse(DioException error,
      {BuildContext? context}) {
    Map<String, dynamic> extractedData =
        error.response?.data as Map<String, dynamic>;
    return ErrorApiModel(
        context: context,
        code: error.response?.statusCode ?? 1007,
        message: extractedData["message"] ?? "NO MESSAGE",
        isMessageLocalizationKey: false);
  }

  factory ErrorApiModel.fromDetailsModel(DetailsModel detailsModel,
          {BuildContext? context}) =>
      ErrorApiModel(
          context: context,
          code: detailsModel.statusCode ?? 0,
          message: detailsModel.message ?? "NO MESSAGE",
          isMessageLocalizationKey: false);
}
