part of 'wishlist_bloc.dart';

sealed class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class GetWishlistApiEvent extends WishlistEvent {
  final int pageNumber;
  final bool isSwipeToRefresh;
  const GetWishlistApiEvent(this.pageNumber, this.isSwipeToRefresh);

  bool isFirstLoad() => (pageNumber == 1) ? true : false;
  @override
  List<Object> get props => [pageNumber, isSwipeToRefresh];
}

class CheckIsLoggedInEvent extends WishlistEvent {
  @override
  List<Object> get props => [identityHashCode(this)];
}
