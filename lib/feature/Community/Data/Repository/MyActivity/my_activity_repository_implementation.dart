import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/my_activity_rating_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/my_activity_send_model.dart';
import 'package:vivas/feature/Community/Data/Repository/MyActivity/my_activity_repository.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/MyActivity/my_activity_bloc.dart';

class MyActivityRepositoryImplementation implements MyActivityRepository {
  CommunityManager communityManager;

  MyActivityRepositoryImplementation(this.communityManager);

  @override
  Future<MyActivityState> getMyActivity(
      MyActivitySendModel model, bool isFirst) async {
    MyActivityState state = MyActivityInitial();
    await communityManager.myActivity(model, (data) {
      state = GetMyActivityState(data, isFirst);
    }, (fail) {
      state = MyActivityErrorState(fail.message, fail.isMessageLocalizationKey);
    });
    return state;
  }

  @override
  Future<MyActivityState> unEnrollMyActivity(String id, int position) async {
    MyActivityState state = MyActivityInitial();
    await communityManager.unEnrollActivity(id, (success) {
      state = UnEnrollState(position);
    }, (fail) {
      state = MyActivityErrorState(fail.message, fail.isMessageLocalizationKey);
    });
    return state;
  }

  @override
  Future<MyActivityState> reviewMyActivity(
      MyActivityRatingSendModel model, int position) async {
    MyActivityState state = MyActivityInitial();
    await communityManager.reviewActivity(model, (success) {
      state = SuccessfullyReviewState(position);
    }, (fail) {
      state = MyActivityErrorState(fail.message, fail.isMessageLocalizationKey);
    });
    return state;
  }
}
