import 'package:flutter/material.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/apartments/ApartmentQrDetails/apartment_qr_details_model.dart';
import 'package:vivas/apis/models/apartments/apartment_details/apartment_details_api_model_v2.dart';
import 'package:vivas/apis/models/apartments/apartment_details/unit_details_api_model.dart';
import 'package:vivas/apis/models/apartments/apartment_list/apartment_list_wrapper.dart';
import 'package:vivas/apis/models/apartments/apartment_list/search_send_model.dart';
import 'package:vivas/apis/models/apartments/wish_list/wish_list_wrapper.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/apis/models/wish_list/add_wish_list_send_model.dart';
import 'package:vivas/apis/models/wish_list/get_wish_list_send_model.dart';
import 'package:vivas/apis/models/wish_list/remove_wish_list_send_model.dart';
import 'package:vivas/apis/models/wish_list/update_wish_list_request_response.dart';

class ApartmentApiManger {
  final DioApiManager dioApiManager;
  final BuildContext context;
  ApartmentApiManger(this.dioApiManager , this.context);

  Future<void> getApartmentListApi(
      PagingListSendModel pagingListSendModel,
      void Function(ApartmentListWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getApartmentUrl,
            queryParameters: pagingListSendModel.toJson())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ApartmentListWrapper wrapper =
          ApartmentListWrapper.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error , context: context));
    });
  }

  Future<void> getApartmentListApiV2(
      PagingListSendModel2 pagingListSendModel,
      void Function(ApartmentListWrapperV2) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getApartmentV2Url,
            queryParameters: pagingListSendModel.toJson())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ApartmentListWrapperV2 wrapper =
          ApartmentListWrapperV2.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error , context: context));
    });
  }

  Future<void> getApartmentDetailsApi(
      String uuid,
      void Function(UnitDetailsApiModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(
      ApiKeys.getApartmentByIdUrl,
      queryParameters: {"id": uuid},
    ).then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      UnitDetailsApiModel wrapper = UnitDetailsApiModel.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error , context: context));
    });
  }

  Future<void> getApartmentDetailsApiV2(
      String uuid,
      void Function(ApartmentDetailsApiModelV2) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(
      ApiKeys.getApartmentByIdV2Url,
      queryParameters: {"Apartment_ID": uuid},
    ).then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ApartmentDetailsApiModelV2 wrapper =
          ApartmentDetailsApiModelV2.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error , context: context));
    });
  }

  Future<void> getSearchApartmentListApi(
      SearchSendModel searchSendModel,
      void Function(ApartmentListWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.getSearchApartmentUrl,
            data: searchSendModel.toJson())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ApartmentListWrapper wrapper =
          ApartmentListWrapper.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error , context: context));
    });
  }

  Future<void> getWishListApi(
      GetWishListSendModel getWishListSendModel,
      void Function(WishListWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getWishListUrl,
            queryParameters: getWishListSendModel.toJson())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      WishListWrapper wrapper = WishListWrapper.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error , context: context));
    });
  }

  Future<void> addWishListApi(
      AddWishListSendModel addWishListSendModel,
      void Function(UpdateWishListRequestResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.addWishListUrl, data: addWishListSendModel.toJson())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      UpdateWishListRequestResponse wrapper =
          UpdateWishListRequestResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error , context: context));
    });
  }

  Future<void> removeWishListApi(
      RemoveWishListSendModel removeWishListSendModel,
      void Function(UpdateWishListRequestResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .delete(ApiKeys.removeWishListUrl,
            queryParameters: removeWishListSendModel.toJson())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      UpdateWishListRequestResponse wrapper =
          UpdateWishListRequestResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error , context: context));
    });
  }

  Future<void> getQrDetails(
      String qrCode,
      void Function(ApartmentQrDetailsModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(ApiKeys.getQrDetailsUrl,
        queryParameters: {"Apartment_QR": qrCode}).then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      success(ApartmentQrDetailsModel.fromJson(extractedData));
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error , context: context));
    });
  }
}
