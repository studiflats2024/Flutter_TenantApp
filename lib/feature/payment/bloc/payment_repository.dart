import 'package:vivas/apis/managers/payment_api_manger.dart';
import 'package:vivas/feature/payment/bloc/payment_bloc.dart';

abstract class BasePaymentRepository {
  Future<PaymentState> getPaymentUrlApi(String uuid);
  Future<PaymentState> checkPayStatus(String url);
}

class PaymentRepository implements BasePaymentRepository {
  final PaymentApiManger paymentApiManger;

  PaymentRepository({
    required this.paymentApiManger,
  });

  @override
  Future<PaymentState> getPaymentUrlApi(String uuid) async {
    late PaymentState paymentState;

    await paymentApiManger.getPaymentUrlApi(uuid, false, (paymentUrl) {
      paymentState = PaymentUrlLoadedState(paymentUrl);
    }, (errorApiModel) {
      paymentState = PaymentErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return paymentState;
  }

  @override
  Future<PaymentState> checkPayStatus(String url) async{
    late PaymentState paymentState;

    await paymentApiManger.checkPayStatus(url, (status) {
      if(status == "Paid"){
        paymentState = PaymentPaidSuccessState(status);
      }else{
        paymentState = PaymentErrorState(
            status, true);
      }

    }, (errorApiModel) {
      paymentState = PaymentErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return paymentState;

  }
}
