part of 'club_activity_bloc.dart';

@immutable
sealed class ClubActivityEvent {}

class GetClubActivityEvent extends ClubActivityEvent{
  final PagingCommunityActivitiesListSendModel model;
  GetClubActivityEvent(this.model);
}

class ChangeFilterActivityType extends ClubActivityEvent{
  final ActivitiesType type;
  ChangeFilterActivityType(this.type);
}
