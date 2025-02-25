import 'package:vivas/feature/Community/Data/Managers/activity_enum.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/community_bloc.dart';

abstract class CommunityRepository {
  Future<CommunityState> getMonthlyActivities(int pageNumber,);

  Future<CommunityState> getClubActivities(int pageNumber,
      {ActivitiesType? activitiesType});

  Future<CommunityState> getSubscriptionPlans(int pageNumber);

  Future<CommunityState> checkLoggedIn();

}
