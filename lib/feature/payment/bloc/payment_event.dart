part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class GetPaymentUrlApiEvent extends PaymentEvent {
  final String invoiceId;
  const GetPaymentUrlApiEvent(this.invoiceId);

  @override
  List<Object> get props => [invoiceId];
}

class CheckPaymentUrlApiEvent extends PaymentEvent {
  final String url;
  const CheckPaymentUrlApiEvent(this.url);

  @override
  List<Object> get props => [url];
}
