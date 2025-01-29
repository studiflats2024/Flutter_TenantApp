part of 'community_bloc.dart';

@immutable
sealed class CommunityState {}

final class CommunityInitial extends CommunityState {}

class CommunityLoadingState extends CommunityState {}

class CommunityLoadedMonthlyActivityState extends CommunityState {
  final ClubActivityModel clubActivityModel;

  CommunityLoadedMonthlyActivityState(
    this.clubActivityModel,
  );
}

class CommunityLoadedClubActivityState extends CommunityState {
  final ClubActivityModel clubActivityModel;

  CommunityLoadedClubActivityState(
    this.clubActivityModel,
  );
}

class CommunityLoadedSubscriptionPlansState extends CommunityState {
  final List<SubscriptionPlansModel> subscriptionPlansModel;

  CommunityLoadedSubscriptionPlansState(
    this.subscriptionPlansModel,
  );
}

class CommunityErrorState extends CommunityState {
  final String errorMassage;
  final bool isLocalizationKey;

  CommunityErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}
