import 'package:get_it/get_it.dart';
import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/activity_details_send.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/enroll_activity_send_model.dart';
import 'package:vivas/feature/Community/Data/Repository/ActivityDetails/activity_details_repository.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/ActivityDetails/activity_details_bloc.dart';
import 'package:vivas/preferences/preferences_manager.dart';

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

  @override
  Future<ActivityDetailsState> enroll(EnrollActivitySendModel model) async {
    ActivityDetailsState activityDetailsState = ActivityDetailsInitial();
    await communityManager.enrollActivity(model, (response) {
      activityDetailsState = SuccessEnrollState(response);
    }, (fail) {
      activityDetailsState = ActivityDetailsErrorState(
          fail.message, fail.isMessageLocalizationKey);
    });
    return activityDetailsState;
  }

  @override
  Future<ActivityDetailsState> checkLoggedIn() async {
    late ActivityDetailsState state;
    PreferencesManager preferencesManager = GetIt.I<PreferencesManager>();
    bool isLoggedIn = await preferencesManager.isLoggedIn();
    if (isLoggedIn) {
      state = IsLoggedInState();
    } else {
      state = IsGuestModeState();
    }
    return state;
  }
}
