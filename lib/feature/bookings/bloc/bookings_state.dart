part of 'bookings_bloc.dart';

sealed class BookingsState extends Equatable {
  const BookingsState();

  @override
  List<Object> get props => [];
}

final class BookingsInitial extends BookingsState {}

class BookingsErrorState extends BookingsState {
  final String errorMassage;
  final bool isLocalizationKey;
  const BookingsErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class BookingsActiveLoadingState extends BookingsState {}

class BookingsActiveLoadingAsPagingState extends BookingsState {}

class BookingsActiveLoadedState extends BookingsState {
  final List<ApartmentRequestsApiModel> list;
  final MetaModel pagingInfo;

  const BookingsActiveLoadedState(this.list, this.pagingInfo);
  @override
  List<Object> get props => [list];
}

class BookingsActiveLoadedStateV2 extends BookingsState {
  final List<BookingModel> list;
  final MetaModel pagingInfo;

  const BookingsActiveLoadedStateV2(this.list, this.pagingInfo);
  @override
  List<Object> get props => [list];
}

class BookingsExpiredLoadingState extends BookingsState {}

class BookingsExpiredLoadingAsPagingState extends BookingsState {}

class BookingsExpiredLoadedState extends BookingsState {
  final List<ApartmentRequestsApiModel> list;
  final MetaModel pagingInfo;

  const BookingsExpiredLoadedState(this.list, this.pagingInfo);
  @override
  List<Object> get props => [list];
}
class BookingsExpiredLoadedStateV2 extends BookingsState {
  final List<BookingModel> list;
  final MetaModel pagingInfo;

  const BookingsExpiredLoadedStateV2(this.list, this.pagingInfo);
  @override
  List<Object> get props => [list];
}

class BookingsOffersLoadingState extends BookingsState {}

class BookingsOffersLoadingAsPagingState extends BookingsState {}

class BookingsOffersLoadedState extends BookingsState {
  final List<ApartmentRequestsApiModel> list;
  final MetaModel pagingInfo;

  const BookingsOffersLoadedState(this.list, this.pagingInfo);
  @override
  List<Object> get props => [list];
}
class BookingsOffersLoadedStateV2 extends BookingsState {
  final List<BookingModel> list;
  final MetaModel pagingInfo;

  const BookingsOffersLoadedStateV2(this.list, this.pagingInfo);
  @override
  List<Object> get props => [list];
}

final class IsLoggedInState extends BookingsState {}

final class IsGuestModeState extends BookingsState {}
