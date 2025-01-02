part of 'checkout_bloc.dart';

abstract class CheckoutDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCheckoutSheetDetailsEvent extends CheckoutDetailsEvent {
  final String requestId;
  GetCheckoutSheetDetailsEvent(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class ValidateFormEvent extends CheckoutDetailsEvent {
  final GlobalKey<FormState> editFormKey;
  ValidateFormEvent(this.editFormKey);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ConfirmCheckoutBankDetailsEvent extends CheckoutDetailsEvent {
  final PostBankDetailsSendModel _bankDetailsSendModel;
  ConfirmCheckoutBankDetailsEvent(this._bankDetailsSendModel);

  @override
  List<Object> get props => [_bankDetailsSendModel];
}
