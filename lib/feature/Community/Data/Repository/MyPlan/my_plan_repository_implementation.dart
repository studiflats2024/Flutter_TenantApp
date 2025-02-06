import 'dart:async';
import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/pay_subscription_send_model.dart';
import 'package:vivas/feature/Community/Data/Repository/MyPlan/my_plan_repository.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/MyPlan/my_plan_bloc.dart';

class MyPlanRepositoryImplementation implements MyPlanRepository {
  CommunityManager communityManager;

  MyPlanRepositoryImplementation(this.communityManager);

  @override
  Future<MyPlanState> getMyPlan() async {
    MyPlanState state = MyPlanInitial();

    await communityManager.getMyPlan((details) {
      state = GetMyPlanState(details);
    }, (fail) {
      state = ErrorMyPlanState(fail.message, fail.isMessageLocalizationKey);
    });
    return state;
  }

  @override
  Future<MyPlanState> paySubscriptionPlan(
      PaySubscriptionSendModel model) async {
    MyPlanState state = MyPlanInitial();
    await communityManager.paySubscriptionPlan(
      model,
      (success) {
        state = PaySubscribePlanSuccessState(success);
      },
      (fail) {
        state = ErrorMyPlanState(fail.message, fail.isMessageLocalizationKey);
      },
    );
    return state;
  }

}
