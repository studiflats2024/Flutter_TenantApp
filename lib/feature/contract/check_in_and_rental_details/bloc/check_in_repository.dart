import 'package:vivas/apis/managers/contract_api_manager.dart';
import 'package:vivas/apis/models/contract/check_in_details/get_check_in_details_send_model.dart';
import 'package:vivas/feature/contract/check_in_and_rental_details/bloc/check_in_details_bloc.dart';

abstract class BaseCheckInDetailsRepository {
  Future<CheckInDetailsState> getCheckInDetails(String requestId);
}

class CheckInDetailsRepository implements BaseCheckInDetailsRepository {
  final ContractApiManger contractApiManger;

  CheckInDetailsRepository({required this.contractApiManger});

  @override
  Future<CheckInDetailsState> getCheckInDetails(String requestId) async {
    late CheckInDetailsState checkIntState;

    await contractApiManger
        .getCheckInDetailsApi(GetCheckInDetailsSendModel(requestId: requestId),
            (checkInDetailsResponse) {
      checkIntState = CheckInDetailsLoadedState(checkInDetailsResponse);
    }, (errorApiModel) {
      checkIntState = CheckInDetailsErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return checkIntState;
  }
}
