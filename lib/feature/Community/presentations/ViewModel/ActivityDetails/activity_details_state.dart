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

class ChooseDayTimeState extends ActivityDetailsState {
  final ConsultDay day;

  ChooseDayTimeState(this.day);
}

class ChooseTimeState extends ActivityDetailsState {
  final String time;

  ChooseTimeState(this.time);
}

class ActivityDetailsErrorState extends ActivityDetailsState {
  final String errorMassage;
  final bool isLocalizationKey;

  ActivityDetailsErrorState(this.errorMassage, this.isLocalizationKey);
}

class FilterRatingState extends ActivityDetailsState {
  final String filter;

  FilterRatingState(this.filter);
}
