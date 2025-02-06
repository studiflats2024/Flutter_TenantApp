import 'package:vivas/feature/Community/Data/Models/SendModels/pay_subscription_send_model.dart';

abstract class PayRepository<T> {
  Future<T> paySubscriptionPlan(PaySubscriptionSendModel model);
}
