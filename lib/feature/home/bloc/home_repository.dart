import 'package:vivas/apis/managers/apartment_api_manger.dart';
import 'package:vivas/apis/managers/general_api_manger.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/feature/home/bloc/home_bloc.dart';
import 'package:vivas/preferences/preferences_manager.dart';

abstract class BaseHomeRepository {
  Future<HomeState> getSliderInfo();
  Future<HomeState> getBestOfferInfoApi();
  Future<HomeState> getNotificationCountApi();
  Future<HomeState> getQrDetailsApi({required String qrCode});
}

class HomeRepository implements BaseHomeRepository {
  final PreferencesManager preferencesManager;
  final ApartmentApiManger apartmentApiManger;
  final GeneralApiManger generalApiManger;

  HomeRepository({
    required this.preferencesManager,
    required this.apartmentApiManger,
    required this.generalApiManger,
  });

  @override
  Future<HomeState> getSliderInfo() async {
    late HomeState homeState;
    await generalApiManger.getHomeAdsApi((homeAdsListWrapper) {
      homeState = HomeSliderInfoLoadedState(homeAdsListWrapper.data);
    }, (errorApiModel) {
      homeState = HomeErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return homeState;
  }

  @override
  Future<HomeState> getNotificationCountApi() async {
    late HomeState homeState;
    await generalApiManger.getNotificationCountApi((homeCountWrapper) {
      homeState = HomeCountsLoadedState(
        homeCountWrapper.chatsCount,
        homeCountWrapper.notificationsCount,
      );
    }, (errorApiModel) {
      homeState = HomeErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return homeState;
  }

  @override
  Future<HomeState> getBestOfferInfoApi() async {
    late HomeState homeState;

    await apartmentApiManger.getApartmentListApiV2(
        const PagingListSendModel2(pageNumber: 1, pageSize: 10),
        (apartmentListWrapper) {
      homeState = HomeOfferInfoLoadedStateV2(apartmentListWrapper.data);
    }, (errorApiModel) {
      homeState = HomeErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return homeState;
  }

  @override
  Future<HomeState> getQrDetailsApi({required String qrCode}) async {
    late HomeState homeState;

    await apartmentApiManger.getQrDetails(
        qrCode,
        (data) {
      homeState = HomeQrDetailsResponseState(data);
    }, (errorApiModel) {
      homeState = HomeErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return homeState;
  }
}
