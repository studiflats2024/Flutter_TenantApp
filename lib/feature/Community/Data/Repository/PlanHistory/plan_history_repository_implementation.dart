import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/pay_subscription_send_model.dart';
import 'package:vivas/feature/Community/Data/Repository/PlanHistory/plan_history_repository.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/PlanHistory/plan_history_bloc.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/PlanInvoiceDetails/plan_invoice_details_bloc.dart';

class PlanHistoryRepositoryImplementation
    extends PlanHistoryRepository<PlanHistoryState, PlanInvoiceDetailsState> {
  CommunityManager communityManager;

  PlanHistoryRepositoryImplementation(this.communityManager);

  @override
  Future<PlanHistoryState> getMyHistory(PagingListSendModel model) async {
    PlanHistoryState state = PlanHistoryInitial();
    await communityManager.planHistoryTransaction(model, (success) {
      state = GetPlanHistory(
        success,
      );
    }, (fail) {
      state = ErrorPlanHistoryState(
        fail.message,
        fail.isMessageLocalizationKey,
      );
    });
    return state;
  }

  @override
  Future<PlanInvoiceDetailsState> getDetails(String planID) async {
    PlanInvoiceDetailsState state = PlanInvoiceDetailsInitial();
    await communityManager.planTransactionDetails(planID, (success) {
      state = GetInvoiceDetails(
        success,
      );
    }, (fail) {
      state = ErrorPlanInvoiceState(
        fail.message,
        fail.isMessageLocalizationKey,
      );
    });
    return state;
  }

  @override
  Future<PlanInvoiceDetailsState> paySubscriptionPlan(
      PaySubscriptionSendModel model) async {
    PlanInvoiceDetailsState state = PlanInvoiceDetailsInitial();
    await communityManager.paySubscriptionPlan(
      model,
      (success) {
        state = PaySubscribePlanSuccessState(success);
      },
      (fail) {
        state =
            ErrorPlanInvoiceState(fail.message, fail.isMessageLocalizationKey);
      },
    );
    return state;
  }
}
