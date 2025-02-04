import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/pay_subscription_send_model.dart';
import 'package:vivas/feature/Community/Data/Repository/Plans/PlanDetails/plan_details_repository.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/Plans/PlanDetails/plan_details_bloc.dart';

class PlanDetailsRepositoryImplementation extends PlanDetailsRepository {
  CommunityManager communityManager;

  PlanDetailsRepositoryImplementation(this.communityManager);

  @override
  Future<PlanDetailsState> getPlanDetails(String planID) async {
    PlanDetailsState state = PlanDetailsInitial();
    await communityManager.getSubscriptionPlanDetails(planID, (planDetails) {
      state = GetPlanDetailsState(planDetails);
    }, (fail) {
      state = ErrorPlanDetails(fail.message, fail.isMessageLocalizationKey);
    });
    return state;
  }

  @override
  Future<PlanDetailsState> paySubscriptionPlan(PaySubscriptionSendModel model) async {
    PlanDetailsState state = PlanDetailsInitial();
   await communityManager.paySubscriptionPlan(
      model,
      (success) {
        state = PaySubscribePlanSuccessState(success);
      },
      (fail) {
        state = PayErrorPlanDetails(fail.message, fail.isMessageLocalizationKey);
      },
    );
    return state;
  }

  @override
  Future<PlanDetailsState> subscribePlan(String planID) async {
    PlanDetailsState state = PlanDetailsInitial();
   await communityManager.subscriptionPlan(
      planID,
      (successPlanDetailsModel) {
        state = SubscribePlanSuccessState(successPlanDetailsModel);
      },
      (fail) {
        state =
            PayErrorPlanDetails(fail.message ?? "", fail.isMessageLocalizationKey);
      },
    );
    return state;
  }
}
