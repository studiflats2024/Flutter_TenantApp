part of 'activity_details_bloc.dart';

@immutable
sealed class ActivityDetailsState {}

final class ActivityDetailsInitial extends ActivityDetailsState {}

final class ActivityDetailsLoadingState extends ActivityDetailsState {}

final class GetActivityDetailsState extends ActivityDetailsState {
  ActivityDetailsModel activityDetailsModel;

  GetActivityDetailsState(this.activityDetailsModel);
}

final class ActivityDetailsErrorState extends ActivityDetailsState {
  final String errorMassage;
  final bool isLocalizationKey;

  ActivityDetailsErrorState(this.errorMassage, this.isLocalizationKey);
}
