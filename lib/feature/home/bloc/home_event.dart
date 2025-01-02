part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetSliderInfoApiEvent extends HomeEvent {
  const GetSliderInfoApiEvent();

  @override
  List<Object> get props => [identityHashCode(this)];
}

class GetNotificationCountApiEvent extends HomeEvent {
  const GetNotificationCountApiEvent();

  @override
  List<Object> get props => [identityHashCode(this)];
}

class GetBestOfferInfoApiEvent extends HomeEvent {
  const GetBestOfferInfoApiEvent();

  @override
  List<Object> get props => [identityHashCode(this)];
}

class BestOfferSeeAllClickedEvent extends HomeEvent {
  const BestOfferSeeAllClickedEvent();

  @override
  List<Object> get props => [identityHashCode(this)];
}

class GetQrDetailsEvent extends HomeEvent {
  final String qrCode;
  const GetQrDetailsEvent(this.qrCode);

  @override
  List<Object> get props => [identityHashCode(this)];
}

class SetQrDetailsEvent extends HomeEvent {
  final Barcode data;
  const SetQrDetailsEvent(this.data);

  @override
  List<Object> get props => [identityHashCode(this)];
}