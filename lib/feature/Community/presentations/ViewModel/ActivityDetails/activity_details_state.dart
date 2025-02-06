part of 'activity_details_bloc.dart';

@immutable
sealed class ActivityDetailsState {}

class ActivityDetailsInitial extends ActivityDetailsState {}

class ActivityDetailsLoadingState extends ActivityDetailsState {}

class GetActivityDetailsState extends ActivityDetailsState {
  final ActivityDetailsModel activityDetailsModel;

  GetActivityDetailsState(this.activityDetailsModel);
}

class SuccessEnrollState extends ActivityDetailsState {
  final BaseMessageModel model;

  SuccessEnrollState(this.model);
}

class ActivityDetailsErrorState extends ActivityDetailsState {
  final String errorMassage;
  final bool isLocalizationKey;

  ActivityDetailsErrorState(this.errorMassage, this.isLocalizationKey);
}
