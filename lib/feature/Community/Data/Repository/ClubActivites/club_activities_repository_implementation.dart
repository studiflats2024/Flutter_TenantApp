import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/paginated_club_activity_model.dart';
import 'package:vivas/feature/Community/Data/Repository/ClubActivites/club_activities_repository.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/ClubActivity/club_activity_bloc.dart';

class ClubActivitiesRepositoryImplementation
    implements ClubActivitiesRepository {
  CommunityManager communityManager;

  ClubActivitiesRepositoryImplementation(this.communityManager);

  @override
  Future<ClubActivityState> getClubActivities(
      PagingCommunityActivitiesListSendModel model) async{
    ClubActivityState state = ClubActivityInitial();
    await communityManager.getCommunityClubActivities(
     model,
          (activities) {
        state = GetClubActivityState(activities);
      },
          (fail) {
        state = ErrorClubActivityState(
          fail.message,
          fail.isMessageLocalizationKey,
        );
      },
    );
    return state;
  }
}
