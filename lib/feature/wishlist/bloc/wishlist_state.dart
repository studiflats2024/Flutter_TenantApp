part of 'wishlist_bloc.dart';

sealed class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

final class WishlistInitial extends WishlistState {}

final class IsLoggedInState extends WishlistState {}

final class IsGuestModeState extends WishlistState {}

class WishlistLoadingState extends WishlistState {}

class WishlistLoadingAsPagingState extends WishlistState {}

class WishlistErrorState extends WishlistState {
  final String errorMassage;
  final bool isLocalizationKey;
  const WishlistErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class WishlistLoadedState extends WishlistState {
  final List<WishItemApiModel> list;
  final MetaModel pagingInfo;

  const WishlistLoadedState(this.list, this.pagingInfo);
  @override
  List<Object> get props => [list];
}
