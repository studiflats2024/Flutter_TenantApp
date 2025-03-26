import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/CancelPlan/cancel_plan_model.dart';
import 'package:vivas/apis/models/_base/base_model.dart';

class PlanSettingsApiManager {
  DioApiManager dioApiManager;

  PlanSettingsApiManager(this.dioApiManager);

  Future cancelPlan(CancelPlanSendModel reasonModel,
      void Function(BaseMessageModel successModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.cancelPlan, queryParameters: reasonModel.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
      response.data as Map<String, dynamic>;
      BaseMessageModel wrapper = BaseMessageModel.fromJson(extractedData);
      success(wrapper);
    }).catchError((e) {
      fail(ErrorApiModel.identifyError(error: e.error));
    });
  }
}
