import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/activity_details_send.dart';
import 'package:vivas/feature/Community/Data/Repository/ActivityDetails/activity_details_repository.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/ActivityDetails/activity_details_bloc.dart';

class ActivityDetailsRepositoryImplementation
    extends ActivityDetailsRepository {
  CommunityManager communityManager;

  ActivityDetailsRepositoryImplementation(this.communityManager);

  @override
  Future<ActivityDetailsState> getActivityDetails(
      ActivityDetailsSendModel activityDetailsSendModel) async {
    ActivityDetailsState activityDetailsState = ActivityDetailsInitial();
    await communityManager.getActivityDetails(activityDetailsSendModel,
        (detailsModel) {
      activityDetailsState = GetActivityDetailsState(detailsModel);
    }, (fail) {
      activityDetailsState = ActivityDetailsErrorState(
          fail.message, fail.isMessageLocalizationKey);
    });
    return activityDetailsState;
  }
}
