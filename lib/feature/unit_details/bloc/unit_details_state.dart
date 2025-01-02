part of 'unit_details_bloc.dart';

sealed class UnitDetailsState extends Equatable {
  const UnitDetailsState();

  @override
  List<Object> get props => [];
}

final class UnitDetailsInitial extends UnitDetailsState {}

final class IsLoggedInState extends UnitDetailsState {}

final class IsGuestModeState extends UnitDetailsState {}

class UnitDetailLoadingState extends UnitDetailsState {}

class UnitDetailErrorState extends UnitDetailsState {
  final String errorMassage;
  final bool isLocalizationKey;
  const UnitDetailErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class UnitDetailsLoadedState extends UnitDetailsState {
  final UnitDetailsApiModel unitDetailsApiModel;

  const UnitDetailsLoadedState(this.unitDetailsApiModel);
  @override
  List<Object> get props => [unitDetailsApiModel];
}

class UnitDetailsLoadedStateV2 extends UnitDetailsState {
  final ApartmentDetailsApiModelV2 unitDetailsApiModel;

  const UnitDetailsLoadedStateV2(this.unitDetailsApiModel);
  @override
  List<Object> get props => [unitDetailsApiModel];
}

class FaqLoadedState extends UnitDetailsState {
  final List<FAQModel> faqList;
  const FaqLoadedState(this.faqList);
  @override
  List<Object> get props => [faqList];
}
