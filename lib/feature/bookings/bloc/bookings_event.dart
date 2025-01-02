part of 'bookings_bloc.dart';

sealed class BookingsEvent extends Equatable {
  const BookingsEvent();

  @override
  List<Object> get props => [];
}

class GetActiveBookingsEvent extends BookingsEvent {
  final int pageNumber;
  final bool isSwipeToRefresh;
  const GetActiveBookingsEvent(this.pageNumber, this.isSwipeToRefresh);

  bool isFirstLoad() => (pageNumber == 1) ? true : false;
  @override
  List<Object> get props => [pageNumber, isSwipeToRefresh];
}

class GetExpiredBookingsEvent extends BookingsEvent {
  final int pageNumber;
  final bool isSwipeToRefresh;
  const GetExpiredBookingsEvent(this.pageNumber, this.isSwipeToRefresh);

  bool isFirstLoad() => (pageNumber == 1) ? true : false;
  @override
  List<Object> get props => [pageNumber, isSwipeToRefresh];
}

class GetOffersBookingsEvent extends BookingsEvent {
  final int pageNumber;
  final bool isSwipeToRefresh;
  const GetOffersBookingsEvent(this.pageNumber, this.isSwipeToRefresh);

  bool isFirstLoad() => (pageNumber == 1) ? true : false;
  @override
  List<Object> get props => [pageNumber, isSwipeToRefresh];
}

class CheckIsLoggedInEvent extends BookingsEvent {
  @override
  List<Object> get props => [identityHashCode(this)];
}
