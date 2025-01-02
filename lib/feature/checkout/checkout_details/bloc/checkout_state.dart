part of 'checkout_bloc.dart';

abstract class CheckoutDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckoutDetailsInitial extends CheckoutDetailsState {}

class CheckoutDetailsLoadingState extends CheckoutDetailsState {}

class CheckoutDetailsErrorState extends CheckoutDetailsState {
  final String errorMassage;
  final bool isLocalizationKey;
  CheckoutDetailsErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class CheckoutDetailsLoadedState extends CheckoutDetailsState {
  final CheckoutSheet response;
  CheckoutDetailsLoadedState(this.response);

  @override
  List<Object?> get props => [response];
}

class CheckoutBankDetailsFormValidatedState extends CheckoutDetailsState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class CheckoutBankDetailsFormNotValidatedState extends CheckoutDetailsState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ConfirmBankDetailsSentSuccessfullyState extends CheckoutDetailsState {
  ConfirmBankDetailsSentSuccessfullyState();

  @override
  List<Object> get props => [identityHashCode(this)];
}
