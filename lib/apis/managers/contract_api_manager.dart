import 'package:flutter/material.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/contract/check_in_details/check_in_details_response.dart';
import 'package:vivas/apis/models/contract/check_in_details/get_check_in_details_send_model.dart';
import 'package:vivas/apis/models/contract/get_contract/get_contract_response.dart';
import 'package:vivas/apis/models/contract/get_contract/get_contract_response_v2.dart';
import 'package:vivas/apis/models/contract/get_contract/get_contract_send_model.dart';
import 'package:vivas/apis/models/contract/prepare_check_in/prepare_check_in_send_model.dart';
import 'package:vivas/apis/models/contract/prepare_check_in/prepare_check_in_successfully_response.dart';
import 'package:vivas/apis/models/contract/sign_contract/sign_contract_send_model.dart';
import 'package:vivas/apis/models/contract/sign_contract/sign_contract_send_model_v2.dart';
import 'package:vivas/apis/models/contract/sign_contract/sign_contract_successfully_response.dart';
import 'package:vivas/apis/models/contract/sign_contract/sign_extend_contract_send_model.dart';

class ContractApiManger {
  final DioApiManager dioApiManager;
  final BuildContext context;
  ContractApiManger(this.dioApiManager, this.context);

  Future<void> getContractListApi(
      GetContractSendModel getContractSendModel,
      void Function(GetContractResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getContract, queryParameters: getContractSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      GetContractResponse wrapper = GetContractResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error , context:  context));
    });
  }

  Future<void> getContractListApiV2(
      GetContractSendModelV2 getContractSendModel,
      void Function(ContractModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getContractV2, queryParameters: getContractSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
      response.data as Map<String, dynamic>;
      ContractModel wrapper = ContractModel.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }
  Future<void> getExtendContractApi(
      GetExtendContractSendModel model,
      void Function(ContractModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getExtendContract, queryParameters: model.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
      response.data as Map<String, dynamic>;
      ContractModel wrapper = ContractModel.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> signContractApi(
      SignContractSendModel signContractSendModel,
      void Function(SignContractSuccessfullyResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .put(ApiKeys.signContract,
            data: await signContractSendModel.mapSignatureImage(),
            queryParameters: signContractSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      SignContractSuccessfullyResponse wrapper =
          SignContractSuccessfullyResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> signContractApiV2(
      SignContractSendModelV2 signContractSendModel,
      void Function(SignContractSuccessfullyResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.signContractV2,
      data: await signContractSendModel.mapSignatureImage(),
        //queryParameters: signContractSendModel.toMap()
      )
        .then((response) async {
      Map<String, dynamic> extractedData =
      response.data as Map<String, dynamic>;
      SignContractSuccessfullyResponse wrapper =
      SignContractSuccessfullyResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> signExtendContractApi(
      SignExtendContractSendModel signContractSendModel,
      void Function(SignContractSuccessfullyResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.signExtendContract,
      data: await signContractSendModel.mapSignatureImage(),
        queryParameters: signContractSendModel.toMap()
      )
        .then((response) async {
      Map<String, dynamic> extractedData =
      response.data as Map<String, dynamic>;
      SignContractSuccessfullyResponse wrapper =
      SignContractSuccessfullyResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> prepareCheckInApi(
      PrepareCheckInSendModel prepareCheckInSendModel,
      void Function(PrepareCheckInSuccessfullyResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.postCheckInDetailsUrl,
            queryParameters: prepareCheckInSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      PrepareCheckInSuccessfullyResponse wrapper =
          PrepareCheckInSuccessfullyResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getCheckInDetailsApi(
      GetCheckInDetailsSendModel getCheckInDetailsSendModel,
      void Function(CheckInDetailsResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getCheckInDetailsUrl,
            queryParameters: getCheckInDetailsSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      CheckInDetailsResponse wrapper =
          CheckInDetailsResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }
}
