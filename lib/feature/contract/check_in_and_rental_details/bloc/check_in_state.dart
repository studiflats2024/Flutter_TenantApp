part of 'check_in_details_bloc.dart';

abstract class CheckInDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckInDetailsInitial extends CheckInDetailsState {}

class CheckInDetailsLoadingState extends CheckInDetailsState {}

class CheckInDetailsErrorState extends CheckInDetailsState {
  final String errorMassage;
  final bool isLocalizationKey;
  CheckInDetailsErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class CheckInDetailsLoadedState extends CheckInDetailsState {
  final CheckInDetailsResponse checkInDetailsResponse;
  CheckInDetailsLoadedState(this.checkInDetailsResponse);

  @override
  List<Object?> get props => [checkInDetailsResponse];
}
