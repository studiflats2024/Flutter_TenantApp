import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vivas/apis/managers/apartment_api_manger.dart';
import 'package:vivas/apis/models/wish_list/add_wish_list_send_model.dart';
import 'package:vivas/apis/models/wish_list/remove_wish_list_send_model.dart';
import 'package:vivas/preferences/preferences_manager.dart';

import 'add_remove_wish_bloc.dart';

abstract class BaseAddRemoveWishRepository {
  const BaseAddRemoveWishRepository();
  Future<AddRemoveWishState> addWishListApi(String uuid);
  Future<AddRemoveWishState> removeWishListApi(String uuid);
}

class AddRemoveWishRepository implements BaseAddRemoveWishRepository {
  final ApartmentApiManger apartmentApiManger;
  final PreferencesManager preferencesManager;

  const AddRemoveWishRepository({
    required this.preferencesManager,
    required this.apartmentApiManger,
  });

  @override
  Future<AddRemoveWishState> addWishListApi(String uuid) async {
    late AddRemoveWishState addDeleteBookmarkState;
    bool isLoggedIn = await preferencesManager.isLoggedIn();
    String? token =
        isLoggedIn ? null : await FirebaseMessaging.instance.getToken();
    await apartmentApiManger
        .addWishListApi(AddWishListSendModel(aptId: uuid, deviceToken: token),
            (detailsApiModel) {
      addDeleteBookmarkState = WishAddedState(id: uuid);
    }, (errorApiModel) {
      addDeleteBookmarkState = AddRemoveWishErrorState(
        errorApiModel.message,
        errorApiModel.isMessageLocalizationKey,
        id: uuid,
      );
    });
    return addDeleteBookmarkState;
  }

  @override
  Future<AddRemoveWishState> removeWishListApi(String uuid) async {
    late AddRemoveWishState addDeleteBookmarkState;
    bool isLoggedIn = await preferencesManager.isLoggedIn();
    String? token =
        isLoggedIn ? null : await FirebaseMessaging.instance.getToken();
    await apartmentApiManger.removeWishListApi(
        RemoveWishListSendModel(wishId: uuid, deviceToken: token),
        (detailsApiModel) {
      addDeleteBookmarkState = BookmarkRemoveState(id: uuid);
    }, (errorApiModel) {
      addDeleteBookmarkState = AddRemoveWishErrorState(
        errorApiModel.message,
        errorApiModel.isMessageLocalizationKey,
        id: uuid,
      );
    });
    return addDeleteBookmarkState;
  }
}
