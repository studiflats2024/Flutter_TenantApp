import 'package:get_it/get_it.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/area_model/area_list_wrapper.dart';
import 'package:vivas/apis/models/city_model/city_list_wrapper.dart';
import 'package:vivas/apis/models/general/faq_list_wrapper.dart';
import 'package:vivas/apis/models/general/home_ads_list_wrapper.dart';
import 'package:vivas/apis/models/general/home_count_wrapper.dart';
import 'package:vivas/apis/models/general/privacy_privacy_model.dart';
import 'package:vivas/apis/models/general/terms_conditions_model.dart';
import 'package:vivas/feature/NewAppVersion/Data/Models/app_version_model.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:flutter/material.dart';

class GeneralApiManger {
  final DioApiManager dioApiManager;
  late final bool isDowned;
  final BuildContext context;

  GeneralApiManger(this.dioApiManager, this.context);

  var preferencesManager = GetIt.I<PreferencesManager>();

  Future<void> getSearchAreaList(
      Future<void> Function(AreaListWrapper areaListWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(ApiKeys.areaUrl).then((response) async {
      if (response.statusCode == 502) {
        preferencesManager.setIsDown();
        fail(ErrorApiModel.identifyError(
            error: "Server On Maintenance", context: context));
      } else {
        List<dynamic> extractedData = response.data as List<dynamic>;
        preferencesManager.setIsNotDown();
        AreaListWrapper wrapper = AreaListWrapper.fromJson(extractedData);
        await success(wrapper);
      }
    }).catchError((error) async {
      preferencesManager.setIsDown();
      isDowned = await preferencesManager.isDown();
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getSearchCityList(
      Future<void> Function(CityListWrapper areaListWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(ApiKeys.cityUrl).then((response) async {
      if (response.statusCode == 502) {
        preferencesManager.setIsDown();
        fail(ErrorApiModel.identifyError(
            error: "Server On Maintenance", context: context));
      } else {
        preferencesManager.setIsNotDown();
        Map<String, dynamic> extractedData =
            response.data as Map<String, dynamic>;
        // Map<String, dynamic> extractedData = {
        //   "cityName": ["area1", "area2"],
        //   "cityName2": ["area1", "area2"],
        //   "cityName3": ["area1", "area2"],
        // };

        CityListWrapper wrapper = CityListWrapper.fromJson(extractedData);
        await success(wrapper);
      }
    }).catchError((error) async {
      preferencesManager.setIsDown();
      isDowned = await preferencesManager.isDown();
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getTermsConditionsApi(Function(TermsConditionsModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dioUnauthorized
        .get(ApiKeys.termsConditionsUrl)
        .then((response) async {
      String? extractedData = response.data as String?;
      TermsConditionsModel wrapper =
          TermsConditionsModel.fromJson(extractedData);
      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getPrivacyPrivacyApi(Function(PrivacyPrivacyModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dioUnauthorized
        .get(ApiKeys.privacyPrivacyUrl)
        .then((response) async {
      String? extractedData = response.data as String?;
      PrivacyPrivacyModel wrapper = PrivacyPrivacyModel.fromJson(extractedData);
      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getHomeAdsApi(Function(HomeAdsListWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dioUnauthorized
        .get(ApiKeys.getAdsUrl)
        .then((response) async {
      List<dynamic> extractedData = response.data as List<dynamic>;
      HomeAdsListWrapper wrapper = HomeAdsListWrapper.fromJson(extractedData);
      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getNotificationCountApi(Function(HomeCountWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(ApiKeys.getCountsUrl).then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      HomeCountWrapper wrapper = HomeCountWrapper.fromJson(extractedData);
      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getFaqApi(Function(FAQListWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dioUnauthorized
        .get(ApiKeys.getFAQUrl)
        .then((response) async {
      List<dynamic> extractedData = response.data as List<dynamic>;
      FAQListWrapper wrapper = FAQListWrapper.fromJson(extractedData);

      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> checkVersionApi(Function(AppVersionModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dioUnauthorized
        .get(ApiKeys.gVersionUrl)
        .then((response) async {
      AppVersionModel wrapper = AppVersionModel.fromJson(response.data);
      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }
}
