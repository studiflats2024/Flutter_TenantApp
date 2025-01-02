import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/apartments/wish_list/wish_item_api_model.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/feature/wishlist/bloc/wishlist_repository.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final BaseWishlistRepository wishlistRepository;
  WishlistBloc(this.wishlistRepository) : super(WishlistInitial()) {
    on<GetWishlistApiEvent>(_getWishlistApiEvent);
    on<CheckIsLoggedInEvent>(_checkIsLoggedInEvent);
  }

  FutureOr<void> _getWishlistApiEvent(
      GetWishlistApiEvent event, Emitter<WishlistState> emit) async {
    emit(WishlistLoadingState());
    if (!event.isSwipeToRefresh) {
      emit((event.isFirstLoad())
          ? WishlistLoadingState()
          : WishlistLoadingAsPagingState());
    }
    emit(await wishlistRepository.getWishlistApi(event.pageNumber));
  }

  Future<FutureOr<void>> _checkIsLoggedInEvent(
      CheckIsLoggedInEvent event, Emitter<WishlistState> emit) async {
    emit(await wishlistRepository.checkLoggedIn());
  }
}
