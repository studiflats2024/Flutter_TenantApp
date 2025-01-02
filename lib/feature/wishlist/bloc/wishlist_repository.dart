import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vivas/apis/managers/apartment_api_manger.dart';
import 'package:vivas/apis/models/wish_list/get_wish_list_send_model.dart';
import 'package:vivas/feature/wishlist/bloc/wishlist_bloc.dart';
import 'package:vivas/preferences/preferences_manager.dart';

abstract class BaseWishlistRepository {
  Future<WishlistState> getWishlistApi(int pageNumber);
  Future<WishlistState> checkLoggedIn();
}

class WishlistRepository implements BaseWishlistRepository {
  final PreferencesManager preferencesManager;
  final ApartmentApiManger apartmentApiManger;

  WishlistRepository({
    required this.preferencesManager,
    required this.apartmentApiManger,
  });

  @override
  Future<WishlistState> getWishlistApi(int pageNumber) async {
    late WishlistState wishlistState;
    bool isLoggedIn = await preferencesManager.isLoggedIn();
    String? token =
        isLoggedIn ? null : await FirebaseMessaging.instance.getToken();
    await apartmentApiManger.getWishListApi(
        GetWishListSendModel(pageNumber: pageNumber, deviceToken: token),
        (apartmentListWrapper) {
      wishlistState = WishlistLoadedState(
          apartmentListWrapper.data, apartmentListWrapper.pagingInfo);
    }, (errorApiModel) {
      wishlistState = WishlistErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return wishlistState;
  }

  @override
  Future<WishlistState> checkLoggedIn() async {
    late WishlistState wishlistState;

    bool isLoggedIn = await preferencesManager.isLoggedIn();
    if (isLoggedIn) {
      wishlistState = IsLoggedInState();
    } else {
      wishlistState = IsGuestModeState();
    }
    return wishlistState;
  }
}
