import 'package:vivas/apis/managers/contract_api_manager.dart';
import 'package:vivas/apis/models/contract/get_contract/get_contract_send_model.dart';
import 'package:vivas/apis/models/contract/sign_contract/sign_contract_send_model.dart';
import 'package:vivas/apis/models/contract/sign_contract/sign_contract_send_model_v2.dart';
import 'package:vivas/apis/models/contract/sign_contract/sign_extend_contract_send_model.dart';
import 'package:vivas/feature/contract/sign_contract/bloc/sign_contract_bloc.dart';

abstract class BaseSignContractRepository {
  Future<SignContractState> getContractData(String requestId);
  Future<SignContractState> getContractDataV2(String requestId , String apartmentId, String bedId);
  Future<SignContractState> getExtendContractData(String requestId);
  Future<SignContractState> signContract(
      String requestId, String signatureImagePath);
  Future<SignContractState> signContractV2(
      String requestId, String contractId,String signatureImagePath);
  Future<SignContractState> signExtendContract(
      String requestId, String signatureImagePath);
}

class SignContractRepository implements BaseSignContractRepository {
  final ContractApiManger contractApiManger;

  SignContractRepository({required this.contractApiManger});

  @override
  Future<SignContractState> getContractData(String requestId) async {
    late SignContractState signContractState;

    await contractApiManger.getContractListApi(
        GetContractSendModel(requestId: requestId), (contractWrapper) {
      signContractState = SignContractLoadedState(contractWrapper);
    }, (errorApiModel) {
      signContractState = SignContractErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return signContractState;
  }

  @override
  Future<SignContractState> getContractDataV2(String requestId, String apartmentId, String bedId) async{
    late SignContractState signContractState;

    await contractApiManger.getContractListApiV2(
        GetContractSendModelV2(requestId: requestId, apartmentId:apartmentId, bedId: bedId), (contractWrapper) {
      signContractState = SignContractLoadedStateV2(contractWrapper);
    }, (errorApiModel) {
      signContractState = SignContractErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return signContractState;
  }

  @override
  Future<SignContractState> getExtendContractData(String requestId) async {
    late SignContractState signContractState;

    await contractApiManger.getExtendContractApi(
        GetExtendContractSendModel(requestId: requestId), (contractWrapper) {
      signContractState = SignContractLoadedStateV2(contractWrapper);
    }, (errorApiModel) {
      signContractState = SignContractErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return signContractState;
  }
  @override
  Future<SignContractState> signContract(
      String requestId, String signatureImagePath) async {
    late SignContractState signContractState;

    await contractApiManger.signContractApi(
        SignContractSendModel(
            requestId: requestId,
            signaturePath: signatureImagePath), (contractWrapper) {
      signContractState = ContractSignedSuccessfullyState(contractWrapper);
    }, (errorApiModel) {
      signContractState = SignContractErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return signContractState;
  }

  @override
  Future<SignContractState> signContractV2(
      String requestId,String contractId, String signatureImagePath) async {
    late SignContractState signContractState;

    await contractApiManger.signContractApiV2(
        SignContractSendModelV2(
            requestId: requestId,
            contractID: contractId,
            signaturePath: signatureImagePath), (contractWrapper) {
      signContractState = ContractSignedSuccessfullyState(contractWrapper);
    }, (errorApiModel) {
      signContractState = SignContractErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return signContractState;
  }

  @override
  Future<SignContractState> signExtendContract(
      String requestId, String signatureImagePath) async {
    late SignContractState signContractState;

    await contractApiManger.signExtendContractApi(
        SignExtendContractSendModel(
            requestId: requestId,
            signaturePath: signatureImagePath), (contractWrapper) {
      signContractState = ContractSignedSuccessfullyState(contractWrapper);
    }, (errorApiModel) {
      signContractState = SignContractErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return signContractState;
  }


}
