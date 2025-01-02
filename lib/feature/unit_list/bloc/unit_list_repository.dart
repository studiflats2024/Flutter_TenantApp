import 'package:vivas/apis/managers/apartment_api_manger.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/feature/unit_list/bloc/unit_list_bloc.dart';
import 'package:vivas/preferences/preferences_manager.dart';

abstract class BaseUnitListRepository {
  Future<UnitListState> getUnitListApi(int pageNumber);

  Future<UnitListState> getUnitListApiV2(int pageNumber);
}

class UnitListRepository implements BaseUnitListRepository {
  final PreferencesManager preferencesManager;
  final ApartmentApiManger apartmentApiManger;

  UnitListRepository({
    required this.preferencesManager,
    required this.apartmentApiManger,
  });

  @override
  Future<UnitListState> getUnitListApi(int pageNumber) async {
    late UnitListState unitListState;
    await apartmentApiManger.getApartmentListApi(
        PagingListSendModel(pageNumber: pageNumber), (apartmentListWrapper) {
      unitListState = UnitListLoadedState(
          apartmentListWrapper.data, apartmentListWrapper.pagingInfo);
    }, (errorApiModel) {
      unitListState = UnitListErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return unitListState;
  }

  @override
  Future<UnitListState> getUnitListApiV2(int pageNumber) async{
    late UnitListState unitListState;
    await apartmentApiManger.getApartmentListApiV2(
        PagingListSendModel2(pageNumber: pageNumber), (apartmentListWrapper) {
      unitListState = UnitListLoadedStateV2(
          apartmentListWrapper.data, apartmentListWrapper.pagingInfo);
    }, (errorApiModel) {
      unitListState = UnitListErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return unitListState;
  }
}
