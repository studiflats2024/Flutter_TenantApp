import 'package:get_it/get_it.dart';
import 'package:vivas/apis/managers/general_api_manger.dart';
import 'package:vivas/feature/NewAppVersion/Presentations/ViewModel/app_version_bloc.dart';
import 'package:vivas/feature/splash/bloc/splash_bloc.dart';
import 'package:vivas/mangers/search_manger.dart';

import 'package:vivas/preferences/preferences_manager.dart';

abstract class BaseSplashRepository {
  Future<SplashState> getAreaApi();
  Future<SplashState> getCityApi();
  Future<AppVersionState> checkingVersionApi(String version);
}

class SplashRepository implements BaseSplashRepository {
  final PreferencesManager preferencesManager;
  final GeneralApiManger generalApiManger;

  SplashRepository(
      {required this.preferencesManager, required this.generalApiManger});

  @override
  Future<SplashState> getAreaApi() async {
    late SplashState splashState;
    await generalApiManger.getSearchAreaList((apartmentListWrapper) async {
      GetIt.I<SearchManger>().areasList = apartmentListWrapper.data;
      splashState = AreaLoadedState(apartmentListWrapper.data);
    }, (errorApiModel) {
      splashState = const AreaLoadedState([]);
    });
    return splashState;
  }

  @override
  Future<SplashState> getCityApi() async {
    late SplashState splashState;
    await generalApiManger.getSearchCityList((apartmentListWrapper) async {
      GetIt.I<SearchManger>().citiesList = apartmentListWrapper.data;
      splashState = CitiesLoadedState(apartmentListWrapper.data);
    }, (errorApiModel) {
      splashState = const CitiesLoadedState([]);
    });
    return splashState;
  }

  @override
  Future<AppVersionState> checkingVersionApi(String version) async {
    late AppVersionState appVersionState;
    await generalApiManger.checkVersionApi((checkingResponse) async {

      if(checkingResponse.version == version){
        appVersionState = AppVersionReadyForUse();
      }else{
        appVersionState = AppVersionNeedToUpdate();
      }

    }, (errorApiModel) {
      appVersionState =  AppVersionFailed(errorApiModel);
    });
    return appVersionState;
  }
}
