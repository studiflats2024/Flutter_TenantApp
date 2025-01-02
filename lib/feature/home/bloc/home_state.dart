part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [identityHashCode(this)];
}

final class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {
  final String errorMassage;
  final bool isLocalizationKey;
  const HomeErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class HomeSliderInfoLoadedState extends HomeState {
  final List<HomeAdsModel> list;

  const HomeSliderInfoLoadedState(this.list);
  @override
  List<Object> get props => [list];
}

class HomeCountsLoadedState extends HomeState {
  final int chatsCount;
  final int notificationsCount;

  const HomeCountsLoadedState(this.chatsCount, this.notificationsCount);
  @override
  List<Object> get props => [chatsCount, notificationsCount];
}

class HomeOfferInfoLoadedState extends HomeState {
  final List<ApartmentItemApiModel> list;
  const HomeOfferInfoLoadedState(this.list);
  @override
  List<Object> get props => [list];
}

class HomeOfferInfoLoadedStateV2 extends HomeState {
  final List<ApartmentItemApiV2Model> list;
  const HomeOfferInfoLoadedStateV2(this.list);
  @override
  List<Object> get props => [list];
}


class OpenUnitListScreenState extends HomeState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class HomeQrDetailsResponseState extends HomeState{
  final  ApartmentQrDetailsModel apartmentQrDetailsModel;
  const HomeQrDetailsResponseState(this.apartmentQrDetailsModel);

  @override
  List<Object> get props => [identityHashCode(this)];
}

class HomeSetQrDetailsResponse extends HomeState{
  final  Barcode data;
  const HomeSetQrDetailsResponse(this.data);
  @override
  List<Object> get props => [identityHashCode(this)];
}
