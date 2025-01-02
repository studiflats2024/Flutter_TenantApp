part of 'payment_bloc.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

final class PaymentInitial extends PaymentState {}

class PaymentUrlLoadedState extends PaymentState {
  final String paymentUrl;

  const PaymentUrlLoadedState(this.paymentUrl);
  @override
  List<Object> get props => [paymentUrl];
}

class PaymentPaidSuccessState extends PaymentState {
  final String status;

  const PaymentPaidSuccessState(this.status);
  @override
  List<Object> get props => [status];
}

class PaymentLoadingState extends PaymentState {}

class PaymentErrorState extends PaymentState {
  final String errorMassage;
  final bool isLocalizationKey;
  const PaymentErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}
