part of 'club_activity_bloc.dart';

@immutable
sealed class ClubActivityState {}

class ClubActivityInitial extends ClubActivityState {}

class ClubActivityLoading extends ClubActivityState {}

class ChangeActivityTypeState extends ClubActivityState{
  final ActivitiesType type;
  ChangeActivityTypeState(this.type);
}

class GetClubActivityState extends ClubActivityState {
  final ClubActivityModel activitiesModel;
  GetClubActivityState(this.activitiesModel);
}

final class GetClubActivityPaginatedState extends ClubActivityState {}

final class ErrorClubActivityState extends ClubActivityState {
  final String errorMassage;
  final bool isLocalizationKey;

  ErrorClubActivityState(this.errorMassage, this.isLocalizationKey);
}
