import 'package:vivas/apis/managers/contract_api_manager.dart';
import 'package:vivas/apis/models/contract/prepare_check_in/prepare_check_in_send_model.dart';
import 'package:vivas/feature/contract/prepare_check_in/bloc/prepare_check_in_bloc.dart';

abstract class BasePrepareCheckInRepository {
  Future<PrepareCheckInState> prepareCheckInApi(
      PrepareCheckInSendModel prepareCheckInSendModel);
}

class PrepareCheckInRepository implements BasePrepareCheckInRepository {
  final ContractApiManger contractApiManger;

  PrepareCheckInRepository({required this.contractApiManger});

  @override
  Future<PrepareCheckInState> prepareCheckInApi(
      PrepareCheckInSendModel prepareCheckInSendModel) async {
    late PrepareCheckInState checkIntState;

    await contractApiManger.prepareCheckInApi(prepareCheckInSendModel,
        (prepareCheckInSuccessfullyResponse) {
      checkIntState =
          CheckInSuccessfullyState(prepareCheckInSuccessfullyResponse);
    }, (errorApiModel) {
      checkIntState = CheckInErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return checkIntState;
  }
}
