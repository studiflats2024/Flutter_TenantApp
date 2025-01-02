import 'package:vivas/apis/managers/apartment_api_manger.dart';
import 'package:vivas/apis/managers/general_api_manger.dart';
import 'package:vivas/feature/unit_details/bloc/unit_details_bloc.dart';
import 'package:vivas/preferences/preferences_manager.dart';

abstract class BaseUnitDetailsRepository {
  Future<UnitDetailsState> getUnitDetailsApi(String uuid);
  Future<UnitDetailsState> getUnitDetailsApiV2(String uuid);
  Future<UnitDetailsState> getFaqApi();
  Future<UnitDetailsState> checkLoggedIn();
}

class UnitDetailsRepository implements BaseUnitDetailsRepository {
  final ApartmentApiManger apartmentApiManger;
  final PreferencesManager preferencesManager;
  final GeneralApiManger generalApiManger;

  UnitDetailsRepository({
    required this.apartmentApiManger,
    required this.preferencesManager,
    required this.generalApiManger,
  });

  @override
  Future<UnitDetailsState> getUnitDetailsApi(String uuid) async {
    late UnitDetailsState unitDetailsState;

    await apartmentApiManger.getApartmentDetailsApi(uuid, (detailsApiModel) {
      unitDetailsState = UnitDetailsLoadedState(detailsApiModel);
    }, (errorApiModel) {
      unitDetailsState = UnitDetailErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return unitDetailsState;
  }

  @override
  Future<UnitDetailsState> getUnitDetailsApiV2(String uuid) async{
    late UnitDetailsState unitDetailsState;

    await apartmentApiManger.getApartmentDetailsApiV2(uuid, (detailsApiModel) {
      unitDetailsState = UnitDetailsLoadedStateV2(detailsApiModel);
    }, (errorApiModel) {
      unitDetailsState = UnitDetailErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return unitDetailsState;
  }

  @override
  Future<UnitDetailsState> getFaqApi() async {
    late UnitDetailsState unitDetailsState;
    await generalApiManger.getFaqApi((fAQListWrapper) {
      if (fAQListWrapper.data.length <= 3) {
        unitDetailsState = FaqLoadedState(fAQListWrapper.data);
      } else {
        unitDetailsState = FaqLoadedState(fAQListWrapper.data.sublist(0, 3));
      }
    }, (errorApiModel) {
      unitDetailsState = UnitDetailErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return unitDetailsState;
  }

  @override
  Future<UnitDetailsState> checkLoggedIn() async{

    late UnitDetailsState unitDetailsState;

    bool isLoggedIn = await preferencesManager.isLoggedIn();
    print("isLoggedIn: $isLoggedIn");
    if (isLoggedIn) {
      unitDetailsState = IsLoggedInState();
    } else {
      unitDetailsState = IsGuestModeState();
    }
    return unitDetailsState;
  }


}
