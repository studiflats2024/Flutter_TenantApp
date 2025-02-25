part of 'community_bloc.dart';

@immutable
sealed class CommunityEvent {}

class GetCommunityMonthlyActivities extends CommunityEvent {
  final int pageNumber;

  GetCommunityMonthlyActivities(this.pageNumber);
}

class GetCommunityClubActivities extends CommunityEvent {
  final int pageNumber;

  GetCommunityClubActivities(this.pageNumber);
}


class GetCommunitySubscriptionPlans extends CommunityEvent {
  final int pageNumber;

  GetCommunitySubscriptionPlans(this.pageNumber);
}

class CheckLoggedInEvent extends CommunityEvent {

  CheckLoggedInEvent();
}
