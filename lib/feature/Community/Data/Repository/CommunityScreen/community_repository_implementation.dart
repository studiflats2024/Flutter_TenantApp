import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Models/activity_model.dart';
import 'package:vivas/feature/Community/Data/Repository/CommunityScreen/community_repository.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/community_bloc.dart';

class CommunityRepositoryImplementation implements CommunityRepository {
  CommunityManager communityManager;

  CommunityRepositoryImplementation(this.communityManager);

  @override
  Future<CommunityState> getMonthlyActivities(int pageNumber) async {
    CommunityState communityState = CommunityInitial();
    await communityManager.getCommunityMonthlyActivities(
      PagingListSendModel(pageNumber: pageNumber, pageSize: 10),
      (activities) {
        communityState = CommunityLoadedMonthlyActivityState(activities);
      },
      (fail) {
        communityState = CommunityErrorState(
          fail.message,
          fail.isMessageLocalizationKey,
        );
      },
    );
    return communityState;
  }

  @override
  Future<CommunityState> getClubActivities(int pageNumber,
      {ActivitiesType? activitiesType}) async {
    CommunityState communityState = CommunityInitial();
    await communityManager.getCommunityClubActivities(
      PagingCommunityActivitiesListSendModel(
          activitiesType: activitiesType, pageNumber: pageNumber, pageSize: 10),
      (activities) {
        communityState = CommunityLoadedClubActivityState(activities);
      },
      (fail) {
        communityState = CommunityErrorState(
          fail.message,
          fail.isMessageLocalizationKey,
        );
      },
    );
    return communityState;
  }

  @override
  Future<CommunityState> getSubscriptionPlans(int pageNumber) async {
    CommunityState communityState = CommunityInitial();
    await communityManager.getSubscriptionsPlan(
      PagingListSendModel(pageNumber: pageNumber, pageSize: 10),
      (plans) {
        communityState = CommunityLoadedSubscriptionPlansState(plans);
      },
      (fail) {
        communityState = CommunityErrorState(
          fail.message,
          fail.isMessageLocalizationKey,
        );
      },
    );
    return communityState;
  }

}
