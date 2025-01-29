import 'package:vivas/feature/Community/Data/Models/activity_model.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/community_bloc.dart';

abstract class CommunityRepository {
  Future<CommunityState> getMonthlyActivities(int pageNumber,);

  Future<CommunityState> getClubActivities(int pageNumber,
      {ActivitiesType? activitiesType});

  Future<CommunityState> getSubscriptionPlans(int pageNumber);
}
